import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/loyalty_card_item.dart';

class LoyaltyPunchViewModel extends ChangeNotifier {
  static const String _cardsStorageKey = 'brondix_loyalty_cards_v1';
  static const String _historyStorageKey = 'brondix_redeemed_history_v1';

  List<LoyaltyCardItem> _cards = [];
  List<PunchRecordItem> _redeemedRecords = [];
  bool _isLoading = true;
  String _selectedCategoryFilter = 'All';
  String _shopSearchQuery = '';

  List<LoyaltyCardItem> get cards => List.unmodifiable(_cards);
  List<PunchRecordItem> get redeemedRecords => List.unmodifiable(_redeemedRecords);
  bool get isLoading => _isLoading;
  String get selectedCategoryFilter => _selectedCategoryFilter;
  String get shopSearchQuery => _shopSearchQuery;

  int get totalPunchesCollected {
    return _cards.fold(0, (sum, card) => sum + card.currentPunches);
  }

  int get rewardsAvailableCount {
    return _cards.where((card) => card.isRewardReady).length;
  }

  final List<ShopLocationItem> _mockShops = const [
    ShopLocationItem(
      id: 'shop-1',
      name: 'Morning Brew Café',
      category: 'Coffee',
      address: '427 Artisan Lane, Timber District',
      businessHours: 'Mon - Sun: 06:30 AM - 07:00 PM',
      phone: '+1 (555) 234-8891',
      rating: 4.9,
      hasStampMultiplier: true,
      perkText: 'Double stamps on Tuesday mornings!',
    ),
    ShopLocationItem(
      id: 'shop-2',
      name: 'Golden Crust Bakery',
      category: 'Bakery',
      address: '112 Millstone Way, Heritage Square',
      businessHours: 'Tue - Sun: 07:00 AM - 04:00 PM',
      phone: '+1 (555) 872-1044',
      rating: 4.8,
      hasStampMultiplier: false,
      perkText: 'Free croissant on 3rd stamp milestone.',
    ),
    ShopLocationItem(
      id: 'shop-3',
      name: 'Ink & Page Books',
      category: 'Bookshop',
      address: '89 Quill Boulevard, Scholar Row',
      businessHours: 'Mon - Sat: 09:30 AM - 08:30 PM',
      phone: '+1 (555) 901-3267',
      rating: 4.9,
      hasStampMultiplier: true,
      perkText: 'Triple stamps on poetry & fiction Saturdays.',
    ),
    ShopLocationItem(
      id: 'shop-4',
      name: 'Velvet Bean Roastery',
      category: 'Coffee',
      address: '604 Copper St, Harbor Wharf',
      businessHours: 'Mon - Sun: 07:00 AM - 06:00 PM',
      phone: '+1 (555) 438-7719',
      rating: 4.7,
      hasStampMultiplier: false,
      perkText: 'Complimentary single-origin drip on enrollment.',
    ),
    ShopLocationItem(
      id: 'shop-5',
      name: 'Cinnamon & Rye Bakehouse',
      category: 'Bakery',
      address: '235 Hearthstone Ave, Old Quarter',
      businessHours: 'Wed - Sun: 06:00 AM - 03:00 PM',
      phone: '+1 (555) 674-8820',
      rating: 4.9,
      hasStampMultiplier: true,
      perkText: 'Free sourdough starter jar on card completion.',
    ),
  ];

