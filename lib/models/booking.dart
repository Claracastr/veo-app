class Booking {
 final String id, vehicleId, startDate, endDate, status;
 final double total;
 const Booking({required this.id, required this.vehicleId, required this.startDate, required this.endDate, required this.status, required this.total});
 Map<String, dynamic> toJson() => {'id': id, 'vehicleId': vehicleId, 'startDate': startDate, 'endDate': endDate, 'status': status, 'total': total};
 factory Booking.fromJson(Map<String, dynamic> j) => Booking(id: j['id'], vehicleId: j['vehicleId'], startDate: j['startDate'], endDate: j['endDate'], status: j['status'], total: (j['total'] as num).toDouble());
}
