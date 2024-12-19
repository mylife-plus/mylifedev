class MemoryMedia {
  final int id;
  final int memoryId;
  final String mediaPath;

  MemoryMedia({
    required this.id,
    required this.memoryId,
    required this.mediaPath,
  });

  factory MemoryMedia.fromMap(Map<String, dynamic> map) {
    return MemoryMedia(
      id: (map['id'] as int?) ?? 0,
      memoryId: (map['memory_id'] as int?) ?? 0,
      mediaPath: (map['media_path'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memory_id': memoryId,
      'media_path': mediaPath,
    };
  }
}
