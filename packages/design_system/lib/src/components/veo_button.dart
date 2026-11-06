import 'package:flutter/material.dart';
import '../theme/veo_theme.dart';
class VeoButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool secondary;
  final bool loading;
  final IconData? icon;
  const VeoButton({super.key, required this.label, this.onPressed, this.secondary = false, this.loading = false, this.icon});
  @override Widget build(BuildContext context) => SizedBox(width: double.infinity, height: 56,
    child: FilledButton(onPressed: loading ? null : onPressed,
      style: FilledButton.styleFrom(backgroundColor: secondary ? VeoColors.mint : VeoColors.forest,
        foregroundColor: secondary ? VeoColors.ink : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17))),
      child: loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min,
        children: [if (icon != null) ...[Icon(icon, size: 19), const SizedBox(width: 8)], Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))])));
}
