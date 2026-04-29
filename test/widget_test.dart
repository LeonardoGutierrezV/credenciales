import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:credenciales/main.dart';
import 'package:credenciales/models/credential_model.dart';

void main() {
  testWidgets('Credential app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CredentialModel(),
        child: const CredencialesApp(),
      ),
    );

    // Verify that our app has the title.
    expect(find.text('Credenciales PVC Pro - Generador'), findsOneWidget);
    
    // Verify that the config panel is present.
    expect(find.text('CONFIGURACIÓN'), findsOneWidget);
  });
}
