class BundleType {
  final String id;   // Guid as String
  final String name;
  final String photo;

  BundleType({
    required this.id,
    required this.name,
    required this.photo,
  });

  factory BundleType.fromMap(Map<String, dynamic> json) {
    return BundleType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
    };
  }
}
