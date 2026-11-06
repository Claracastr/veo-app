import 'package:flutter/material.dart';
import 'package:veo_design_system/veo_design_system.dart';
import 'scenes/login/login_view.dart';
import 'services/mock_vehicle_repository.dart';
import 'services/http_vehicle_repository.dart';
import 'services/vehicle_repository.dart';
void main() { WidgetsFlutterBinding.ensureInitialized(); runApp(const VeoApp()); }
class VeoApp extends StatelessWidget { const VeoApp({super.key});
 @override Widget build(BuildContext context) {
  const useHttp = bool.fromEnvironment('USE_HTTP', defaultValue: false);
  const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:8080');
  final VehicleRepository repository = useHttp ? HttpVehicleRepository(baseUrl: apiUrl, token: 'demo-token') : MockVehicleRepository();
  return MaterialApp(title: 'VEO — alugue sua liberdade', debugShowCheckedModeBanner: false, theme: VeoTheme.light, home: LoginView(repository: repository));
 }
}
