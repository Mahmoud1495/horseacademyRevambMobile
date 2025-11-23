class Bundle {
  final String id;
  final String traineeId;
  final int totalSessions;
  final int usedSessions;

  Bundle({
    required this.id,
    required this.traineeId,
    required this.totalSessions,
    required this.usedSessions,
  });

  factory Bundle.fromMap(Map json) => Bundle(
        id: json['id'],
        traineeId: json['traineeId'],
        totalSessions: json['totalSessions'],
        usedSessions: json['usedSessions'],
      );
}
