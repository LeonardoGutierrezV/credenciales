import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:credenciales/models/credential_model.dart';
import 'package:credenciales/services/template_service.dart';

class ConfigPanel extends StatefulWidget {
  const ConfigPanel({super.key});

  @override
  State<ConfigPanel> createState() => _ConfigPanelState();
}

class _ConfigPanelState extends State<ConfigPanel> {
  final TextEditingController _templateController = TextEditingController();

  Future<void> _pickImage(BuildContext context, bool isLogo) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final model = Provider.of<CredentialModel>(context, listen: false);
      if (isLogo) {
        model.updateLogo(image.path);
      } else {
        model.updatePhoto(image.path);
      }
    }
  }

  void _pickColor(BuildContext context, Color initialColor, Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: initialColor,
            onColorChanged: onColorChanged,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

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

    return Container(
      width: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: const Border(right: BorderSide(color: Colors.grey)),
      ),
      child: ListView(
        children: [
          Text('CONFIGURACIÓN', style: Theme.of(context).textTheme.headlineSmall),
          const Divider(),
          
          const Text('Orientación', style: TextStyle(fontWeight: FontWeight.bold)),
          SegmentedButton<CredentialOrientation>(
            segments: const [
              ButtonSegment(value: CredentialOrientation.landscape, label: Text('Horizontal')),
              ButtonSegment(value: CredentialOrientation.portrait, label: Text('Vertical')),
            ],
            selected: {model.orientation},
            onSelectionChanged: (set) => model.updateOrientation(set.first),
          ),
          const SizedBox(height: 16),

          const Text('Plantillas', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: () => _saveTemplate(model), child: const Text('Guardar'))),
              const SizedBox(width: 8),
              Expanded(child: ElevatedButton(onPressed: () => _loadTemplate(model), child: const Text('Cargar'))),
            ],
          ),
          const SizedBox(height: 16),

          const Text('Dimensiones (Altura %)', style: TextStyle(fontWeight: FontWeight.bold)),
          _buildSlider('Logo', model.logoHeightFactor, (v) => model.updateLogoHeight(v)),
          _buildSlider('Foto', model.photoHeightFactor, (v) => model.updatePhotoHeight(v)),
          _buildSlider('Banda', model.bandHeightFactor, (v) => model.updateBandHeight(v)),
          _buildSlider('Posición Banda', model.bandPositionFactor, (v) => model.updateBandPosition(v)),
          _buildSlider('Código', model.barcodeHeightFactor, (v) => model.updateBarcodeHeight(v)),
          const Divider(),

          const Text('Multimedia', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _pickImage(context, true),
                  icon: const Icon(Icons.logo_dev),
                  label: const Text('Logo'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _pickImage(context, false),
                  icon: const Icon(Icons.person),
                  label: const Text('Foto'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          const Text('Datos', style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            decoration: const InputDecoration(labelText: 'Nombre del Colaborador'),
            onChanged: (val) => model.updateCollaboratorName(val),
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Nombre de Empresa'),
            onChanged: (val) => model.updateCompanyName(val),
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Número de Empleado'),
            onChanged: (val) => model.updateEmployeeId(val),
          ),
          const SizedBox(height: 16),

          const Text('Código', style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<CodeType>(
            value: model.codeType,
            isExpanded: true,
            items: CodeType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.name.toUpperCase()),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) model.updateCodeType(val);
            },
          ),
          const SizedBox(height: 16),

          const Text('Estética', style: TextStyle(fontWeight: FontWeight.bold)),
          ListTile(
            title: const Text('Fondo Credencial'),
            trailing: CircleAvatar(backgroundColor: model.backgroundColor),
            onTap: () => _pickColor(context, model.backgroundColor, (c) => model.updateBackgroundColor(c)),
          ),
          ListTile(
            title: const Text('Color Banda'),
            trailing: CircleAvatar(backgroundColor: model.bandColor),
            onTap: () => _pickColor(context, model.bandColor, (c) => model.updateBandColor(c)),
          ),
          ListTile(
            title: const Text('Color Texto'),
            trailing: CircleAvatar(backgroundColor: model.textColor),
            onTap: () => _pickColor(context, model.textColor, (c) => model.updateTextColor(c)),
          ),
          CheckboxListTile(
            title: const Text('Fondo Texto Transparente'),
            value: model.transparentTextBackground,
            onChanged: (val) => model.toggleTransparentTextBackground(val),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, Function(double) onChanged) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 12))),
        Expanded(
          child: Slider(
            value: value,
            min: 0.05,
            max: 0.9,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
