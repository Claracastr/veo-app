import 'package:flutter/material.dart';
class VeoSectionTitle extends StatelessWidget {
 final String title; final String? action; final VoidCallback? onAction;
 const VeoSectionTitle({super.key, required this.title, this.action, this.onAction});
 @override Widget build(BuildContext context) => Row(children: [Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)), if (action != null) TextButton(onPressed: onAction, child: Text(action!))]);
}
