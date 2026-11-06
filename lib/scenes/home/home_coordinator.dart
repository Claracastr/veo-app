import 'package:flutter/material.dart';
import '../../models/vehicle.dart';
import '../../services/vehicle_repository.dart';
import '../vehicle_details/vehicle_details_view.dart';
class HomeCoordinator {
 final VehicleRepository repository; const HomeCoordinator(this.repository);
 void openVehicle(BuildContext context, Vehicle car) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => VehicleDetailsView(repository: repository, car: car)));
}
