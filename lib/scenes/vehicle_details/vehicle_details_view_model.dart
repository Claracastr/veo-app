import 'package:flutter/foundation.dart';
import '../../models/booking.dart';
import '../../services/vehicle_repository.dart';

class VehicleDetailsViewModel extends ChangeNotifier {
 final VehicleRepository repository;
 VehicleDetailsViewModel(this.repository);
 bool loading = false;
 String? error;
 Booking? createdBooking;
 Future<bool> book({required String vehicleId,
   required DateTime start, required DateTime end}) async {
  loading = true; error = null; createdBooking = null; notifyListeners();
  try {
   createdBooking = await repository.createBooking(
    vehicleId: vehicleId, start: start, end: end);
   return true;
  } catch (e) {
   error = e.toString().replaceFirst('Bad state: ', '');
   return false;
  } finally {
   loading = false;
   notifyListeners();
  }
 }
}
