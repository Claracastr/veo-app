import '../../services/auth_service.dart';
import 'login_view_model.dart';
abstract final class LoginFactory { static LoginViewModel create() => LoginViewModel(AuthService()); }
