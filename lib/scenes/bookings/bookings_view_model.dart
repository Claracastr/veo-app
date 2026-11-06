import 'package:flutter/foundation.dart';
import '../../models/booking.dart';
import '../../services/vehicle_repository.dart';

class BookingsViewModel extends ChangeNotifier {
 final VehicleRepository repository;
 BookingsViewModel(this.repository);
 List<Booking> items = [];
 Map<String, String> vehicleNames = {};
 bool loading = false;
 String? error;

 Future<void> cancel(String id) async {
  try { await repository.cancelBooking(id); await load(); }
  catch(e) { error='Não foi possível cancelar a reserva: $e'; notifyListeners(); }
 }
 Future<void> load() async {
  loading = true;
  error = null;
  notifyListeners();
  try {
   items = await repository.bookings();
   final vehicles = await repository.list();
   vehicleNames = {for (final v in vehicles) v.id: v.name};
  } catch (_) {
   error = 'Não foi possível carregar suas reservas.';
  } finally {
   loading = false;
   notifyListeners();
  }
 }
}
