enum LevelEnum {
  Beginner,
  Intermediate,
  Advanced,
  // Add other levels as needed
}

class Bundle {
  final String id; // Guid as String
  final String name;
  final LevelEnum minLevel;
  final int bundleDuration;
  final int numberClasses;
  final double bundlePrice;
  final int maxTraineePerGroup;
  final int sessionDurationMinutes;
  final String photo;
  final String description;
  final String bundleTypeId; // Guid as String

  Bundle({
    required this.id,
    required this.name,
    required this.minLevel,
    required this.bundleDuration,
    required this.numberClasses,
    required this.bundlePrice,
    required this.maxTraineePerGroup,
    required this.sessionDurationMinutes,
    required this.photo,
    required this.description,
    required this.bundleTypeId,
  });

  factory Bundle.fromMap(Map<String, dynamic> json) {
    return Bundle(
      id: json['id'],
      name: json['name'] ?? '',
      minLevel: _levelEnumFromInt(json['minLevel'] ?? 0),
      bundleDuration: json['bundleDuration'] ?? 0,
      numberClasses: json['numberClasses'] ?? 0,
      bundlePrice: (json['bundlePrice'] ?? 0).toDouble(),
      maxTraineePerGroup: json['maxTraineePerGroup'] ?? 0,
      sessionDurationMinutes: json['sessionDurationMinutes'] ?? 0,
      photo: json['photo'] ?? '',
      description: json['description'] ?? '',
      bundleTypeId: json['bundleTypeId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'minLevel': minLevel.index,
      'bundleDuration': bundleDuration,
      'numberClasses': numberClasses,
      'bundlePrice': bundlePrice,
      'maxTraineePerGroup': maxTraineePerGroup,
      'sessionDurationMinutes': sessionDurationMinutes,
      'photo': photo,
      'description': description,
      'bundleTypeId': bundleTypeId,
    };
  }

  static LevelEnum _levelEnumFromInt(int value) {
    switch (value) {
      case 0:
        return LevelEnum.Beginner;
      case 1:
        return LevelEnum.Intermediate;
      case 2:
        return LevelEnum.Advanced;
      default:
        return LevelEnum.Beginner;
    }
  }
}
