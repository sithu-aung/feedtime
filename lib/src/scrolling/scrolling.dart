import 'dart:async';
import 'dart:math';
import 'package:feedtime/src/isar/report_data.dart';
import 'package:feedtime/src/providers/providers.dart';
import 'package:feedtime/src/report/report.dart';
import 'package:feedtime/src/report/widgets/common_button.dart';
import 'package:feedtime/src/report/widgets/reminder_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScrollingScreen extends ConsumerStatefulWidget {
  const ScrollingScreen({super.key});

  @override
  ConsumerState<ScrollingScreen> createState() => _ScrollingScreenState();
}

class _ScrollingScreenState extends ConsumerState<ScrollingScreen> {
  Timer? _timer;
  int _counter = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      addDemoData();
      loadTimer();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Text(
              _counter != 0 ? parseTime(_counter) : "",
              style: const TextStyle(
                fontSize: 26,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: CommonButton(
                onPressed: () async {
                  _timer!.cancel();
                  saveTodayData();
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return const ReportScreen();
                  }));
                  loadTimer();
                },
                title: AppLocalizations.of(context)!.check_time_spent_graph,
              ),
            ),
          )
        ],
      ),
    );
  }

  loadTimer() {
    var todayData = getTodayData();
    if (todayData != null) {
      setState(() {
        _counter = todayData.screenTime;
      });
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _counter++;
      });
      checkReminder();
    });
  }

  addDemoData() async {
    final isar = ref.watch(isarProvider);

    // await isar.writeTxn(() async {
    //   isar.reportDatas.where().sortByDateTime().limit(7).deleteAll();
    // });

    isar.reportDatas
        .where()
        .sortByDateTime()
        .limit(7)
        .findAll()
        .then((value) async {
      if (value.isEmpty) {
        final today = DateTime.now();

        final random = Random();
        const minScreenTime = 40;
        const maxScreenTime = 180;

        const limit1Hour = 60;
        const limit2Hours = 120;

        int countUnder1Hour = 0;
        int countUnder2Hours = 0;
        List<int> indicesUnder1Hour = [];
        List<int> indicesUnder2Hours = [];

        for (int i = 6; i >= 0; i--) {
          final date = DateTime(today.year, today.month, today.day - i);
          int screenTime;

          if (countUnder1Hour < 2 &&
              (indicesUnder1Hour.isEmpty ||
                  (i - indicesUnder1Hour.last).abs() > 1)) {
            screenTime =
                minScreenTime + random.nextInt(limit1Hour - minScreenTime);
            countUnder1Hour++;
            indicesUnder1Hour.add(i);
          } else if (countUnder2Hours < 2 &&
              (indicesUnder2Hours.isEmpty ||
                  (i - indicesUnder2Hours.last).abs() > 1)) {
            screenTime = limit1Hour + random.nextInt(limit2Hours - limit1Hour);
            countUnder2Hours++;
            indicesUnder2Hours.add(i);
          } else {
            screenTime =
                limit2Hours + random.nextInt(maxScreenTime - limit2Hours + 1);
          }
          final newReport = ReportData()
            ..title = DateFormat('EEE').format(date)
            ..dateTime = date
            ..screenTime = screenTime * 60;

          await isar.writeTxn(() async {
            await isar.reportDatas.put(newReport);
          });
          ref.invalidate(lastWeekDataProvider);
        }
      }
    });
  }

  checkReminder() {
    int reminderMinute = ref.watch(reminderMinutesProvider);

    if (reminderMinute != 0) {
      if (_counter == (reminderMinute * 60)) {
        _timer!.cancel();
        saveTodayData();
        showDialog(
          context: context,
          builder: (context) => ReminderDialog(
            reminderMin: reminderMinute,
            onTap: () {
              loadTimer();
            },
          ),
        );
      }
    }
  }

  getTodayData() {
    final isar = ref.watch(isarProvider);
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final reportData = isar.reportDatas
        .where()
        .filter()
        .dateTimeEqualTo(todayDate)
        .findFirstSync();
    return reportData;
  }

  saveTodayData() async {
    final isar = ref.watch(isarProvider);

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
        reportData.screenTime = _counter;
        await isar.reportDatas.put(reportData);
      });
    } else {
      final newReport = ReportData()
        ..title = day
        ..dateTime = todayDate
        ..screenTime = _counter;

      await isar.writeTxn(() async {
        await isar.reportDatas.put(newReport);
      });
    }
    ref.invalidate(lastWeekDataProvider);
  }

  String parseTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    String hourText = hours != 0 ? "${hours}h " : "";
    String minuteText = minutes != 0 ? "${minutes}min " : "";
    String secondText = remainingSeconds != 0 ? "${remainingSeconds}s " : "";
    return "$hourText$minuteText${secondText}passed";
  }
}
