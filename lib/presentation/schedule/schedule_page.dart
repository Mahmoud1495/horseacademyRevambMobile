import 'package:flutter/material.dart';
import 'package:horseacademy/core/app_config.dart';
import 'package:horseacademy/data/models/bundle_model.dart';
import 'package:horseacademy/data/repo/bundle_repo.dart';
import 'package:horseacademy/presentation/schedule/booking_page.dart';

class SchedulePage extends StatefulWidget {
  final String serviceId;
  final String title;

  const SchedulePage({
    super.key,
    required this.serviceId,
    required this.title,
  });

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime selectedDay = DateTime.now();
  List<Bundle> bundles = [];
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _loadBundles();
  }

  Future<void> _loadBundles() async {
    try {
      final _bundleRepo = BundleRepo();
      final list = await _bundleRepo.getTraineeBundles(widget.serviceId);
      setState(() {
        bundles = list;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      // Handle error (snackbar, toast, etc.)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 10),
                _buildCalendar(),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: bundles
                        .map((bundle) => _buildTimeslot(bundle))
                        .toList(),
                  ),
                ),
              ],
            ),
    );
  }

  // --------------------------------------------------------------------------
  // CALENDAR UI
  // --------------------------------------------------------------------------
  Widget _buildCalendar() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14, // 2 weeks
        itemBuilder: (context, i) {
          DateTime day = DateTime.now().add(Duration(days: i));
          bool isActive = day.day == selectedDay.day &&
              day.month == selectedDay.month &&
              day.year == selectedDay.year;

          return GestureDetector(
            onTap: () => setState(() => selectedDay = day),
            child: Container(
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isActive ? Colors.deepPurple : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                        [day.weekday % 7],
                    style: TextStyle(
                        color: isActive ? Colors.white : Colors.black),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${day.day}",
                    style: TextStyle(
                      fontSize: 18,
                      color: isActive ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --------------------------------------------------------------------------
  // TIMESLOT UI
  // --------------------------------------------------------------------------
  Widget _buildTimeslot(Bundle bundle) {
    // Determine status based on remaining sessions or other logic
    bool available = bundle.numberClasses > 0; // example condition
    Color statusColor = available ? Colors.green : Colors.red;
    String statusText = available ? "Available" : "Closed";

    return InkWell(
      onTap: available
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingPage(
                    serviceId: bundle.id,
                    coach: "N/A", // replace if you have coach info
                    time: "${bundle.bundleDuration} days",
                    price: bundle.bundlePrice,
                    image: bundle.photo,
                  ),
                ),
              );
            }
          : null,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(AppConfig.baseSTaticUrl + bundle.photo),
            radius: 28,
          ),
          title: Text(bundle.name),
          subtitle: Text("Classes: ${bundle.numberClasses}"),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
