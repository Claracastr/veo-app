class Vehicle {
 final String id, brand, model, year, city, transmission, fuel, imageUrl, description;
 final int seats; final double dailyPrice, rating;
 final bool available;
 final List<String> photoUrls;
 const Vehicle({required this.id, required this.brand, required this.model, required this.year, required this.city, required this.transmission, required this.fuel, required this.imageUrl, required this.description, required this.seats, required this.dailyPrice, required this.rating, required this.available, this.photoUrls = const []});
 String get name => '$brand $model';
 factory Vehicle.fromJson(Map<String, dynamic> j) => Vehicle(id: j['id'], brand: j['brand'], model: j['model'], year: j['year'].toString(), city: j['city'], transmission: j['transmission'], fuel: j['fuel'], imageUrl: j['imageUrl'], description: j['description'] ?? '', seats: j['seats'], dailyPrice: (j['dailyPrice'] as num).toDouble(), rating: (j['rating'] as num).toDouble(), available: j['available'] ?? true, photoUrls: (j['photoUrls'] as List? ?? []).map((e)=>e.toString()).toList());
}
