import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.prefixText,
  });

  final TextEditingController? controller;
  final String label;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? prefixText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixText: prefixText,
        label: Text(label),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
