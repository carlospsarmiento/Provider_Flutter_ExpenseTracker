import 'package:finanzaspersonales/util/constants.dart';
import 'package:flutter/material.dart';

class CustomButtonPrimary extends StatelessWidget {

  final VoidCallback onPressed;
  final String text;

  const CustomButtonPrimary({
    super.key,
    required this.onPressed,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(fontSize: 18),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
