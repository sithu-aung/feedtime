import 'package:isar/isar.dart';

part 'report_data.g.dart';

@collection
class ReportData {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  String? title;
  DateTime? dateTime;
  int? screenTime;
}
