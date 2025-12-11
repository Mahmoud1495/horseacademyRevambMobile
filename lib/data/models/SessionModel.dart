class SessionModel {
  final String id;
  final String sessionDate;
  final String photo;
  final String description;
  final String name;
  final int availableCount;
  final bool isAvailable;

  SessionModel({
    required this.id,
    required this.sessionDate,
    required this.photo,
    required this.description,
    required this.name,
    required this.availableCount,
    required this.isAvailable,
  });

  factory SessionModel.fromMap(Map<String, dynamic> json) {
    return SessionModel(
      id: json["id"],
      sessionDate: json["sessionDate"], // DateOnly from backend as string
      photo: json["photo"] ?? "",
      description: json["description"] ?? "",
      name: json["name"],
      availableCount: json["avalaibleCount"], // match C# property EXACTLY
      isAvailable: json["isAvalaible"],       // match C# property EXACTLY
    );
  }
}
