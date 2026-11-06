import '../../services/vehicle_repository.dart';
import 'bookings_view_model.dart';

abstract final class BookingsFactory {
 static BookingsViewModel create(VehicleRepository repository) =>
  BookingsViewModel(repository);
}
