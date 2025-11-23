import '../../core/api_client.dart';
import '../models/bundle_model.dart';

class BundleRepo {
  final _api = ApiClient();

  Future<List<Bundle>> getTraineeBundles() async {
    final res = await _api.dio.get("WeatherForecast");
    return (res.data as List).map((e) => Bundle.fromMap(e)).toList();
  }
}
