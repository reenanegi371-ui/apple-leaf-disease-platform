class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final DateTime createdAt;
  final Map<String, dynamic> preferences;
  final int totalDetections;
  final List<String> savedDiseases;
  final bool isAnonymous;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.createdAt,
    this.preferences = const {},
    this.totalDetections = 0,
    this.savedDiseases = const [],
    this.isAnonymous = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profile_image'],
      createdAt: DateTime.parse(json['created_at']),
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
      totalDetections: json['total_detections'] ?? 0,
      savedDiseases: List<String>.from(json['saved_diseases'] ?? []),
      isAnonymous: json['is_anonymous'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image': profileImage,
      'created_at': createdAt.toIso8601String(),
      'preferences': preferences,
      'total_detections': totalDetections,
      'saved_diseases': savedDiseases,
      'is_anonymous': isAnonymous,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? profileImage,
    Map<String, dynamic>? preferences,
    int? totalDetections,
    List<String>? savedDiseases,
    bool? isAnonymous,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt,
      preferences: preferences ?? this.preferences,
      totalDetections: totalDetections ?? this.totalDetections,
      savedDiseases: savedDiseases ?? this.savedDiseases,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }
}