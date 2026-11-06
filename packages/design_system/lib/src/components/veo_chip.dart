import 'package:flutter/material.dart';
import '../theme/veo_theme.dart';
class VeoChip extends StatelessWidget {
 final String text; final IconData? icon; final bool selected; final VoidCallback? onTap;
 const VeoChip({super.key, required this.text, this.icon, this.selected = false, this.onTap});
 @override Widget build(BuildContext context) => ActionChip(onPressed: onTap, backgroundColor: selected ? VeoColors.mint : Colors.white,
   side: BorderSide(color: selected ? VeoColors.mint : VeoColors.line), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
   avatar: icon == null ? null : Icon(icon, size: 16), label: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)));
}
