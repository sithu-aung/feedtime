import 'package:feedtime/src/bloc/feed.dart';
import 'package:feedtime/src/bloc/report.dart';
import 'package:feedtime/src/isar/report_data.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [ReportDataSchema],
    directory: dir.path,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FeedCubit(isar: isar)),
        BlocProvider(create: (context) => ReportCubit(isar: isar)),
      ],
      child: const MyApp(),
    ),
  );
}
