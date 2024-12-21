class Group {
  final int id;
  final String name;

  Group({
    required this.id,
    required this.name,
  });

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: (map['id'] as int?) ?? 0,
      name: (map['name'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
