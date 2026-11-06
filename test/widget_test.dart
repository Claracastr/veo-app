import 'package:flutter_test/flutter_test.dart';
import 'package:veo/main.dart';

void main() {
  testWidgets('shows the VEO login screen', (tester) async {
    await tester.pumpWidget(const VeoApp());

    expect(find.text('Seu próximo caminho começa aqui.'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Demo: clara@veo.app  •  senha 123456'), findsOneWidget);
  });
}
