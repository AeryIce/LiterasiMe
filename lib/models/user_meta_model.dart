class UserMeta {
  final List<String> preferredGenres;
  final List<String> recentSearches;

  UserMeta({
    this.preferredGenres = const [],
    this.recentSearches = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'preferredGenres': preferredGenres,
      'recentSearches': recentSearches,
    };
  }

  factory UserMeta.fromMap(Map<String, dynamic> map) {
    return UserMeta(
      preferredGenres: List<String>.from(map['preferredGenres'] ?? []),
      recentSearches: List<String>.from(map['recentSearches'] ?? []),
    );
  }
}
