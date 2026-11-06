import '../models/vehicle.dart';
import '../models/booking.dart';
import '../models/vehicle_listing.dart';
abstract class VehicleRepository {
 Future<List<Vehicle>> list({String? search});
 Future<Vehicle> getById(String id);
 Future<List<Booking>> bookings();
 Future<void> cancelBooking(String id);
 Future<List<VehicleListing>> myListings();
 Future<VehicleListing> createListing(Map<String, dynamic> data);
 Future<void> setListingStatus(String id, String status);
 Future<Booking> createBooking({required String vehicleId, required DateTime start, required DateTime end});
}