  List<ShopLocationItem> get filteredShops {
    return _mockShops.where((shop) {
      final matchesCat = _selectedCategoryFilter == 'All' || shop.category == _selectedCategoryFilter;
      final matchesQuery = _shopSearchQuery.isEmpty ||
          shop.name.toLowerCase().contains(_shopSearchQuery.toLowerCase()) ||
          shop.address.toLowerCase().contains(_shopSearchQuery.toLowerCase());
      return matchesCat && matchesQuery;
    }).toList();
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final cardsRaw = prefs.getString(_cardsStorageKey);
      final historyRaw = prefs.getString(_historyStorageKey);

      if (cardsRaw != null && cardsRaw.isNotEmpty) {
        final List decoded = jsonDecode(cardsRaw) as List;
        _cards = decoded.map((e) => LoyaltyCardItem.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        _cards = _seedDefaultCards();
        await _saveCardsToPrefs(prefs);
      }

      if (historyRaw != null && historyRaw.isNotEmpty) {
        final List decodedHist = jsonDecode(historyRaw) as List;
        _redeemedRecords = decodedHist.map((e) => PunchRecordItem.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        _redeemedRecords = [
          PunchRecordItem(
            id: 'seed-hist-1',
            cardId: 'default-1',
            shopName: 'Morning Brew Café',
            category: 'Coffee',
            rewardDescription: 'Free Oat Milk Flat White',
            redeemedAt: DateTime.now().subtract(const Duration(days: 4)),
          ),
        ];
        await _saveHistoryToPrefs(prefs);
      }
    } catch (e) {
      debugPrint('Error initializing LoyaltyPunchViewModel: $e');
      _cards = _seedDefaultCards();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategoryFilter(String category) {
    _selectedCategoryFilter = category;
    notifyListeners();
  }

  void setShopSearch(String query) {
    _shopSearchQuery = query;
    notifyListeners();
  }

  Future<void> punchCard(String cardId) async {
    final index = _cards.indexWhere((c) => c.id == cardId);
    if (index == -1) return;

    final card = _cards[index];
    if (card.currentPunches < card.totalPunches) {
      _cards[index] = card.copyWith(currentPunches: card.currentPunches + 1);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await _saveCardsToPrefs(prefs);
    }
  }

  Future<bool> redeemReward(String cardId) async {
    final index = _cards.indexWhere((c) => c.id == cardId);
    if (index == -1) return false;

    final card = _cards[index];
    if (!card.isRewardReady) return false;

    final newRecord = PunchRecordItem(
      id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
      cardId: card.id,
      shopName: card.shopName,
      category: card.category,
      rewardDescription: card.rewardDescription,
      redeemedAt: DateTime.now(),
    );

    _redeemedRecords.insert(0, newRecord);
    // Reset current punches back to 0 for the next cycle
    _cards[index] = card.copyWith(currentPunches: 0);

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await _saveCardsToPrefs(prefs);
    await _saveHistoryToPrefs(prefs);
    return true;
  }

  Future<void> addCustomCard(LoyaltyCardItem newCard) async {
    _cards.insert(0, newCard);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await _saveCardsToPrefs(prefs);
  }

  Future<void> deleteCard(String cardId) async {
    _cards.removeWhere((c) => c.id == cardId);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await _saveCardsToPrefs(prefs);
  }

  Future<void> resetCard(String cardId) async {
    final index = _cards.indexWhere((c) => c.id == cardId);
    if (index != -1) {
      _cards[index] = _cards[index].copyWith(currentPunches: 0);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await _saveCardsToPrefs(prefs);
    }
  }

  Future<void> _saveCardsToPrefs(SharedPreferences prefs) async {
    final encoded = jsonEncode(_cards.map((c) => c.toJson()).toList());
    await prefs.setString(_cardsStorageKey, encoded);
  }

  Future<void> _saveHistoryToPrefs(SharedPreferences prefs) async {
    final encoded = jsonEncode(_redeemedRecords.map((r) => r.toJson()).toList());
    await prefs.setString(_historyStorageKey, encoded);
  }

  List<LoyaltyCardItem> _seedDefaultCards() {
    return [
      LoyaltyCardItem(
        id: 'default-1',
        shopName: 'Morning Brew Café',
        category: 'Coffee',
        totalPunches: 8,
        currentPunches: 6,
        rewardDescription: 'Free Oat Milk Flat White',
        cardColorValue: 0xFFFF5238,
        iconCode: 'coffee',
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      LoyaltyCardItem(
        id: 'default-2',
        shopName: 'Golden Crust Bakery',
        category: 'Bakery',
        totalPunches: 6,
        currentPunches: 5,
        rewardDescription: 'Artisan Sourdough Loaf',
        cardColorValue: 0xFFE4A43D,
        iconCode: 'bakery',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
      LoyaltyCardItem(
        id: 'default-3',
        shopName: 'Ink & Page Books',
        category: 'Bookshop',
        totalPunches: 10,
        currentPunches: 4,
        rewardDescription: '\$15 Bookshop Voucher',
        cardColorValue: 0xFF3F7E5A,
        iconCode: 'book',
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
      ),
      LoyaltyCardItem(
        id: 'default-4',
        shopName: 'Velvet Bean Roastery',
        category: 'Coffee',
        totalPunches: 5,
        currentPunches: 2,
        rewardDescription: 'Specialty Pour Over Mug',
        cardColorValue: 0xFF8A5A36,
        iconCode: 'coffee',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }
}
