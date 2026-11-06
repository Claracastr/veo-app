import 'package:flutter/material.dart';
class VeoTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  const VeoTextField({super.key, required this.label, this.controller, this.hint, this.prefixIcon, this.obscureText = false, this.keyboardType, this.onChanged});
  @override Widget build(BuildContext context) => TextField(controller: controller, obscureText: obscureText,
    keyboardType: keyboardType, onChanged: onChanged,
    decoration: InputDecoration(labelText: label, hintText: hint, prefixIcon: prefixIcon == null ? null : Icon(prefixIcon)));
}
