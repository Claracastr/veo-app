import 'package:flutter/material.dart';
import 'package:veo_design_system/veo_design_system.dart';
import '../../services/vehicle_repository.dart';
import 'login_factory.dart';
import 'login_view_model.dart';
import 'login_coordinator.dart';
class LoginView extends StatefulWidget {
 final VehicleRepository repository; const LoginView({super.key, required this.repository});
 @override State<LoginView> createState() => _LoginViewState();
}
class _LoginViewState extends State<LoginView> {
 late final LoginViewModel vm = LoginFactory.create();
 final email = TextEditingController(text: 'clara@veo.app'); final password = TextEditingController(text: '123456');
 @override void initState() { super.initState(); vm.addListener(_refresh); }
 void _refresh() { if (mounted) setState(() {}); }
 @override void dispose() { vm.removeListener(_refresh); vm.dispose(); email.dispose(); password.dispose(); super.dispose(); }
 Future<void> _submit() async { final ok = await vm.login(email.text, password.text); if (ok && mounted) LoginCoordinator(widget.repository).openHome(context); }
 @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(26), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  const SizedBox(height: 38), Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: VeoColors.mint, borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.key_rounded, size: 28)), const SizedBox(width: 10), const Text('veo.', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: VeoColors.forest))]),
  const SizedBox(height: 60), Text('Seu próximo caminho começa aqui.', style: Theme.of(context).textTheme.displaySmall), const SizedBox(height: 14), const Text('Alugue carros de pessoas reais, com liberdade para ir mais longe.', style: TextStyle(color: VeoColors.muted, fontSize: 16)),
  const SizedBox(height: 45), VeoTextField(label: 'E-mail', prefixIcon: Icons.mail_outline, controller: email), const SizedBox(height: 14), VeoTextField(label: 'Senha', prefixIcon: Icons.lock_outline, controller: password, obscureText: true),
  if (vm.error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(vm.error!, style: const TextStyle(color: VeoColors.danger))), const SizedBox(height: 22),
  VeoButton(label: 'Entrar', icon: Icons.arrow_forward, loading: vm.loading, onPressed: _submit), const SizedBox(height: 14), const Center(child: Text('Demo: clara@veo.app  •  senha 123456', style: TextStyle(fontSize: 12, color: VeoColors.muted))),
 ]))));
}
