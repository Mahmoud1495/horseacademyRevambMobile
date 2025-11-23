class Room {
  final int id;
  final String name;

  Room({required this.id, required this.name});

  factory Room.fromJson(json) =>
      Room(id: json["id"], name: json["name"]);
}
