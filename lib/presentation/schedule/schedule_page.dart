import 'package:flutter/material.dart';
import 'package:horseacademy/core/app_config.dart';
import 'package:horseacademy/data/models/bundle_model.dart';
import 'package:horseacademy/data/repo/bundle_repo.dart';
import 'package:horseacademy/presentation/schedule/sessions_page.dart';

class SchedulePage extends StatefulWidget {
  final String serviceId;
  final String title; // Assuming we need to pass the traineeId as well

  const SchedulePage({
    super.key,
    required this.serviceId,
    required this.title // Add traineeId to constructor
  });

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Bundle> bundles = [];
  bool isLoading = true;
  String? errorMessage; // Store error message to show in the UI if data fails to load

  @override
  void initState() {
    super.initState();
    _loadBundles();
  }

  Future<void> _loadBundles() async {
    try {
      final repo = BundleRepo();
      bundles = await repo.getTraineeBundles(widget.serviceId);
      setState(() => isLoading = false);
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Failed to load bundles. Please try again later."; // Error handling
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading indicator
          : errorMessage != null
              ? Center(child: Text(errorMessage!)) // Error message display
              : bundles.isEmpty
                  ? const Center(child: Text("No bundles available"))
                  : ListView(
                      children: bundles.map((b) => _buildBundleCard(b)).toList(),
                    ),
    );
  }

  Widget _buildBundleCard(Bundle bundle) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SessionsPage(
              bundleId: bundle.id, // Pass the bundleId
              numberClasses: bundle.numberClasses
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(AppConfig.baseSTaticUrl + bundle.photo),
            radius: 28,
          ),
          title: Text(bundle.name),
          subtitle: Text(
            "Classes: ${bundle.numberClasses}\nDuration: ${bundle.bundleDuration} days",
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
