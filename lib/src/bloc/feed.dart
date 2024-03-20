import 'dart:async';
import 'package:feedtime/src/isar/report_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

class FeedState {
  final int counter;
  final Timer? timer;
  final ReportData todayData;
  final bool hasShownReminder;

  FeedState(this.counter, this.timer, this.todayData, this.hasShownReminder);
}

class FeedCubit extends Cubit<FeedState> {
  final Isar isar;

  FeedCubit({required this.isar})
      : super(FeedState(0, null, ReportData(), false));

  void loadTimer() {
    final todayData = fetchData();
    if (todayData != null) {
      emit(FeedState(todayData.screenTime, state.timer, todayData,
          state.hasShownReminder));
    }
    startTimer();
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      emit(FeedState(
          state.counter + 1, timer, state.todayData, state.hasShownReminder));
    });
  }

  void cancelTimer() {
    state.timer?.cancel();
  }

  void checkedHasShownReminder() {
    emit(FeedState(state.counter, state.timer, state.todayData, true));
  }

  Future<void> getTodayData() async {
    final todayData = fetchData();
    emit(FeedState(
        state.counter, state.timer, todayData, state.hasShownReminder));
  }

  Future<void> saveTodayData(int screenTime) async {
    cancelTimer();
    final todayData = await saveData(screenTime);
    emit(FeedState(
        state.counter, state.timer, todayData, state.hasShownReminder));
  }

  fetchData() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final reportData = isar.reportDatas
        .where()
        .filter()
        .dateTimeEqualTo(todayDate)
        .findFirstSync();
    return reportData;
  }

  saveData(int screenTime) async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final day = DateFormat('EEEE').format(todayDate);

    final reportData = isar.reportDatas
        .where()
        .filter()
        .dateTimeEqualTo(todayDate)
        .findFirstSync();

    if (reportData != null) {
      await isar.writeTxn(() async {
        reportData.screenTime = screenTime;
        await isar.reportDatas.put(reportData);
      });
      return reportData;
    } else {
      final newReport = ReportData()
        ..title = day
        ..dateTime = todayDate
        ..screenTime = screenTime;

      await isar.writeTxn(() async {
        await isar.reportDatas.put(newReport);
      });
      return newReport;
    }
  }
}
