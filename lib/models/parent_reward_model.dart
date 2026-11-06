class ParentReward {
  final String id;
  final String title;
  final int targetStars;
  final bool isClaimed;

  ParentReward({
    required this.id,
    required this.title,
    required this.targetStars,
    this.isClaimed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetStars': targetStars,
      'isClaimed': isClaimed,
    };
  }

  factory ParentReward.fromJson(Map<String, dynamic> json) {
    return ParentReward(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      targetStars: json['targetStars'] ?? 10,
      isClaimed: json['isClaimed'] ?? false,
    );
  }
}
