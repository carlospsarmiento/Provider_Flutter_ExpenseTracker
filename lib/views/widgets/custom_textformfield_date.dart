import 'package:finanzaspersonales/util/date_helper.dart';
import 'package:flutter/material.dart';

class CustomTextFormFieldDate extends StatelessWidget {

  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;

  const CustomTextFormFieldDate({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator
  });

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      controller.text = DateHelper.formatearDesdeDatabase(selectedDate.toIso8601String());
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ),
      onTap: () => _selectDate(context),
      readOnly: true,
      validator: validator
    );
  }
}