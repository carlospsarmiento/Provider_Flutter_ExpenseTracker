import 'package:flutter/material.dart';

class CustomDropdownString extends StatelessWidget {

  final String? value;
  final String labelText;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownString({
    super.key,
    this.value,
    required this.labelText,
    required this.items,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}
