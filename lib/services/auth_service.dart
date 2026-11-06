class AuthService {
 Future<bool> login(String email, String password) async {
  await Future<void>.delayed(const Duration(milliseconds: 300));
  return email == 'clara@veo.app' && password == '123456';
 }
}
