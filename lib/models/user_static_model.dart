class UserStatic {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;

  UserStatic({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }

  factory UserStatic.fromMap(Map<String, dynamic> map) {
    return UserStatic(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
    );
  }
}
