import 'package:feedtime/src/constants/constants.dart';
import 'package:flutter/material.dart';

class CommonRadios extends StatefulWidget {
  const CommonRadios(
      {super.key,
      required this.items,
      required this.selectedItem,
      required this.onChanged});
  final List<String> items;
  final Function onChanged;
  final int selectedItem;

  @override
  State<CommonRadios> createState() => _CommonRadiosState();
}

class _CommonRadiosState extends State<CommonRadios> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              widget.onChanged(index);
            },
            child: SizedBox(
              height: 52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.items[index],
                    style: const TextStyle(
                        fontSize: 18,
                        color: greenDarkColor,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 24,
                    child: Radio(
                      groupValue: widget.selectedItem,
                      value: index,
                      activeColor: greenDarkColor,
                      onChanged: (value) {
                        widget.onChanged(index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
