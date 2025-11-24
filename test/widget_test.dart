// Este é um teste básico de widget Flutter.
// Para interagir com um widget em seu teste, use o WidgetTester.
// Para aprender mais sobre testes de widget, visite a documentação oficial.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// O nome do seu projeto pode ser diferente, ajuste o import se necessário
import 'package:tree_scan/lib/main.dart';
// CORREÇÃO: O nome da classe principal do seu aplicativo é TreeScanApp, não MyApp.
// O teste padrão do Flutter tenta usar 'MyApp', mas isso não existe mais no seu projeto.

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // MUDANÇA AQUI: Usa TreeScanApp em vez de MyApp
    await tester.pumpWidget(const TreeScanApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}