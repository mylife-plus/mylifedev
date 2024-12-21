class Hashtag {
  final int id;
  final String unicode;

  Hashtag({
    required this.id,
    required this.unicode,
  });

  factory Hashtag.fromMap(Map<String, dynamic> map) {
    return Hashtag(
      id: (map['id'] as int?) ?? 0,
      unicode: (map['unicode'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'unicode': unicode,
    };
  }
}
