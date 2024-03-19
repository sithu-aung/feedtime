import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({super.key, required this.onPressed, required this.title});
  final Function? onPressed;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.green,
        ),
        fixedSize: MaterialStateProperty.all(
          Size(MediaQuery.sizeOf(context).width * 0.86, 56),
        ),
        elevation: MaterialStateProperty.all(4),
      ),
      onPressed: () async {
        if (onPressed != null) {
          onPressed?.call();
        }
      },
      child: Text(
        title ?? "",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
