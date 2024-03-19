import 'package:feedtime/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReminderDialog extends StatelessWidget {
  const ReminderDialog({
    super.key,
    this.reminderMin,
    required this.onTap,
  });
  final int? reminderMin;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: greenWhiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(20),
      content: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context).pop();
                if (onTap != null) {
                  onTap?.call();
                }
              },
              child: const Align(
                  alignment: Alignment.topRight, child: Icon(Icons.close)),
            ),
            60.vGap,
            Text(
              AppLocalizations.of(context)!.times_up,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            12.vGap,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${AppLocalizations.of(context)!.spent} $reminderMin ${AppLocalizations.of(context)!.scrolling_time}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: greenDarkColor,
                ),
              ),
            ),
            30.vGap,
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context).pop();
                if (onTap != null) {
                  onTap?.call();
                }
              },
              child: Text(
                AppLocalizations.of(context)!.remind_later,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
            ),
            30.vGap
          ],
        ),
      ),
    );
  }
}
