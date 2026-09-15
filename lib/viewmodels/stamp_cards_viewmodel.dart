import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/stamp_card_model.dart';

class StampCardsViewModel extends ChangeNotifier {
  final List<StampCard> _cards = [
    StampCard(
      id: 'c1',
      storeName: 'Artisan Pour Roastery',
      category: 'Specialty Coffee',
      totalRequired: 8,
      currentPunches: 6,
      rewardDescription: 'Free 12oz Single-Origin Chemex',
    ),
    StampCard(
      id: 'c2',
      storeName: 'Golden Crust Boulangerie',
      category: 'Artisan Bakery',
      totalRequired: 10,
      currentPunches: 9,
      rewardDescription: 'Free Sourdough Boule or Brioche',
    ),
    StampCard(
      id: 'c3',
      storeName: 'Corner Chapter Bookstore',
      category: 'Independent Books',
      totalRequired: 6,
      currentPunches: 4,
      rewardDescription: '30% Off Any Hardcover Book',
    ),
  ];

  final List<String> _redeemedRewards = [
    'Artisan Pour Roastery: Free Flat White (10 Sep)',
    'Golden Crust Boulangerie: Croissant (02 Sep)',
  ];

  StampCardsViewModel() {
    _loadPrefs();
  }

  List<StampCard> get cards => _cards;
  List<String> get redeemedRewards => _redeemedRewards;

  void punchCard(String id) {
    final card = _cards.firstWhere((c) => c.id == id);
    if (!card.isFull) {
      card.currentPunches++;
      notifyListeners();
    }
  }

  void redeemCard(String id) {
    final card = _cards.firstWhere((c) => c.id == id);
    if (card.isFull) {
      _redeemedRewards.insert(0, '${card.storeName}: ${card.rewardDescription}');
      card.currentPunches = 0;
      notifyListeners();
    }
  }

  void addCard(String storeName, String category, int total, String reward) {
    _cards.add(
      StampCard(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        storeName: storeName,
        category: category,
        totalRequired: total,
        currentPunches: 0,
        rewardDescription: reward,
      ),
    );
    notifyListeners();
  }

  Future<void> _loadPrefs() async {
    await SharedPreferences.getInstance();
    notifyListeners();
  }
}
