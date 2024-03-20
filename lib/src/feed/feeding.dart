import 'package:feedtime/src/bloc/feed.dart';
import 'package:feedtime/src/report/report.dart';
import 'package:feedtime/src/report/widgets/common_button.dart';
import 'package:feedtime/src/report/widgets/reminder_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedingScreen extends StatefulWidget {
  const FeedingScreen({super.key});

  @override
  State<FeedingScreen> createState() => _FeedingScreenState();
}

class _FeedingScreenState extends State<FeedingScreen> {
  int reminderMinute = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getReminderMinute();
      context.read<FeedCubit>().loadTimer();
    });
    super.initState();
  }

  getReminderMinute() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    reminderMinute = sharedPrefs.getInt('reminderMins') ?? 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedCubit, FeedState>(listener: (context, state) {
      if (reminderMinute != 0) {
        if (state.counter == (reminderMinute * 60) && !state.hasShownReminder) {
          context.read<FeedCubit>().saveTodayData(state.counter);
          context.read<FeedCubit>().checkedHasShownReminder();
          showDialog(
            context: context,
            builder: (context) => ReminderDialog(
              reminderMin: reminderMinute,
              onTap: () {
                context.read<FeedCubit>().loadTimer();
              },
            ),
          );
        }
      }
    }, child: BlocBuilder<FeedCubit, FeedState>(builder: (context, state) {
      return Center(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Center(
                child: Text(
                  state.counter != 0 ? parseTime(state.counter) : "",
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
                      context.read<FeedCubit>().saveTodayData(state.counter);
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const ReportScreen();
                      }));
                      context.read<FeedCubit>().loadTimer();
                    },
                    title: AppLocalizations.of(context)!.check_time_spent_graph,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }));
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
