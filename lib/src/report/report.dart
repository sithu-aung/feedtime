import 'package:feedtime/src/bloc/report.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:feedtime/src/constants/constants.dart';
import 'package:feedtime/src/report/widgets/common_button.dart';
import 'package:feedtime/src/report/widgets/common_radios.dart';
import 'package:feedtime/src/report/widgets/time_spent_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  var selectedOption = 0;

  @override
  void initState() {
    context.read<ReportCubit>().fetchLastWeekData();
    getReminderMinute();
    super.initState();
  }

  getReminderMinute() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    var reminderMinute = sharedPrefs.getInt('reminderMins') ?? 1;
    setState(() {
      selectedOption = reminderMins.indexOf(reminderMinute);
    });
  }

  setReminderMinute(int reminderMins) async {
    var sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setInt("reminderMins", reminderMins);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/timer.png",
                width: 24,
                color: greenDarkColor,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.time_spent,
                  style: const TextStyle(
                    fontSize: 18,
                    color: greenDarkColor,
                  ),
                ),
              ),
              40.hGap
            ],
          )),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            30.vGap,
            BlocBuilder<ReportCubit, ReportState>(
              builder: (context, state) {
                if (state is ReportLoadedState) {
                  final data = state.reportData;
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      TimeSpentChart(
                        reports: data,
                      ),
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 0, right: 30),
                          child: Text(
                            "(Today)",
                            style: TextStyle(
                              fontSize: 12,
                              color: greenDarkColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Center(
                        child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(),
                    )),
                  );
                }
              },
            ),
            20.vGap,
            const Divider(),
            20.vGap,
            Padding(
              padding: const EdgeInsets.all(30),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [
                            StatefulBuilder(builder: (BuildContext context,
                                StateSetter
                                    setModalState /*You can rename this!*/) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, top: 20, bottom: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () => Navigator.of(context).pop(),
                                      child: const Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(Icons.close)),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .set_reminder,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: greenDarkColor,
                                      ),
                                    ),
                                    12.vGap,
                                    Text(
                                      AppLocalizations.of(context)!
                                          .friendly_reminder,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    8.vGap,
                                    const Divider(),
                                    CommonRadios(
                                      selectedItem: selectedOption,
                                      items: items,
                                      onChanged: (index) {
                                        setModalState(() {
                                          selectedOption = index;
                                        });
                                      },
                                    ),
                                    50.vGap,
                                    CommonButton(
                                      onPressed: () async {
                                        setReminderMinute(
                                            reminderMins[selectedOption]);

                                        Navigator.of(context).pop();
                                      },
                                      title: AppLocalizations.of(context)!.done,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        );
                      });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.set_reminder,
                        style: const TextStyle(
                          fontSize: 18,
                          color: greenDarkColor,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: greenDarkColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
