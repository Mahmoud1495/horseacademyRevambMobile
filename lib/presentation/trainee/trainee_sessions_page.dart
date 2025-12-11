// import 'package:flutter/material.dart';
// import '../../data/models/session_model.dart';
// import 'package:intl/intl.dart';

// class TraineeSessionsPage extends StatefulWidget {
//   final String userId;

//   const TraineeSessionsPage({super.key, required this.userId});

//   @override
//   State<TraineeSessionsPage> createState() => _TraineeSessionsPageState();
// }

// class _TraineeSessionsPageState extends State<TraineeSessionsPage> {
//   bool loading = true;
//   List<SessionModel> sessions = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadStaticData();
//   }

//   Future<void> _loadStaticData() async {
//     await Future.delayed(const Duration(milliseconds: 300)); // small delay for UI

//     sessions = [
//       SessionModel(
//         horse: "سبحة",
//         traineeName: "Habiba Amr",
//         start: DateTime.parse("2025-08-11 21:06"),
//         end: DateTime.parse("2025-08-11 21:17"),
//         stage: 1,
//         duration: 11,
//       ),
//       SessionModel(
//         horse: "ورد",
//         traineeName: "Malek Waleed",
//         start: DateTime.parse("2025-08-11 18:00"),
//         end: DateTime.parse("2025-08-11 18:45"),
//         stage: 2,
//         duration: 45,
//       ),
//     ];

//     setState(() => loading = false);
//   }

//   String formatDate(DateTime date) {
//     return DateFormat('dd/MM/yyyy').format(date);
//   }

//   String formatTime(DateTime time) {
//     return DateFormat('HH:mm').format(time);
//   }

//   Color stageColor(int stage) {
//     switch (stage) {
//       case 1:
//         return Colors.blueAccent;
//       case 2:
//         return Colors.orangeAccent;
//       case 3:
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("سجل الجلسات"),
//         centerTitle: true,
//       ),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: sessions.length,
//               itemBuilder: (_, i) {
//                 final s = sessions[i];
//                 return Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Header: Trainee Name + Horse
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               s.traineeName,
//                               style: const TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               s.horse,
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.brown[700]),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),

//                         // Date row
//                         Row(
//                           children: [
//                             const Icon(Icons.calendar_today, size: 16),
//                             const SizedBox(width: 6),
//                             Text(
//                               formatDate(s.start),
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),

//                         // Time row
//                         Row(
//                           children: [
//                             const Icon(Icons.access_time, size: 16),
//                             const SizedBox(width: 6),
//                             Text(
//                               "من: ${formatTime(s.start)}  إلى: ${formatTime(s.end)}",
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),

//                         // Stage and Duration badges
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: stageColor(s.stage).withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Text(
//                                 "المرحلة: ${s.stage}",
//                                 style: TextStyle(
//                                     color: stageColor(s.stage),
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Text(
//                                 "المدة: ${s.duration} دقيقة",
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
