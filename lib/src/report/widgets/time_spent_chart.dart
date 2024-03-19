import 'package:d_chart/bar_custom/view.dart';
import 'package:feedtime/src/constants/constants.dart';
import 'package:feedtime/src/isar/report_data.dart';
import 'package:flutter/material.dart';

class TimeSpentChart extends StatefulWidget {
  const TimeSpentChart({super.key, required this.reports});
  final List<ReportData> reports;

  @override
  State<TimeSpentChart> createState() => _TimeSpentChartState();
}

class _TimeSpentChartState extends State<TimeSpentChart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: DChartBarCustom(
          loadingDuration: const Duration(milliseconds: 500),
          valueAlign: Alignment.topCenter,
          showDomainLine: true,
          showDomainLabel: true,
          showMeasureLine: false,
          showMeasureLabel: false,
          spaceDomainLabeltoChart: 10,
          spaceMeasureLabeltoChart: 5,
          spaceDomainLinetoChart: 0,
          spaceMeasureLinetoChart: 20,
          valuePadding: const EdgeInsets.only(bottom: 80),
          spaceBetweenItem: 4,
          radiusBar: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          measureLabelStyle: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          domainLabelStyle: const TextStyle(
            fontSize: 14,
            color: greenDarkColor,
          ),
          measureLineStyle: const BorderSide(color: Colors.amber, width: 2),
          domainLineStyle: const BorderSide(
              color: Color.fromARGB(255, 233, 231, 231), width: 8),
          max: calculateMaxValue(),
          listData: List.generate(widget.reports.length, (index) {
            var max = calculateMaxValue();

            Color? currentColor;
            // divide three color level based on max value
            if (widget.reports[index].screenTime! < max / 3) {
              currentColor = greenPaleColor;
            } else if (widget.reports[index].screenTime! < max / 1.5) {
              currentColor = greenMediumColor;
            } else {
              currentColor = greenNormalColor;
            }

            return DChartBarDataCustom(
              onTap: () {
                //show tooltip
              },
              value: widget.reports[index].screenTime!.toDouble(),
              label: widget.reports[index].title ?? "",
              color: currentColor.withOpacity(1),
              splashColor: Colors.green,
              showValue: true,
              valueStyle: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
              valueCustom: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    parseTime(widget.reports[index].screenTime ?? 0),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              valueTooltip: parseTime(widget.reports[index].screenTime ?? 0),
            );
          }),
        ),
      ),
    );
  }

  calculateMaxValue() {
    double max = 0;
    for (var report in widget.reports) {
      if (report.screenTime! > max) {
        max = report.screenTime!.toDouble();
      }
    }
    return max;
  }

  String parseTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    String hourText = hours != 0 ? "${hours}h " : "";
    String minuteText = "${minutes}m ";
    String secondText = remainingSeconds != 0 ? "${remainingSeconds}s " : "";
    return "$hourText$minuteText$secondText";
  }
}
