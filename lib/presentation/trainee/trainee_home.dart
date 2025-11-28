import 'package:flutter/material.dart';
import 'package:horseacademy/data/models/bundleType_model.dart';
import 'package:horseacademy/data/repo/bundle_repo.dart';
import 'package:horseacademy/presentation/Shared/DashboardScaffold.dart';
import 'package:horseacademy/presentation/schedule/schedule_page.dart';
import '../../core/app_config.dart';
import '../../data/models/user_model.dart';

class TraineeHome extends StatefulWidget {
  final UserModel user;

  const TraineeHome({Key? key, required this.user}) : super(key: key);

  @override
  _TraineeHomeState createState() => _TraineeHomeState();
}

class _TraineeHomeState extends State<TraineeHome> {
  List<BundleType> bundleTypes = [];
  bool isLoading = true;
  final _bundleRepo = BundleRepo();
  @override
  void initState() {
    super.initState();
    _loadBundleTypes();
  }

  Future<void> _loadBundleTypes() async {
    try {
      final bundles = await _bundleRepo.getBundlesTypes();
      setState(() {
        bundleTypes = bundles;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error (show snackbar, etc.)
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      user: widget.user,
      title: "Trainee Dashboard",
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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

                  // Main screen image: first bundle
                  if (bundleTypes.isNotEmpty) _buildMainBundleCard(bundleTypes.first),

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
                    children: bundleTypes
                        .skip(1)
                        .map((b) => serviceCard(b))
                        .toList(),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }

  // Main bundle card (top screen)
  Widget _buildMainBundleCard(BundleType bundle) {
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
              AppConfig.baseSTaticUrl + bundle.photo,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  bundle.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                // Text("عدد الحصص: ${bundle.numberClasses}"),
                // const SizedBox(height: 4),
                // Text("مدة الباقة: ${bundle.bundleDuration} يوم"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Service card for grid
  Widget serviceCard(BundleType bundle) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SchedulePage(serviceId: bundle.id, title: bundle.name),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Image.network(
              AppConfig.baseSTaticUrl + bundle.photo,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(color: Colors.black26),
            Center(
              child: Text(
                bundle.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
