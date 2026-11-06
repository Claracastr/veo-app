class VehicleListing {
  final String id, ownerId, brand, model, year, city, transmission, fuel, description, imageUrl, status;
  final int seats;
  final double dailyPrice;
  final List<String> photoUrls;
  const VehicleListing({required this.id, required this.ownerId, required this.brand, required this.model, required this.year, required this.city, required this.transmission, required this.fuel, required this.description, required this.imageUrl, required this.status, required this.seats, required this.dailyPrice, required this.photoUrls});
  String get name => '$brand $model';
  Map<String, dynamic> toJson() => {'id':id,'ownerId':ownerId,'brand':brand,'model':model,'year':year,'city':city,'transmission':transmission,'fuel':fuel,'description':description,'imageUrl':imageUrl,'status':status,'seats':seats,'dailyPrice':dailyPrice,'photoUrls':photoUrls};
  factory VehicleListing.fromJson(Map<String,dynamic> j) => VehicleListing(id:j['id'].toString(),ownerId:j['ownerId'].toString(),brand:j['brand'].toString(),model:j['model'].toString(),year:j['year'].toString(),city:j['city'].toString(),transmission:j['transmission'].toString(),fuel:j['fuel'].toString(),description:j['description']?.toString()??'',imageUrl:j['imageUrl']?.toString()??'',status:j['status']?.toString()??'active',seats:(j['seats'] as num).toInt(),dailyPrice:(j['dailyPrice'] as num).toDouble(),photoUrls:(j['photoUrls'] as List? ?? []).map((v)=>v.toString()).toList());
}
