import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;

class BrondixStore extends ChangeNotifier {
  List<dynamic> cards = [];
  List<dynamic> history = [];
  List<dynamic> locations = [];

  BrondixStore() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('brondix_data');
    if (data != null) {
      final json = jsonDecode(data);
      cards = json['cards'] ?? [];
      history = json['history'] ?? [];
      locations = json['locations'] ?? [];
      notifyListeners();
    } else {
      _loadDefault();
    }
  }

  Future<void> _loadDefault() async {
    try {
      final jsonStr = await rootBundle.loadString('content.json');
      final json = jsonDecode(jsonStr);
      cards = json['cards'] ?? [];
      history = json['history'] ?? [];
      locations = json['locations'] ?? [];
      save();
    } catch (e) {
      // fallback
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('brondix_data', jsonEncode({
      'cards': cards,
      'history': history,
      'locations': locations,
    }));
    notifyListeners();
  }

  void addPunch(int index) {
    if (cards[index]['punches'] < cards[index]['total']) {
      cards[index]['punches']++;
      if (cards[index]['punches'] == cards[index]['total']) {
        history.add({
          'reward': cards[index]['reward'],
          'date': DateTime.now().toIso8601String(),
          'shop': cards[index]['shop']
        });
        cards[index]['punches'] = 0;
      }
      save();
    }
  }

  void addCard(Map<String, dynamic> card) {
    cards.add(card);
    save();
  }
}
