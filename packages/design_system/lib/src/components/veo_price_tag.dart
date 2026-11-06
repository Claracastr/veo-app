import 'package:flutter/material.dart';
import '../theme/veo_theme.dart';

class VeoPriceTag extends StatelessWidget {
 final double price;
 final String suffix;
 const VeoPriceTag({super.key, required this.price, this.suffix = 'dia'});
 @override Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic,
  children: [
   Text('R\$ ${price.toStringAsFixed(0)}', style: const TextStyle(
    fontSize: 20, fontWeight: FontWeight.w900, color: VeoColors.forest)),
   const SizedBox(width: 4),
   Text('/$suffix', style: const TextStyle(color: VeoColors.muted, fontSize: 12)),
  ]);
}
