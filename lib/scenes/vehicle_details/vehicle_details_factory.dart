import '../../services/vehicle_repository.dart';
import 'vehicle_details_view_model.dart';

abstract final class VehicleDetailsFactory {
 static VehicleDetailsViewModel create(VehicleRepository repository) =>
  VehicleDetailsViewModel(repository);
}
