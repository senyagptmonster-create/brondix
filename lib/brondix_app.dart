import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/brondix_tokens.dart';
import 'viewmodels/stamp_cards_viewmodel.dart';
import 'views/stamp_cards_view.dart';
import 'views/card_creator_view.dart';
import 'views/reward_history_view.dart';
import 'views/shop_locations_view.dart';

class BrondixApp extends StatelessWidget {
  const BrondixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StampCardsViewModel(),
      child: MaterialApp(
        title: 'Brondix Loyalty Punch',
        theme: BrondixTokens.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const BrondixHomeScaffold(),
      ),
    );
  }
}

class BrondixHomeScaffold extends StatefulWidget {
  const BrondixHomeScaffold({super.key});

  @override
  State<BrondixHomeScaffold> createState() => _BrondixHomeScaffoldState();
}

class _BrondixHomeScaffoldState extends State<BrondixHomeScaffold> {
  int _currentIndex = 0;

  final _titles = ['Stamp Cards', 'New Card', 'Redemptions', 'Merchant Directory'];
  final _views = const [
    StampCardsView(),
    CardCreatorView(),
    RewardHistoryView(),
    ShopLocationsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
      ),
      body: _views[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.credit_card_outlined), selectedIcon: Icon(Icons.credit_card), label: 'Cards'),
          NavigationDestination(icon: Icon(Icons.add_box_outlined), selectedIcon: Icon(Icons.add_box), label: 'Create'),
          NavigationDestination(icon: Icon(Icons.card_giftcard_outlined), selectedIcon: Icon(Icons.card_giftcard), label: 'Rewards'),
          NavigationDestination(icon: Icon(Icons.store_outlined), selectedIcon: Icon(Icons.store), label: 'Shops'),
        ],
      ),
    );
  }
}
