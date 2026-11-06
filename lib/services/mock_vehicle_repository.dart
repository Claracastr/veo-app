import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vehicle.dart';
import '../models/booking.dart';
import '../models/vehicle_listing.dart';
import 'vehicle_repository.dart';
class MockVehicleRepository implements VehicleRepository {
 final List<Vehicle> _cars = [
    Vehicle.fromJson({"id": "car_001", "brand": "Jeep", "model": "Renegade", "year": "2023", "city": "Palmas, TO", "transmission": "Automático", "fuel": "Flex", "seats": 5, "dailyPrice": 219, "rating": 4.9, "available": true, "description": "SUV confortável, perfeito para viagens e passeios pela cidade.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/Brazilian%20Jeep%20Renegade.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_002", "brand": "Volkswagen", "model": "Polo", "year": "2024", "city": "Palmas, TO", "transmission": "Automático", "fuel": "Flex", "seats": 5, "dailyPrice": 159, "rating": 4.8, "available": true, "description": "Econômico, moderno e fácil de dirigir.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/2024%20Volkswagen%20Polo%201.6%20MSi%20Highline%20AT%20%28Brazil%29.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_003", "brand": "Toyota", "model": "Corolla", "year": "2022", "city": "Goiânia, GO", "transmission": "Automático", "fuel": "Flex", "seats": 5, "dailyPrice": 249, "rating": 5.0, "available": true, "description": "Conforto e elegância para sua próxima experiência.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/2022%20Toyota%20Corolla%202.0%20XLI%20CVT%20%28Brazil%29.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_004", "brand": "Fiat", "model": "Argo", "year": "2023", "city": "Brasília, DF", "transmission": "Manual", "fuel": "Flex", "seats": 5, "dailyPrice": 129, "rating": 4.7, "available": true, "description": "Praticidade no dia a dia e ótimo custo-benefício.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/2023%20Fiat%20Argo%201.3%20Drive%20%28facelift%2C%20Brazil%29.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_005", "brand": "Hyundai", "model": "HB20", "year": "2024", "city": "Palmas, TO", "transmission": "Automático", "fuel": "Flex", "seats": 5, "dailyPrice": 149, "rating": 4.8, "available": true, "description": "Compacto ágil e econômico para passear pela cidade.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/2023%20Hyundai%20HB20%201.0%20T-GDi%20Platinum%20Plus%20%28Brazil%29%20front%20view%2002.png?width=960"}),
    Vehicle.fromJson({"id": "car_006", "brand": "Chevrolet", "model": "Onix", "year": "2023", "city": "Araguaína, TO", "transmission": "Manual", "fuel": "Flex", "seats": 5, "dailyPrice": 139, "rating": 4.7, "available": true, "description": "Ideal para trajetos urbanos e viagens curtas.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/2021%20Chevrolet%20Onix%201.0T%20Premier%20%28Chile%29%20front%20view.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_007", "brand": "Fiat", "model": "Toro", "year": "2024", "city": "Araguaína, TO", "transmission": "Automático", "fuel": "Flex", "seats": 5, "dailyPrice": 269, "rating": 4.9, "available": true, "description": "Picape confortável para viajar com espaço.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/2024%20Fiat%20Toro%202.0%20Volcano%204x4.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_008", "brand": "Honda", "model": "Civic", "year": "2022", "city": "Goiânia, GO", "transmission": "Automático", "fuel": "Flex", "seats": 5, "dailyPrice": 239, "rating": 4.8, "available": true, "description": "Sedã confortável e moderno.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/2022%20Honda%20Civic%201.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_009", "brand": "Nissan", "model": "Kicks", "year": "2024", "city": "Brasília, DF", "transmission": "Automático", "fuel": "Flex", "seats": 5, "dailyPrice": 209, "rating": 4.9, "available": true, "description": "SUV compacto e econômico para explorar a cidade.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/Nissan%20Kicks.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_010", "brand": "Volkswagen", "model": "T-Cross", "year": "2024", "city": "Belo Horizonte, MG", "transmission": "Automático", "fuel": "Flex", "seats": 5, "dailyPrice": 249, "rating": 4.9, "available": true, "description": "SUV versátil para deslocamentos e viagens.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/Volkswagen%20T-Cross%20170%20TSi%20Trendline%202022.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_011", "brand": "Fiat", "model": "Mobi", "year": "2023", "city": "Belo Horizonte, MG", "transmission": "Manual", "fuel": "Flex", "seats": 5, "dailyPrice": 109, "rating": 4.6, "available": true, "description": "Prático para o dia a dia e fácil de estacionar.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/2022%20Fiat%20Mobi%201.0%20Trekking.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_012", "brand": "Jeep", "model": "Compass", "year": "2023", "city": "São Paulo, SP", "transmission": "Automático", "fuel": "Flex", "seats": 5, "dailyPrice": 299, "rating": 4.9, "available": true, "description": "SUV completo com espaço e conforto.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/Jeep%20Compass%20%28MP%29%20PHEV%20Facelift%201X7A0140.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_013", "brand": "Toyota", "model": "Yaris", "year": "2024", "city": "São Paulo, SP", "transmission": "Automático", "fuel": "Flex", "seats": 5, "dailyPrice": 189, "rating": 4.8, "available": true, "description": "Hatch confiável e confortável.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/Toyota%20yaris%2C%202024.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_014", "brand": "Renault", "model": "Kwid", "year": "2024", "city": "Curitiba, PR", "transmission": "Manual", "fuel": "Flex", "seats": 5, "dailyPrice": 99, "rating": 4.6, "available": true, "description": "Compacto para circular e economizar.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/Renault%20Kwid%201.0%20Outsider%202024%20%2853459301692%29.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_015", "brand": "Hyundai", "model": "Creta", "year": "2023", "city": "Curitiba, PR", "transmission": "Automático", "fuel": "Flex", "seats": 5, "dailyPrice": 229, "rating": 4.8, "available": true, "description": "SUV espaçoso e confortável.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/2023%20Hyundai%20Creta%20Black%20Edition.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_016", "brand": "Chevrolet", "model": "Tracker", "year": "2024", "city": "Rio de Janeiro, RJ", "transmission": "Automático", "fuel": "Flex", "seats": 5, "dailyPrice": 239, "rating": 4.8, "available": true, "description": "Perfeito para passeios pela cidade.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/2024%20Chevrolet%20Tracker%201.2%20Turbo%20AT.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_017", "brand": "Volkswagen", "model": "Nivus", "year": "2024", "city": "Rio de Janeiro, RJ", "transmission": "Automático", "fuel": "Flex", "seats": 5, "dailyPrice": 219, "rating": 4.9, "available": true, "description": "Design moderno e conforto para viajar.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/Volkswagen%20Nivus%20200%20TSi%20Comfortline%202024.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_018", "brand": "Fiat", "model": "Pulse", "year": "2024", "city": "Salvador, BA", "transmission": "Automático", "fuel": "Flex", "seats": 5, "dailyPrice": 189, "rating": 4.7, "available": true, "description": "SUV compacto para explorar novos destinos.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/2024%20Fiat%20Pulse%201.0%20Turbo%20200%20Audace%20%28front%29.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_019", "brand": "Toyota", "model": "Corolla Cross", "year": "2023", "city": "Recife, PE", "transmission": "Automático", "fuel": "Flex", "seats": 5, "dailyPrice": 279, "rating": 4.9, "available": true, "description": "Espaço e conforto para viajar em família.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/2023%20Toyota%20Corolla%20Cross%20XLE%204WD%20in%20Wind%20Chill%20Pearl%2C%20front%20left.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_020", "brand": "Chevrolet", "model": "Spin", "year": "2023", "city": "Fortaleza, CE", "transmission": "Automático", "fuel": "Flex", "seats": 7, "dailyPrice": 229, "rating": 4.7, "available": true, "description": "Excelente opção para viagens em grupo.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/Chevrolet%20Spin%201.8%20Premier%202022.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_021", "brand": "Volkswagen", "model": "Virtus", "year": "2024", "city": "Londrina, PR", "transmission": "Automático", "fuel": "Flex", "seats": 5, "dailyPrice": 179, "rating": 4.8, "available": true, "description": "Sedã amplo e econômico.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/2024%20Volkswagen%20Virtus%201.6%20MSi%20Trendline%20%28facelift%29.jpg?width=960"}),
    Vehicle.fromJson({"id": "car_022", "brand": "Honda", "model": "HR-V", "year": "2023", "city": "Campinas, SP", "transmission": "Automático", "fuel": "Flex", "seats": 5, "dailyPrice": 259, "rating": 4.9, "available": true, "description": "SUV elegante, seguro e confortável.", "imageUrl": "https://commons.wikimedia.org/wiki/Special:FilePath/2023%20Honda%20HR-V%201.5%20SE%20RV3%20%2820241007%29.jpg?width=960"}),
 ];
 final String userId;
 MockVehicleRepository({this.userId = 'usr_001'});
 static const String _storagePrefix = 'veo_bookings_v2_';
 static const String _listingPrefix = 'veo_listings_v1_';
 Future<List<VehicleListing>> _readListings() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString('$_listingPrefix$userId');
  if (raw == null || raw.isEmpty) return [];
  try { return (jsonDecode(raw) as List).map((v)=>VehicleListing.fromJson(Map<String,dynamic>.from(v))).toList(); } catch (_) { return []; }
 }
 Future<void> _saveListings(List<VehicleListing> values) async {
  final prefs = await SharedPreferences.getInstance();
  if (!await prefs.setString('$_listingPrefix$userId', jsonEncode(values.map((v)=>v.toJson()).toList()))) throw StateError('Não foi possível salvar seu anúncio.');
 }
 @override Future<List<VehicleListing>> myListings() async => List.unmodifiable(await _readListings());
 @override Future<VehicleListing> createListing(Map<String,dynamic> data) async {
  final listing = VehicleListing.fromJson({...data, 'id':'owner_${DateTime.now().microsecondsSinceEpoch}', 'ownerId':userId,'status':'active'});
  final values = await _readListings(); values.add(listing); await _saveListings(values); return listing;
 }
 @override Future<void> setListingStatus(String id,String status) async {
  if (status != 'active' && status != 'paused') throw StateError('Status inválido');
  final values=await _readListings(); final index=values.indexWhere((v)=>v.id==id);
  if(index<0)throw StateError('Anúncio não encontrado');
  values[index]=VehicleListing.fromJson({...values[index].toJson(),'status':status});
  await _saveListings(values);
 }
 @override Future<void> cancelBooking(String id) async {
  final values=await _readBookings(); final index=values.indexWhere((b)=>b.id==id);
  if(index<0)throw StateError('Reserva não encontrada');
  values[index]=Booking.fromJson({...values[index].toJson(),'status':'cancelled'}); await _saveBookings(values);
 }

 Future<List<Booking>> _readBookings() async {
   final prefs = await SharedPreferences.getInstance();
   final raw = prefs.getString('$_storagePrefix$userId');
   if (raw == null || raw.isEmpty) return [];
   try {
     return (jsonDecode(raw) as List).map((v) => Booking.fromJson(v as Map<String, dynamic>)).toList();
   } catch (_) { return []; }
 }
 Future<void> _saveBookings(List<Booking> values) async {
   final prefs = await SharedPreferences.getInstance();
   final saved = await prefs.setString('$_storagePrefix$userId', jsonEncode(values.map((v) => v.toJson()).toList()));
   if (!saved) throw StateError('Não foi possível salvar a reserva neste dispositivo.');
 }
 Future<void> _delay() => Future<void>.delayed(const Duration(milliseconds: 280));
 @override Future<List<Vehicle>> list({String? search}) async { await _delay(); final q = (search ?? '').toLowerCase().trim(); final mine = await _readListings(); final listed=mine.where((v)=>v.status=='active').map((v)=>Vehicle.fromJson({...v.toJson(),'rating':0.0,'available':true})).toList(); return [..._cars,...listed].where((c) => '${c.name} ${c.city} ${c.transmission}'.toLowerCase().contains(q)).toList(); }
 @override Future<Vehicle> getById(String id) async { await _delay(); return (await list()).firstWhere((c) => c.id == id); }
 @override Future<List<Booking>> bookings() async { await _delay(); return List.unmodifiable(await _readBookings()); }
 @override
 Future<Booking> createBooking({required String vehicleId, required DateTime start, required DateTime end}) async {
  await _delay();
  final startDay = DateTime(start.year, start.month, start.day);
  final endDay = DateTime(end.year, end.month, end.day);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  if (startDay.isBefore(today) || endDay.isBefore(startDay)) {
   throw StateError('Selecione um período válido, começando hoje ou depois.');
  }
  final carMatches = (await list()).where((item) => item.id == vehicleId);
  if (carMatches.isEmpty) throw StateError('Veículo não encontrado.');
  final car = carMatches.first;
  if (!car.available) throw StateError('Veículo indisponível.');
  final from = _formatDate(startDay);
  final to = _formatDate(endDay);
  final existingBookings = await _readBookings();
  final overlap = existingBookings.any((b) => b.vehicleId == vehicleId &&
      b.status != 'cancelled' && from.compareTo(b.endDate) <= 0 &&
      to.compareTo(b.startDate) >= 0);
  if (overlap) throw StateError('Este carro já possui uma reserva neste período.');
  final days = endDay.difference(startDay).inDays + 1;
  final booking = Booking(
   id: 'book_${DateTime.now().microsecondsSinceEpoch}',
   vehicleId: vehicleId, startDate: from, endDate: to,
   total: days * car.dailyPrice, status: 'pending',
  );
  existingBookings.add(booking);
  await _saveBookings(existingBookings);
  return booking;
 }
 static String _formatDate(DateTime date) =>
  '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
