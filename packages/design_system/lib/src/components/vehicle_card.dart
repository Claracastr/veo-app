import 'package:flutter/material.dart';
import '../theme/veo_theme.dart';

class VeoVehicleCard extends StatelessWidget {
  final String name, location, imageUrl;
  final double price, rating;
  final String transmission;
  final VoidCallback? onTap;
  const VeoVehicleCard(
      {super.key,
      required this.name,
      required this.location,
      required this.imageUrl,
      required this.price,
      required this.rating,
      required this.transmission,
      this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: VeoColors.line)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(23)),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => Container(
                    color: const Color(0xFFE0EADD),
                    child: const Icon(Icons.directions_car_filled,
                        size: 72, color: VeoColors.forest),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                        child: Text(name,
                            style: Theme.of(context).textTheme.titleMedium)),
                    const Icon(Icons.star_rounded,
                        size: 18, color: Color(0xFFE4A923)),
                    Text(rating.toStringAsFixed(1))
                  ]),
                  const SizedBox(height: 5),
                  Text(location,
                      style: const TextStyle(color: VeoColors.muted)),
                  const SizedBox(height: 14),
                  Row(children: [
                    const Icon(Icons.settings_outlined,
                        size: 17, color: VeoColors.muted),
                    const SizedBox(width: 6),
                    Text(transmission),
                    const Spacer(),
                    Text('R\$ ${price.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 19)),
                    const Text(' /dia',
                        style: TextStyle(color: VeoColors.muted))
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
