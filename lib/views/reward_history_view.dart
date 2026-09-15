import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/stamp_cards_viewmodel.dart';
import '../ui/brondix_tokens.dart';

class RewardHistoryView extends StatelessWidget {
  const RewardHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StampCardsViewModel>();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vm.redeemedRewards.length,
      itemBuilder: (context, idx) {
        final item = vm.redeemedRewards[idx];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: BrondixTokens.cardBorder),
          ),
          child: ListTile(
            leading: const Icon(Icons.card_giftcard, color: BrondixTokens.stampRed),
            title: Text(item, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ),
        );
      },
    );
  }
}
