import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vehicle.dart';
import '../models/booking.dart';
import '../models/vehicle_listing.dart';
import 'vehicle_repository.dart';
class HttpVehicleRepository implements VehicleRepository {
 final String baseUrl; final String token; final http.Client client;
 HttpVehicleRepository({required this.baseUrl, required this.token, http.Client? client}) : client = client ?? http.Client();
 Map<String, String> get headers => {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
 void check(http.Response r, int expected) { if (r.statusCode != expected) throw Exception('Erro HTTP ${r.statusCode}: ${r.body}'); }
 @override Future<List<Vehicle>> list({String? search}) async { final uri = Uri.parse('$baseUrl/vehicles').replace(queryParameters: (search ?? '').isEmpty ? null : {'search': search}); final r = await client.get(uri, headers: headers); check(r, 200); return (jsonDecode(r.body)['items'] as List).map((x) => Vehicle.fromJson(x)).toList(); }
 @override Future<Vehicle> getById(String id) async { final r = await client.get(Uri.parse('$baseUrl/vehicles/$id'), headers: headers); check(r, 200); return Vehicle.fromJson(jsonDecode(r.body)); }
 @override Future<List<VehicleListing>> myListings() async { final r=await client.get(Uri.parse('$baseUrl/my-listings'),headers:headers);check(r,200);return (jsonDecode(r.body)['items'] as List).map((e)=>VehicleListing.fromJson(e)).toList(); }
 @override Future<VehicleListing> createListing(Map<String,dynamic> data) async { final r=await client.post(Uri.parse('$baseUrl/my-listings'),headers:headers,body:jsonEncode(data));check(r,201);return VehicleListing.fromJson(jsonDecode(r.body)); }
 @override Future<void> setListingStatus(String id,String status) async { final r=await client.patch(Uri.parse('$baseUrl/my-listings/$id'),headers:headers,body:jsonEncode({'status':status}));check(r,200); }
 @override Future<void> cancelBooking(String id) async { final r=await client.delete(Uri.parse('$baseUrl/bookings/$id'),headers:headers);check(r,204); }
 @override Future<List<Booking>> bookings() async { final r = await client.get(Uri.parse('$baseUrl/bookings'), headers: headers); check(r, 200); return (jsonDecode(r.body)['items'] as List).map((x) => Booking.fromJson(x)).toList(); }
 @override Future<Booking> createBooking({required String vehicleId, required DateTime start, required DateTime end}) async { final r = await client.post(Uri.parse('$baseUrl/bookings'), headers: headers, body: jsonEncode({'vehicleId': vehicleId, 'startDate': start.toIso8601String().substring(0, 10), 'endDate': end.toIso8601String().substring(0, 10)})); check(r, 201); return Booking.fromJson(jsonDecode(r.body)); }
}
