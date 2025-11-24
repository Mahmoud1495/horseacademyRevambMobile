import 'package:flutter/material.dart';
import 'package:horseacademy/presentation/schedule/booking_page.dart';

class SchedulePage extends StatefulWidget {
  final int serviceId;
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

  // Fake static data BEFORE API implementation
  final List<Map<String, dynamic>> sampleSlots = [
    {
      "id": 1,
      "time": "09:00 AM",
      "coach": "Coach Ahmed",
      "status": "available",
      "price": 100,
      "image": "https://picsum.photos/200?1"
    },
    {
      "id": 2,
      "time": "11:00 AM",
      "coach": "Coach Sarah",
      "status": "completed",
      "price": 100,
      "image": "https://picsum.photos/200?2"
    },
    {
      "id": 3,
      "time": "01:00 PM",
      "coach": "Coach Ali",
      "status": "closed",
      "price": 100,
      "image": "https://picsum.photos/200?3"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          _buildCalendar(),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              children: [
                for (var slot in sampleSlots) _buildTimeslot(slot),
              ],
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
                    ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"][day.weekday % 7],
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black,
                    ),
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
  Widget _buildTimeslot(Map slot) {
    final status = slot["status"];
    final bool available = status == "available";

    Color statusColor =
        available ? Colors.green :
        status == "completed" ? Colors.blue :
        Colors.red;

    return InkWell(
      onTap: available
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingPage(
                    serviceId: slot["id"],
                    coach: slot["coach"],
                    time: slot["time"],
                    price: slot["price"],
                    image: slot["image"],
                  ),
                ),
              );
            }
          : null,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(slot["image"]),
            radius: 28,
          ),
          title: Text(slot["time"]),
          subtitle: Text(slot["coach"]),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
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

