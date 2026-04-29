import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credenciales/models/credential_model.dart';
import 'package:credenciales/widgets/config_panel.dart';
import 'package:credenciales/widgets/credential_preview.dart';
import 'package:credenciales/services/print_service.dart';
import 'package:credenciales/services/template_service.dart';

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
      title: 'Diseñador de credenciales',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _templateController = TextEditingController();

  void _saveTemplate(CredentialModel model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Guardar Plantilla'),
        content: TextField(
          controller: _templateController,
          decoration: const InputDecoration(labelText: 'Nombre de la plantilla'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              if (_templateController.text.isNotEmpty) {
                await TemplateService.saveTemplate(_templateController.text, model.toJson());
                if (mounted) Navigator.pop(context);
                _templateController.clear();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _loadTemplate(CredentialModel model) async {
    final templates = await TemplateService.loadTemplates();
    if (templates.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hay plantillas guardadas.')));
      }
      return;
    }

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cargar Plantilla'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: templates.length,
              itemBuilder: (context, index) {
                String name = templates.keys.elementAt(index);
                return ListTile(
                  title: Text(name),
                  onTap: () {
                    model.loadFromTemplate(templates[name]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CredentialModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diseñador de credenciales'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'new': model.reset(); break;
                case 'save': _saveTemplate(model); break;
                case 'load': _loadTemplate(model); break;
                case 'export': PrintService.exportPdf(model); break;
                case 'print': PrintService.printCredential(model); break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'new', child: Text('Nueva credencial')),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'save', child: Text('Guardar Plantilla')),
              const PopupMenuItem(value: 'load', child: Text('Cargar Plantilla')),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'export', child: Text('Exportar')),
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
              color: Colors.grey[300],
              padding: const EdgeInsets.all(32),
              child: const CredentialPreview(),
            ),
          ),
        ],
      ),
    );
  }
}
