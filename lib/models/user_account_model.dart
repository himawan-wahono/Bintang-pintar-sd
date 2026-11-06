class SubscriptionInfo {
  final bool isPremium;
  final String planType; // 'free', 'monthly', 'annual', 'lifetime'
  final DateTime? validUntil;
  final DateTime? activatedAt;

  SubscriptionInfo({
    this.isPremium = false,
    this.planType = 'free',
    this.validUntil,
    this.activatedAt,
  });

  bool get isActive => true; // Always active and 100% free

  Map<String, dynamic> toJson() {
    return {
      'isPremium': isPremium,
      'planType': planType,
      'validUntil': validUntil?.toIso8601String(),
      'activatedAt': activatedAt?.toIso8601String(),
    };
  }

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    return SubscriptionInfo(
      isPremium: json['isPremium'] ?? false,
      planType: json['planType'] ?? 'free',
      validUntil: json['validUntil'] != null ? DateTime.tryParse(json['validUntil']) : null,
      activatedAt: json['activatedAt'] != null ? DateTime.tryParse(json['activatedAt']) : null,
    );
  }
}

class UserAccount {
  final String uid;
  final String email;
  final String displayName;
  final String role; // 'parent' or 'student'
  final String parentPin;
  final bool isGuest;
  final SubscriptionInfo subscription;

  UserAccount({
    required this.uid,
    required this.email,
    required this.displayName,
    this.role = 'parent',
    this.parentPin = '1234',
    this.isGuest = false,
    SubscriptionInfo? subscription,
  }) : subscription = subscription ?? SubscriptionInfo();

  bool get isPremium => subscription.isActive;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
      'parentPin': parentPin,
      'isGuest': isGuest,
      'subscription': subscription.toJson(),
    };
  }

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? 'Orang Tua Bintang',
      role: json['role'] ?? 'parent',
      parentPin: json['parentPin'] ?? '1234',
      isGuest: json['isGuest'] ?? false,
      subscription: json['subscription'] != null
          ? SubscriptionInfo.fromJson(json['subscription'])
          : SubscriptionInfo(),
    );
  }

  factory UserAccount.guest() {
    return UserAccount(
      uid: 'guest_user_${DateTime.now().millisecondsSinceEpoch}',
      email: 'guest@bintangpintar.app',
      displayName: 'Pengguna Tamu (Gratis)',
      role: 'parent',
      parentPin: '1234',
      isGuest: true,
      subscription: SubscriptionInfo(isPremium: false, planType: 'free'),
    );
  }
}
