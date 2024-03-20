import 'package:feedtime/src/isar/report_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

abstract class ReportState {}

class ReportInitialState extends ReportState {}

class ReportLoadedState extends ReportState {
  final List<ReportData> reportData;

  ReportLoadedState(this.reportData);
}

class ReportCubit extends Cubit<ReportState> {
  final Isar isar;

  ReportCubit({required this.isar}) : super(ReportInitialState());

  void fetchLastWeekData() async {
    final lastWeekData =
        await isar.reportDatas.where().sortByDateTime().limit(7).findAll();
    emit(ReportLoadedState(lastWeekData));
  }
}
