import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/stamp_cards_viewmodel.dart';
import '../ui/brondix_tokens.dart';

class CardCreatorView extends StatefulWidget {
  const CardCreatorView({super.key});

  @override
  State<CardCreatorView> createState() => _CardCreatorViewState();
}

class _CardCreatorViewState extends State<CardCreatorView> {
  final _storeCtrl = TextEditingController();
  final _rewardCtrl = TextEditingController();
  String _category = 'Cafe';
  int _totalStamps = 8;

  void _submit() {
    if (_storeCtrl.text.isNotEmpty && _rewardCtrl.text.isNotEmpty) {
      context.read<StampCardsViewModel>().addCard(
            _storeCtrl.text,
            _category,
            _totalStamps,
            _rewardCtrl.text,
          );
      _storeCtrl.clear();
      _rewardCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New loyalty card added!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: BrondixTokens.cardBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create Custom Stamp Card', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              TextField(
                controller: _storeCtrl,
                decoration: const InputDecoration(labelText: 'Shop / Merchant Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _rewardCtrl,
                decoration: const InputDecoration(labelText: 'Full Card Reward (e.g. Free Pastry)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Expanded(child: Text('Category')),
                  DropdownButton<String>(
                    value: _category,
                    items: const [
                      DropdownMenuItem(value: 'Cafe', child: Text('Cafe')),
                      DropdownMenuItem(value: 'Bakery', child: Text('Bakery')),
                      DropdownMenuItem(value: 'Bookshop', child: Text('Bookshop')),
                      DropdownMenuItem(value: 'Barbershop', child: Text('Barbershop')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _category = val);
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Expanded(child: Text('Required Stamps to Reward')),
                  DropdownButton<int>(
                    value: _totalStamps,
                    items: const [6, 8, 10, 12].map((n) => DropdownMenuItem(value: n, child: Text('$n stamps'))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _totalStamps = val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrondixTokens.inkNavy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Add Loyalty Card'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
