import 'package:flutter/material.dart';
import '../ui/brondix_tokens.dart';

class ShopLocationsView extends StatelessWidget {
  const ShopLocationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final spots = [
      {'name': 'Artisan Pour Roastery', 'dist': '0.3 mi', 'addr': '412 Maple Ave, Downtown'},
      {'name': 'Golden Crust Boulangerie', 'dist': '0.7 mi', 'addr': '88 North Pine St'},
      {'name': 'Corner Chapter Bookstore', 'dist': '1.2 mi', 'addr': '104 Library Way'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: spots.length,
      itemBuilder: (context, idx) {
        final s = spots[idx];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: BrondixTokens.cardBorder),
          ),
          child: ListTile(
            leading: const Icon(Icons.storefront, color: BrondixTokens.leatherBrown),
            title: Text(s['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(s['addr']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            trailing: Text(s['dist']!, style: const TextStyle(fontWeight: FontWeight.bold, color: BrondixTokens.stampRed)),
          ),
        );
      },
    );
  }
}
