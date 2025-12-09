import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:horseacademy/data/models/user_model.dart';
import 'package:horseacademy/data/repo/timer_repo.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:horseacademy/core/app_config.dart';
import 'package:horseacademy/data/models/timer_model.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late HubConnection _hub;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final TimerRepo _timerRepo = TimerRepo();

  TimerModel? _currentTimer;
  Timer? _localTicker;

  String _status = "No Active Timer";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _connectToHub();
    _checkForTimers();
  }

  // ---------------------- CHECK EXISTING TIMERS ----------------------
  Future<void> _checkForTimers() async {
    setState(() => isLoading = true);

    try {
      final userJson = await storage.read(key: "user");
      if (userJson != null) {
        final user = UserModel.fromJson(userJson);
        final userId = user.id;
        await _timerRepo.checkTimers(userId);
      }
    } catch (e) {
      print("Error checking timers: $e");
    }

    setState(() => isLoading = false);
  }

  // ---------------------- SIGNALR CONNECTION ----------------------
  Future<void> _connectToHub() async {
    final serverUrl = "${AppConfig.baseSTaticUrl}notificationhub";
    final userJson = await storage.read(key: "user");

    if (userJson != null) {
      final user = UserModel.fromJson(userJson);
      final userId = user.id;

      _hub = HubConnectionBuilder()
          .withUrl(
            '$serverUrl?userId=$userId',
            HttpConnectionOptions(
              transport: HttpTransportType.webSockets,
              skipNegotiation: true,
            ),
          )
          .build();

      // Timer events
      _hub.on("TimerAdded", _onTimerAdded);
      _hub.on("TimerRemoved", _onTimerRemoved);
      _hub.on("TimerPaused", _onTimerPaused);
      _hub.on("TimerResumed", _onTimerResumed);

      // Announcements from Blazor
      _hub.on("TimerAnnounce", (args) {
        final message = args?[0]?.toString() ?? "";
        if (message.isNotEmpty) _showAnnouncement(message);
      });

      await _hub.start()?.catchError((e) {
        print("SignalR start error: $e");
      });
    }
  }

  void _showAnnouncement(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    // Optional: integrate TTS here
  }

  // ---------------------- TIMER EVENT HANDLERS ----------------------
  void _onTimerAdded(List<Object?>? args) {
    if (args == null || args.isEmpty) return;
    final timerJson = args[0];

    Map<String, dynamic> timerMap;
    if (timerJson is String) {
      timerMap = jsonDecode(timerJson);
    } else if (timerJson is Map) {
      timerMap = Map<String, dynamic>.from(timerJson);
    } else {
      return;
    }

    _currentTimer = TimerModel.fromJson(timerMap);

    if (_currentTimer?.active == true) _startLocalTicker();

    setState(() {
      _status = "Timer started: ${_currentTimer!.remainingSeconds} sec left";
    });
  }

  void _onTimerPaused(List<Object?>? args) {
    if (args == null || args.isEmpty) return;
    final id = args[0].toString();
    if (id != _currentTimer?.id) return;

    _localTicker?.cancel();
    setState(() => _status = "Timer paused at ${_currentTimer!.remainingSeconds} sec");
  }

  void _onTimerResumed(List<Object?>? args) {
    if (args == null || args.isEmpty) return;
    final id = args[0].toString();
    if (id != _currentTimer?.id) return;

    _startLocalTicker();
    setState(() => _status = "Timer resumed: ${_currentTimer!.remainingSeconds} sec left");
  }

  void _onTimerRemoved(List<Object?>? args) {
    if (args == null || args.isEmpty) return;
    final id = args[0].toString();
    if (id != _currentTimer?.id) return;

    _localTicker?.cancel();
    _currentTimer = null;
    setState(() => _status = "Timer removed");
  }

  // ---------------------- LOCAL TICKER ----------------------
  void _startLocalTicker() {
    _localTicker?.cancel();

    _localTicker = Timer.periodic(Duration(seconds: 1), (_) {
      if (_currentTimer == null || !_currentTimer!.active) return;

      setState(() {
        _currentTimer!.tick();
      });

      if (_currentTimer!.done) {
        _localTicker?.cancel();
        _status = "Timer completed!";
        _showAnnouncement("${_currentTimer!.trainee}'s timer completed!");
      }
    });
  }

  @override
  void dispose() {
    _localTicker?.cancel();
    _hub.stop();
    super.dispose();
  }

  // ---------------------- UI ----------------------
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Live Timer")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentTimer == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Live Timer")),
        body: Center(child: Text("No active timer", style: TextStyle(fontSize: 22))),
      );
    }

    final progress = _currentTimer!.progress / 100;
    final minutes = (_currentTimer!.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_currentTimer!.remainingSeconds % 60).toString().padLeft(2, '0');
    final displayTime = "$minutes:$seconds";

    return Scaffold(
      appBar: AppBar(title: Text("Live Timer")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentTimer!.trainee,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                ),
                Text(
                  displayTime,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_currentTimer!.progressVisible)
              LinearProgressIndicator(value: progress, minHeight: 8),
            SizedBox(height: 20),
            Text(
              _currentTimer!.done
                  ? "Done!"
                  : _currentTimer!.active
                      ? "Active"
                      : "Paused",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
