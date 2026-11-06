import 'package:flutter/material.dart';
import '../theme/veo_theme.dart';

class VeoStatusBadge extends StatelessWidget {
 final String status;
 const VeoStatusBadge({super.key, required this.status});
 @override Widget build(BuildContext context) {
  final cancelled = status == 'cancelled';
  final confirmed = status == 'confirmed';
  final color = cancelled ? VeoColors.danger : (confirmed ? VeoColors.forest : const Color(0xFF956300));
  final text = cancelled ? 'Cancelada' : confirmed ? 'Confirmada' : 'Pendente';
  return Container(
   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
   decoration: BoxDecoration(color: color.withOpacity(.10), borderRadius: BorderRadius.circular(22)),
   child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color)),
  );
 }
}
