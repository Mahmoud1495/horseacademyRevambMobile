import 'package:horseacademy/data/models/bundleType_model.dart';

import '../../core/api_client.dart';
import '../models/bundle_model.dart';

class BundleRepo {
  final _api = ApiClient();

  Future<List<Bundle>> getTraineeBundles(id) async {
    final res = await _api.dio.get("Bundle/GetBundlesByTypeID/"+id);
     // Make sure the key matches exactly the JSON key
    final data = res.data['Data']; 
    return (data as List).map((e) => Bundle.fromMap(e)).toList();
  }


  Future<List<BundleType>> getBundlesTypes() async {
    final res = await _api.dio.get("Bundle/GetBundlesTypes");
     // Make sure the key matches exactly the JSON key
    final data = res.data['Data']; 
    return (data as List).map((e) => BundleType.fromMap(e)).toList();
  }

}
