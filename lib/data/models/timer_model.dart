class TimerModel {
  final String id;
  final String trainee;
  final String traineeId;
  final String horse;
  final String horseId;

  final int totalSeconds;
  int remainingSeconds;
  final int durationSeconds;
  int elapsedSeconds;
  bool active;
  bool done;
  List<int> firedThresholds;

  TimerModel({
    required this.id,
    required this.trainee,
    required this.traineeId,
    required this.horse,
    required this.horseId,
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.durationSeconds,
    required this.elapsedSeconds,
    this.active = false,
    this.done = false,
    List<int>? firedThresholds,
  }) : firedThresholds = firedThresholds ?? [];

  // Computed property: progress percentage
  int get progress => (100 * (1 - (remainingSeconds / totalSeconds))).toInt();

  // Computed property: whether progress bar is visible
  bool get progressVisible => !done && remainingSeconds < totalSeconds;

  // Computed property: display time in mm:ss
  String get displayTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  // Tick method (similar to C#)
  void tick() {
    if (!active || done) return;

    if (remainingSeconds > 0) remainingSeconds--;

    if (remainingSeconds <= 0) {
      remainingSeconds = 0;
      done = true;
      active = false;
    }
  }

  // Deserialize from JSON (from SignalR)
  factory TimerModel.fromJson(Map<String, dynamic> json) {
    return TimerModel(
      id: json['id'] ?? '',
      trainee: json['trainee'] ?? '',
      traineeId: json['traineeId'] ?? '',
      horse: json['horse'] ?? '',
      horseId: json['horseId'] ?? '',
      totalSeconds: json['totalSeconds'] ?? 0,
      remainingSeconds: json['remainingSeconds'] ?? 0,
      durationSeconds: json['durationSeconds'] ?? 0,
      elapsedSeconds: json['elapsedSeconds'] ?? 0,
      active: json['active'] ?? false,
      done: json['done'] ?? false,
      firedThresholds: (json['firedThresholds'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }

  // Serialize to JSON (if Flutter needs to send it back)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trainee': trainee,
      'traineeId': traineeId,
      'horse': horse,
      'horseId': horseId,
      'totalSeconds': totalSeconds,
      'remainingSeconds': remainingSeconds,
      'durationSeconds': durationSeconds,
      'elapsedSeconds': elapsedSeconds,
      'active': active,
      'done': done,
      'firedThresholds': firedThresholds,
    };
  }
}
