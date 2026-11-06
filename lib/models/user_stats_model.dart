class UserStats {
  int totalXp;
  int totalStars;
  int quizzesCompleted;
  int totalCorrectAnswers;
  int totalQuestionsAnswered;
  int streakDays;
  List<String> unlockedBadgeIds;
  Map<int, int> levelStars;
  bool hasSeenOnboarding;

  UserStats({
    this.totalXp = 0,
    this.totalStars = 0,
    this.quizzesCompleted = 0,
    this.totalCorrectAnswers = 0,
    this.totalQuestionsAnswered = 0,
    this.streakDays = 1,
    this.hasSeenOnboarding = false,
    List<String>? unlockedBadgeIds,
    Map<int, int>? levelStars,
  })  : unlockedBadgeIds = unlockedBadgeIds ?? ['beginner_explorer'],
        levelStars = levelStars ?? {};

  double get accuracyRate {
    if (totalQuestionsAnswered == 0) return 0.0;
    return (totalCorrectAnswers / totalQuestionsAnswered) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'totalXp': totalXp,
      'totalStars': totalStars,
      'quizzesCompleted': quizzesCompleted,
      'totalCorrectAnswers': totalCorrectAnswers,
      'totalQuestionsAnswered': totalQuestionsAnswered,
      'streakDays': streakDays,
      'hasSeenOnboarding': hasSeenOnboarding,
      'unlockedBadgeIds': unlockedBadgeIds,
      'levelStars': levelStars.map((k, v) => MapEntry(k.toString(), v)),
    };
  }

  factory UserStats.fromJson(Map<String, dynamic> json) {
    Map<int, int> parsedLevelStars = {};
    if (json['levelStars'] != null) {
      final rawMap = json['levelStars'] as Map<String, dynamic>;
      rawMap.forEach((k, v) {
        final parsedKey = int.tryParse(k);
        if (parsedKey != null) parsedLevelStars[parsedKey] = (v as num).toInt();
      });
    }

    return UserStats(
      totalXp: json['totalXp'] ?? 0,
      totalStars: json['totalStars'] ?? 0,
      quizzesCompleted: json['quizzesCompleted'] ?? 0,
      totalCorrectAnswers: json['totalCorrectAnswers'] ?? 0,
      totalQuestionsAnswered: json['totalQuestionsAnswered'] ?? 0,
      streakDays: json['streakDays'] ?? 1,
      hasSeenOnboarding: json['hasSeenOnboarding'] ?? false,
      unlockedBadgeIds: List<String>.from(json['unlockedBadgeIds'] ?? ['beginner_explorer']),
      levelStars: parsedLevelStars,
    );
  }
}

class BadgeItem {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int requiredXp;

  BadgeItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.requiredXp,
  });
}
