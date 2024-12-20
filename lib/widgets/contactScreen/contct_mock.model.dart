class Contact {
  final String name;
  final String type;
  final String? imageUrl; // Nullable
  final bool isSelected;

  const Contact({
    required this.name,
    required this.type,
    this.imageUrl, // Nullable
    required this.isSelected,
  });
}
