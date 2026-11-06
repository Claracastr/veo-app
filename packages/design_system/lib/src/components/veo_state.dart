import 'package:flutter/material.dart';
import 'veo_button.dart';
class VeoState extends StatelessWidget {
 final IconData icon; final String title; final String message; final String? action; final VoidCallback? onAction;
 const VeoState({super.key, required this.icon, required this.title, required this.message, this.action, this.onAction});
 @override Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisSize: MainAxisSize.min,
   children: [Icon(icon, size: 55), const SizedBox(height: 20), Text(title, style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 8), Text(message, textAlign: TextAlign.center), if (action != null) ...[const SizedBox(height: 20), VeoButton(label: action!, onPressed: onAction)]])));
}
