import 'package:flutter/material.dart';
import '../app/brand.dart';
import '../app/theme.dart';
import 'brondix_store.dart';

class BrondixMainScreen extends StatefulWidget {
  const BrondixMainScreen({super.key});
  @override
  _BrondixMainScreenState createState() => _BrondixMainScreenState();
}

class _BrondixMainScreenState extends State<BrondixMainScreen> {
  final PageController _pageController = PageController();
  final BrondixStore _store = BrondixStore();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _store.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Brondix Stamp Cards', style: AppTheme.display(cInk)),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  _buildCardsScreen(),
                  _buildCreatorScreen(),
                  _buildHistoryScreen(),
                  _buildLocationsScreen(),
                ],
              ),
            ),
            _buildDots(),
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: _currentIndex == index ? 12.0 : 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              color: _currentIndex == index ? cAccent : cEdge,
              borderRadius: BorderRadius.circular(4.0),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCardsScreen() {
    if (_store.cards.isEmpty) {
      return Center(child: Text('No stamp cards.', style: AppTheme.text(cInk)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _store.cards.length,
      itemBuilder: (context, index) {
        final card = _store.cards[index];
        return Card(
          color: cSurface,
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(card['shop'], style: AppTheme.display(cInk)),
                const SizedBox(height: 8),
                Text('Reward: ${card['reward']}', style: AppTheme.text(cAccent2)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(card['total'], (pIndex) {
                    bool punched = pIndex < card['punches'];
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: punched ? cAccent : cBg,
                        shape: BoxShape.circle,
                        border: Border.all(color: cEdge),
                      ),
                      child: Icon(Icons.star, color: punched ? cSurface : cEdge, size: 20),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: cAccent),
                  onPressed: () => _store.addPunch(index),
                  child: Text('Add Punch', style: AppTheme.text(cSurface)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCreatorScreen() {
    final shopCtrl = TextEditingController();
    final rewardCtrl = TextEditingController();
    final totalCtrl = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Create New Card', style: AppTheme.display(cInk)),
          const SizedBox(height: 16),
          TextField(controller: shopCtrl, decoration: InputDecoration(labelText: 'Shop Name', fillColor: cSurface, filled: true)),
          const SizedBox(height: 8),
          TextField(controller: rewardCtrl, decoration: InputDecoration(labelText: 'Reward', fillColor: cSurface, filled: true)),
          const SizedBox(height: 8),
          TextField(controller: totalCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Total Punches', fillColor: cSurface, filled: true)),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: cAccent),
            onPressed: () {
              if (shopCtrl.text.isNotEmpty && rewardCtrl.text.isNotEmpty && totalCtrl.text.isNotEmpty) {
                _store.addCard({
                  'shop': shopCtrl.text,
                  'reward': rewardCtrl.text,
                  'total': int.parse(totalCtrl.text),
                  'punches': 0,
                });
              }
            },
            child: Text('Save Card', style: AppTheme.text(cSurface)),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryScreen() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _store.history.length,
      itemBuilder: (context, index) {
        final hist = _store.history[index];
        return ListTile(
          tileColor: cSurface,
          title: Text(hist['reward'], style: AppTheme.text(cInk)),
          subtitle: Text('${hist['shop']} - ${hist['date']}', style: AppTheme.text(cAccent2)),
          leading: Icon(Icons.card_giftcard, color: cAccent),
        );
      },
    );
  }

  Widget _buildLocationsScreen() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _store.locations.length,
      itemBuilder: (context, index) {
        final loc = _store.locations[index];
        return Card(
          color: cSurface,
          child: ListTile(
            title: Text(loc['name'], style: AppTheme.text(cInk)),
            subtitle: Text(loc['address'], style: AppTheme.text(cAccent2)),
            trailing: Icon(Icons.location_on, color: cAccent),
          ),
        );
      },
    );
  }
}
