import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veo/services/mock_vehicle_repository.dart';

void main() {
 group('MockVehicleRepository', () {
  late MockVehicleRepository repo;
  setUp(() { SharedPreferences.setMockInitialValues({}); repo = MockVehicleRepository(); });
  test('lista veículos de várias cidades', () async {
   expect((await repo.list()).length, 22);
  });
  test('busca por cidade/marca', () async {
   expect((await repo.list(search: 'Palmas')).length, 2);
   expect((await repo.list(search: 'Jeep')).length, 2);
  });
  test('reserva calcula dias inclusivos e bloqueia sobreposição', () async {
   final start = DateTime.now().add(const Duration(days: 20));
   final day = DateTime(start.year, start.month, start.day);
   final end = day.add(const Duration(days: 2));
   final booking = await repo.createBooking(vehicleId: 'car_001', start: day, end: end);
   expect(booking.total, 657);
   expect(booking.status, 'pending');
   expect(() => repo.createBooking(vehicleId: 'car_001', start: day, end: end), throwsStateError);
  });
  test('reserva permanece salva em outra instância no mesmo login', () async {
   final start = DateTime.now().add(const Duration(days: 30));
   final day = DateTime(start.year, start.month, start.day);
   await repo.createBooking(vehicleId: 'car_005', start: day, end: day);
   final reopened = MockVehicleRepository(userId: 'usr_001');
   expect((await reopened.bookings()).length, 1);
   final other = MockVehicleRepository(userId: 'outro_usuario');
   expect(await other.bookings(), isEmpty);
  });
  test('não aceita datas invertidas', () async {
   final start = DateTime.now().add(const Duration(days: 10));
   expect(() => repo.createBooking(vehicleId: 'car_001', start: start, end: start.subtract(const Duration(days: 1))), throwsStateError);
  });
 });
}
