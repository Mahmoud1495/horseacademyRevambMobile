import 'package:flutter/material.dart';
import 'package:horseacademy/data/models/SessionModel.dart';
import 'package:horseacademy/data/repo/sessions_repo.dart';
import 'package:horseacademy/core/app_config.dart';

class SessionsPage extends StatefulWidget {
  final String bundleId;
  final int numberClasses;

  const SessionsPage({
    super.key,
    required this.bundleId,
    required this.numberClasses,
  });

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  bool isLoading = false; // Track loading state
  bool isSuccess = false; // To track if timers were created successfully
  String successMessage = ''; // Success message to display
  List<SessionModel> sessions = [];
  List<SessionModel> selectedSessions = []; // List to hold selected sessions
  List<SessionModel> failedSessions = []; // To hold failed sessions for retrying

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  // Load sessions from the repository
  Future<void> _loadSessions() async {
    final repo = SessionsRepo();
    sessions = await repo.getSessionsByBundleId(widget.bundleId);
    setState(() => isLoading = false);
  }

  // Handle session selection
  void _onSessionSelected(SessionModel session) {
    setState(() {
      if (selectedSessions.contains(session)) {
        selectedSessions.remove(session);
      } else {
        if (selectedSessions.length < widget.numberClasses) {
          selectedSessions.add(session);
        }
      }
    });
  }

  // Handle timer creation
  Future<void> _createTimers() async {
    if (selectedSessions.length == widget.numberClasses) {
      setState(() {
        isLoading = true; // Show loading indicator
        successMessage = '';
      });

      final repo = SessionsRepo();
      failedSessions = await repo.createTimers(selectedSessions); // Get failed sessions

      if (failedSessions.isEmpty) {
        setState(() {
          isSuccess = true;
          successMessage = 'All timers created successfully!';
        });
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pop(context); // Go back after successful timer creation
        });
      } else {
        setState(() {
          isSuccess = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Some timers failed to create. Retry or select other sessions.')),
        );
      }

      setState(() {
        isLoading = false; // Hide loading indicator
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select exactly ${widget.numberClasses} sessions.')),
      );
    }
  }

  // Retry failed timers
  Future<void> _retryFailedTimers() async {
    final repo = SessionsRepo();
    failedSessions = await repo.createTimers(failedSessions); // Retry failed sessions

    if (failedSessions.isEmpty) {
      setState(() {
        isSuccess = true;
        successMessage = 'Timers created successfully on retry!';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Timers created successfully!')),
      );
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pop(context); // Go back after retry success
      });
    } else {
      setState(() {
        isSuccess = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Retry failed. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sessions"),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _createTimers, // Trigger timer creation on button press
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator while submitting
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Select ${widget.numberClasses} sessions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                // If timers were created successfully, show the success message in full screen
                if (isSuccess)
                  Expanded(
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.green.withOpacity(0.5),
                        child: Text(
                          successMessage,
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                // Show names of the failed sessions if any
                if (!isSuccess && failedSessions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Failed to create timers for the following sessions:',
                      style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                // Show names of the failed sessions with session date in error message
                if (!isSuccess && failedSessions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: failedSessions
                          .map((session) => Text(
                                'Session: ${session.name} (Date: ${session.sessionDate})',
                                style: TextStyle(color: Colors.red),
                              ))
                          .toList(),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, i) => _buildSessionItem(sessions[i]),
                  ),
                ),
                // Retry button if there are failed sessions
                if (failedSessions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _retryFailedTimers,
                      child: const Text('Retry Failed Timers'),
                    ),
                  ),
              ],
            ),
    );
  }

  // This function now disables session selection based on the availability flag
  Widget _buildSessionItem(SessionModel s) {
    bool isSelected = selectedSessions.contains(s);
    bool isAvailable = s.isAvailable; // Check if the session is available

    return Card(
      margin: const EdgeInsets.all(12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(AppConfig.baseSTaticUrl + s.photo),
        ),
        title: Text(s.name),
        subtitle: Text(
          "Date: ${s.sessionDate}\nAvailable: ${s.availableCount}",
        ),
        trailing: Icon(
          isSelected ? Icons.check_box : Icons.check_box_outline_blank,
          color: isSelected ? Colors.green : null,
        ),
        onTap: isAvailable
            ? () => _onSessionSelected(s) // Allow selection only if available
            : null, // Disable selection for unavailable sessions
        tileColor: isAvailable ? null : Colors.grey.shade200, // Change color to indicate unavailability
      ),
    );
  }
}
