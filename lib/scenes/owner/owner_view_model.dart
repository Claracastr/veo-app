import 'package:flutter/foundation.dart';
import '../../models/vehicle_listing.dart';
import '../../services/vehicle_repository.dart';
class OwnerViewModel extends ChangeNotifier {
 final VehicleRepository repository;
 OwnerViewModel(this.repository);
 List<VehicleListing> items=[];bool loading=false;String? error;
 Future<void> load() async {loading=true;error=null;notifyListeners();try{items=await repository.myListings();}catch(e){error='Não foi possível carregar anúncios: $e';}finally{loading=false;notifyListeners();}}
 Future<void> changeStatus(String id,String status) async {try{await repository.setListingStatus(id,status);await load();}catch(e){error='Erro ao atualizar anúncio: $e';notifyListeners();}}
}
