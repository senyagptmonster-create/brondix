import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/stamp_cards_viewmodel.dart';
import '../ui/brondix_tokens.dart';

class StampCardsView extends StatelessWidget {
  const StampCardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StampCardsViewModel>();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vm.cards.length,
      itemBuilder: (context, idx) {
        final card = vm.cards[idx];

        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: BrondixTokens.cardBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(card.storeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(card.category, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text('${card.currentPunches}/${card.totalRequired}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: BrondixTokens.inkNavy)),
                  ],
                ),
                const SizedBox(height: 16),
                // Stamp grid circles
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(card.totalRequired, (i) {
                    final isStamped = i < card.currentPunches;
                    return GestureDetector(
                      onTap: () => vm.punchCard(card.id),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isStamped ? BrondixTokens.stampRed : BrondixTokens.kraftPaper,
                          border: Border.all(
                            color: isStamped ? BrondixTokens.stampRed : BrondixTokens.cardBorder,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          isStamped ? Icons.verified : Icons.add,
                          color: isStamped ? Colors.white : Colors.grey.shade400,
                          size: 20,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text('Reward: ${card.rewardDescription}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: BrondixTokens.leatherBrown)),
                    ),
                    if (card.isFull)
                      ElevatedButton(
                        onPressed: () => vm.redeemCard(card.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BrondixTokens.stampRed,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Redeem'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
