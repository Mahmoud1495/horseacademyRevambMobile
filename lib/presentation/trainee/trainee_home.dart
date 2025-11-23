import 'package:flutter/material.dart';
import 'package:horseacademy/data/models/bundle_model.dart';
import 'package:horseacademy/data/repo/bundle_repo.dart';
import 'package:horseacademy/presentation/Shared/DashboardScaffold.dart';
import '../../data/models/user_model.dart';

class TraineeHome extends StatefulWidget {
  final UserModel user;

  const TraineeHome({Key? key, required this.user}) : super(key: key);

  @override
  _TraineeHomeState createState() => _TraineeHomeState();
}

class _TraineeHomeState extends State<TraineeHome> {
  final bundleRepo = BundleRepo();

  List<Bundle> bundles = [];
  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadBundles();
  }

  Future<void> loadBundles() async {
    try {
      final result = await bundleRepo.getTraineeBundles();
      setState(() {
        bundles = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load bundles";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      user: widget.user,
      title: "Trainee Dashboard",
      body: loading
          ? Center(child: CircularProgressIndicator())

          : errorMessage != null
              ? Center(child: Text(errorMessage!))

              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text("Buy Bundles"),
                      subtitle: Text("Available bundles: ${bundles.length}"),
                      onTap: () {
                        // TODO: Navigate to bundles screen
                      },
                    ),
                    ListTile(
                      title: Text("Training History"),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text("My Profile"),
                      onTap: () {},
                    ),
                  ],
                ),
    );
  }
}
