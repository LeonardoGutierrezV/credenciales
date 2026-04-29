import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credenciales/models/credential_model.dart';
import 'package:credenciales/widgets/config_panel.dart';
import 'package:credenciales/widgets/credential_preview.dart';
import 'package:credenciales/services/print_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CredentialModel(),
      child: const CredencialesApp(),
    ),
  );
}

class CredencialesApp extends StatelessWidget {
  const CredencialesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Credenciales PVC Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CredentialModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Credenciales PVC Pro - Generador'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'new') {
                model.reset();
              } else if (value == 'pdf') {
                PrintService.exportPdf(model);
              } else if (value == 'print') {
                PrintService.printCredential(model);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'new', child: Text('Nueva Credencial')),
              const PopupMenuItem(value: 'pdf', child: Text('Exportar PDF')),
              const PopupMenuItem(value: 'print', child: Text('Imprimir')),
            ],
          ),
        ],
      ),
      body: Row(
        children: [
          const ConfigPanel(),
          Expanded(
            child: Container(
              color: Colors.grey[400],
              padding: const EdgeInsets.all(32),
              child: const CredentialPreview(),
            ),
          ),
        ],
      ),
    );
  }
}
