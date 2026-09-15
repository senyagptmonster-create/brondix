class LoyaltyCardItem {
  final String id;
  final String shopName;
  final String category;
  final int totalPunches;
  final int currentPunches;
  final String rewardDescription;
  final int cardColorValue;
  final String iconCode;
  final DateTime createdAt;

  const LoyaltyCardItem({
    required this.id,
    required this.shopName,
    required this.category,
    required this.totalPunches,
    required this.currentPunches,
    required this.rewardDescription,
    required this.cardColorValue,
    required this.iconCode,
    required this.createdAt,
  });

  bool get isRewardReady => currentPunches >= totalPunches;
  int get remainingPunches => (totalPunches - currentPunches).clamp(0, totalPunches);
  double get progressRatio => totalPunches == 0 ? 0 : (currentPunches / totalPunches).clamp(0.0, 1.0);

  LoyaltyCardItem copyWith({
    String? id,
    String? shopName,
    String? category,
    int? totalPunches,
    int? currentPunches,
    String? rewardDescription,
    int? cardColorValue,
    String? iconCode,
    DateTime? createdAt,
  }) {
    return LoyaltyCardItem(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      category: category ?? this.category,
      totalPunches: totalPunches ?? this.totalPunches,
      currentPunches: currentPunches ?? this.currentPunches,
      rewardDescription: rewardDescription ?? this.rewardDescription,
      cardColorValue: cardColorValue ?? this.cardColorValue,
      iconCode: iconCode ?? this.iconCode,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopName': shopName,
      'category': category,
      'totalPunches': totalPunches,
      'currentPunches': currentPunches,
      'rewardDescription': rewardDescription,
      'cardColorValue': cardColorValue,
      'iconCode': iconCode,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LoyaltyCardItem.fromJson(Map<String, dynamic> json) {
    return LoyaltyCardItem(
      id: json['id'] as String,
      shopName: json['shopName'] as String,
      category: json['category'] as String,
      totalPunches: json['totalPunches'] as int,
      currentPunches: json['currentPunches'] as int,
      rewardDescription: json['rewardDescription'] as String,
      cardColorValue: json['cardColorValue'] as int? ?? 0xFFE06D53,
      iconCode: json['iconCode'] as String? ?? 'coffee',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class PunchRecordItem {
  final String id;
  final String cardId;
  final String shopName;
  final String category;
  final String rewardDescription;
  final DateTime redeemedAt;

  const PunchRecordItem({
    required this.id,
    required this.cardId,
    required this.shopName,
    required this.category,
    required this.rewardDescription,
    required this.redeemedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardId': cardId,
      'shopName': shopName,
      'category': category,
      'rewardDescription': rewardDescription,
      'redeemedAt': redeemedAt.toIso8601String(),
    };
  }

  factory PunchRecordItem.fromJson(Map<String, dynamic> json) {
    return PunchRecordItem(
      id: json['id'] as String,
      cardId: json['cardId'] as String,
      shopName: json['shopName'] as String,
      category: json['category'] as String,
      rewardDescription: json['rewardDescription'] as String,
      redeemedAt: DateTime.tryParse(json['redeemedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class ShopLocationItem {
  final String id;
  final String name;
  final String category;
  final String address;
  final String businessHours;
  final String phone;
  final double rating;
  final bool hasStampMultiplier;
  final String perkText;

  const ShopLocationItem({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.businessHours,
    required this.phone,
    required this.rating,
    required this.hasStampMultiplier,
    required this.perkText,
  });
}
