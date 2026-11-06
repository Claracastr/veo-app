import 'package:flutter/material.dart';
import '../home/home_view.dart';
import '../../services/vehicle_repository.dart';
class LoginCoordinator {
 final VehicleRepository repository; const LoginCoordinator(this.repository);
 void openHome(BuildContext context) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeView(repository: repository)));
}
