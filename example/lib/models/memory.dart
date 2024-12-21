class Memory {
  final int id;
  final String createdAt;
  final String updatedAt;
  final double xCoordinate;
  final double yCoordinate;
  final String address;
  final String text;

  Memory({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.xCoordinate,
    required this.yCoordinate,
    required this.address,
    required this.text,
  });

  factory Memory.fromMap(Map<String, dynamic> map) {
    return Memory(
      id: (map['id'] as int?) ?? 0,
      createdAt: (map['createdAt'] as String?) ?? '',
      updatedAt: (map['updatedAt'] as String?) ?? '',
      xCoordinate: (map['xCoordinate'] as num?)?.toDouble() ?? 0.0,
      yCoordinate: (map['yCoordinate'] as num?)?.toDouble() ?? 0.0,
      address: (map['address'] as String?) ?? '',
      text: (map['text'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'xCoordinate': xCoordinate,
      'yCoordinate': yCoordinate,
      'address': address,
      'text': text,
    };
  }
}
