class SessionModel {
  final String traineeName;
  final String horse;
  final DateTime start;
  final DateTime end;
  final int stage;
  final double duration;

  SessionModel({
    required this.traineeName,
    required this.horse,
    required this.start,
    required this.end,
    required this.stage,
    required this.duration,
  });
}
