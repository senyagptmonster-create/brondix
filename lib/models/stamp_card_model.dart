class StampCard {
  final String id;
  final String storeName;
  final String category;
  final int totalRequired;
  int currentPunches;
  final String rewardDescription;

  StampCard({
    required this.id,
    required this.storeName,
    required this.category,
    required this.totalRequired,
    required this.currentPunches,
    required this.rewardDescription,
  });

  bool get isFull => currentPunches >= totalRequired;
}
