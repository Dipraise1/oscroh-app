class User {
  final String id;
  final String username;
  final int age;
  final String gender;
  final String city;
  final String state;
  final String bio;
  final List<String> interests;
  final String? profileImage;
  final String? occupation;
  final String? education;
  final Map<String, dynamic>? preferences;
  final bool isVerified;
  final DateTime? lastActive;

  User({
    required this.id,
    required this.username,
    required this.age,
    required this.gender,
    required this.city,
    required this.state,
    required this.bio,
    required this.interests,
    this.profileImage,
    this.occupation,
    this.education,
    this.preferences,
    this.isVerified = false,
    this.lastActive,
  });

  // Convert User object to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'age': age,
      'gender': gender,
      'city': city,
      'state': state,
      'bio': bio,
      'interests': interests,
      'profileImage': profileImage,
      'occupation': occupation,
      'education': education,
      'preferences': preferences,
      'isVerified': isVerified,
      'lastActive': lastActive,
    };
  }

  // Create User object from Firebase document
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      bio: map['bio'] ?? '',
      interests: List<String>.from(map['interests'] ?? []),
      profileImage: map['profileImage'],
      occupation: map['occupation'],
      education: map['education'],
      preferences: map['preferences'],
      isVerified: map['isVerified'] ?? false,
      lastActive: map['lastActive'] != null
          ? (map['lastActive'] is DateTime
              ? map['lastActive']
              : DateTime.fromMillisecondsSinceEpoch(map['lastActive'] is int
                  ? map['lastActive']
                  : (map['lastActive'].seconds * 1000)))
          : DateTime.now(),
    );
  }

  // Copy with method to create a new User with some updated properties
  User copyWith({
    String? id,
    String? username,
    int? age,
    String? gender,
    String? city,
    String? state,
    String? bio,
    List<String>? interests,
    String? profileImage,
    String? occupation,
    String? education,
    Map<String, dynamic>? preferences,
    bool? isVerified,
    DateTime? lastActive,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      city: city ?? this.city,
      state: state ?? this.state,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      profileImage: profileImage ?? this.profileImage,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
      preferences: preferences ?? this.preferences,
      isVerified: isVerified ?? this.isVerified,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}
