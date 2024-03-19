import 'package:feedtime/src/isar/report_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefProvider = StateProvider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final isarProvider = StateProvider<Isar>((ref) {
  throw UnimplementedError();
});

final reminderMinutesProvider = StateProvider<int>((ref) {
  var sharedPrefs = ref.watch(sharedPrefProvider);
  return sharedPrefs.getInt('reminderMins') ?? 0;
});

final lastWeekDataProvider = FutureProvider<List<ReportData>>((ref) {
  var isar = ref.watch(isarProvider);
  final lastWeedData = isar.reportDatas
      .where()
      .sortByDateTime() // use index
      .limit(7)
      .findAll()
      .then((value) {
    return value;
  });
  return lastWeedData;
});
