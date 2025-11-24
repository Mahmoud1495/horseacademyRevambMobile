import 'package:flutter/material.dart';
import 'package:horseacademy/presentation/Shared/DashboardScaffold.dart';
import 'package:horseacademy/presentation/schedule/schedule_page.dart';
import '../../data/models/user_model.dart';

class TraineeHome extends StatefulWidget {
  final UserModel user;

  const TraineeHome({Key? key, required this.user}) : super(key: key);

  @override
  _TraineeHomeState createState() => _TraineeHomeState();
}

class _TraineeHomeState extends State<TraineeHome> {
  int currentIndex = 0;

  @override
Widget build(BuildContext context) {
  return DashboardScaffold(
    user: widget.user,
    title: "Trainee Dashboard",
    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          const SizedBox(height: 10),
          const Text(
            "الفعاليات القادمة",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          _buildEventCard(),

          const SizedBox(height: 20),

          const Text(
            "الخدمات:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              serviceCard("Men & Women", 1, "https://picsum.photos/300/200?1"),
              serviceCard("Ladies", 2, "https://picsum.photos/300/200?2"),
              serviceCard("Kids", 3, "https://picsum.photos/300/200?3"),
              serviceCard("Private Training", 4, "https://picsum.photos/300/200?4"),
            ],
          ),

          const SizedBox(height: 50),
        ],
      ),
    ),
  );
}

Widget _buildEventCard() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
          child: Image.network(
            "https://picsum.photos/400/200",
            fit: BoxFit.cover,
            width: double.infinity,
            height: 150,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text("Anan x That — بيلاتس ساعة الغروب",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("05:00 PM - 04:00 PM"),
              SizedBox(height: 4),
              Text("السبت, 29 نوفمبر 2025"),
            ],
          ),
        ),
      ],
    ),
  );
}
  // ==========================
  // SERVICE CARD BUILDER
  // ==========================
Widget serviceCard(String title, int id, String imageUrl) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SchedulePage(serviceId: id, title: title),
        ),
      );
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(color: Colors.black26),
          Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

}
