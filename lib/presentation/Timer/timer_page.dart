import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:horseacademy/data/models/user_model.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:horseacademy/core/app_config.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late HubConnection _hub;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  String _status = "No Active Timer";

  // Local timer (counts down on device)
  Timer? _localTicker;
  int? _remainingSeconds;
  String? _timerId;

  @override
  void initState() {
    super.initState();
    _connectToHub();
  }

  // ---------------------- SIGNALR CONNECTION ----------------------
  Future<void> _connectToHub() async {
    final serverUrl = AppConfig.baseSTaticUrl + "notificationhub";
    final userJson = await storage.read(key: "user");
          if (userJson != null) {
            // final userMap = jsonDecode(userJson);
            final user = UserModel.fromJson(userJson);
            final userId = user.id;// '088f2c70-2c1d-48aa-bc54-5e4f0e0af6f9';
    _hub = HubConnectionBuilder()
    .withUrl(
      '$serverUrl?userId=$userId',
      HttpConnectionOptions(
        transport: HttpTransportType.webSockets,
        skipNegotiation: true,   // <--- IMPORTANT when using WebSockets
      ),
    )
    .build();

  // Handle events
  _hub.on("TimerAdded", _onTimerAdded);
  _hub.on("TimerRemoved", _onTimerRemoved);
  _hub.on("TimerPaused", _onTimerPaused);
  _hub.on("TimerResumed", _onTimerResumed);

  await _hub.start()!.catchError((e, st) {
    print("SignalR start error (ignored for now): $e");
    print(st);
    // Future.delayed(Duration(seconds: 5), _connectToHub);
  });
          }
  }

  // ---------------------- EVENT HANDLERS ----------------------

  void _onTimerAdded(List<Object?>? args) {
    if (args == null || args.isEmpty) return;

    final timerJson = args[0];
    Map<String, dynamic> timer;

    if (timerJson is String) {
      timer = jsonDecode(timerJson);
    } else if (timerJson is Map) {
      timer = Map<String, dynamic>.from(timerJson);
    } else {
      return;
    }

    _timerId = timer["id"];
    _remainingSeconds = timer["remainingSeconds"];

    _startLocalTicker();

    setState(() {
      _status = "Timer started: $_remainingSeconds sec left";
    });
  }

  void _onTimerPaused(List<Object?>? args) {
    if (args == null || args.isEmpty) return;

    final id = args[0].toString();
    if (id != _timerId) return;

    _localTicker?.cancel();

    setState(() {
      _status = "Timer paused at $_remainingSeconds sec";
    });
  }

  void _onTimerResumed(List<Object?>? args) {
    if (args == null || args.isEmpty) return;

    final id = args[0].toString();
    if (id != _timerId) return;

    _startLocalTicker();

    setState(() {
      _status = "Timer resumed: $_remainingSeconds sec left";
    });
  }

  void _onTimerRemoved(List<Object?>? args) {
    if (args == null || args.isEmpty) return;

    final id = args[0].toString();
    if (id != _timerId) return;

    _localTicker?.cancel();
    _remainingSeconds = null;
    _timerId = null;

    setState(() {
      _status = "Timer removed";
    });
  }

  // ---------------------- LOCAL CLIENT TIMER ----------------------

  void _startLocalTicker() {
    _localTicker?.cancel();

    _localTicker = Timer.periodic(Duration(seconds: 1), (_) {
      if (_remainingSeconds == null) return;

      setState(() {
        _remainingSeconds = (_remainingSeconds! - 1);
      });

      if (_remainingSeconds! <= 0) {
        _localTicker?.cancel();
        setState(() {
          _status = "Timer completed!";
        });
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
    return Scaffold(
      appBar: AppBar(title: Text("Live Timer")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _status,
              style: TextStyle(fontSize: 22),
            ),
            if (_remainingSeconds != null) ...[
              SizedBox(height: 20),
              Text(
                "⏱ $_remainingSeconds seconds",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
