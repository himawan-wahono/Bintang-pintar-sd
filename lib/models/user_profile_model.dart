class UserProfile {
  final String id;
  final String name;
  final String gradeLevel;
  final int classNum;
  final String avatar; // 'robot', 'cat', 'astronaut', 'hero', 'bear', 'star'

  UserProfile({
    required this.id,
    required this.name,
    required this.gradeLevel,
    required this.classNum,
    required this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gradeLevel': gradeLevel,
      'classNum': classNum,
      'avatar': avatar,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 'default_child',
      name: json['name'] ?? 'Bintang Pintar',
      gradeLevel: json['gradeLevel'] ?? 'SD',
      classNum: json['classNum'] ?? 4,
      avatar: json['avatar'] ?? 'robot',
    );
  }

  UserProfile copyWith({
    String? name,
    String? gradeLevel,
    int? classNum,
    String? avatar,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      classNum: classNum ?? this.classNum,
      avatar: avatar ?? this.avatar,
    );
  }
}
