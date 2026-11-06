import 'package:flutter/foundation.dart';
import '../../services/auth_service.dart';
class LoginViewModel extends ChangeNotifier {
 final AuthService service; LoginViewModel(this.service);
 bool loading = false; String? error;
 Future<bool> login(String email, String password) async {
  loading = true; error = null; notifyListeners();
  try { final ok = await service.login(email.trim(), password); if (!ok) error = 'Confira seu e-mail e senha.'; return ok; }
  finally { loading = false; notifyListeners(); }
 }
}
