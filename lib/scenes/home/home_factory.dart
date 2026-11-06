import '../../services/vehicle_repository.dart';
import 'home_view_model.dart';
abstract final class HomeFactory { static HomeViewModel create(VehicleRepository repository) => HomeViewModel(repository); }
