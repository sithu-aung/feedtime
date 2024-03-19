import 'package:feedtime/src/isar/report_data.dart';
import 'package:feedtime/src/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [ReportDataSchema],
    directory: dir.path,
  );
  var sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefProvider.overrideWith((ref) => sharedPrefs),
        isarProvider.overrideWith((ref) => isar)
      ],
      child: const MyApp(),
    ),
  );
}
