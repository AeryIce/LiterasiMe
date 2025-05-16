class UserStatic {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;

  UserStatic({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }

  factory UserStatic.fromMap(Map<String, dynamic> map) {
    return UserStatic(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      photoURL: map['photoURL'],
    );
  }
}
