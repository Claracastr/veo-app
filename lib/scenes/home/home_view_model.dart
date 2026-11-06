import 'package:flutter/foundation.dart';
import '../../models/vehicle.dart';
import '../../services/vehicle_repository.dart';
class HomeViewModel extends ChangeNotifier {
 final VehicleRepository repository; HomeViewModel(this.repository);
 List<Vehicle> cars = []; bool loading = false; String? error; String search = '';
 Future<void> load([String query = '']) async { search = query; loading = true; error = null; notifyListeners(); try { cars = await repository.list(search: query); } catch (_) { error = 'Não foi possível carregar os carros.'; } finally { loading = false; notifyListeners(); } }
}
