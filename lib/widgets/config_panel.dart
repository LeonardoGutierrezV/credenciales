import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:credenciales/models/credential_model.dart';

class ConfigPanel extends StatefulWidget {
  const ConfigPanel({super.key});

  @override
  State<ConfigPanel> createState() => _ConfigPanelState();
}

class _ConfigPanelState extends State<ConfigPanel> {
  Future<void> _pickImage(BuildContext context, Function(String) onPicked) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      onPicked(image.path);
    }
  }

  void _pickColor(BuildContext context, Color initialColor, Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Color'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ColorPicker(
                pickerColor: initialColor,
                onColorChanged: onColorChanged,
                enableAlpha: true,
                displayThumbColor: true,
                paletteType: PaletteType.hsvWithHue,
              ),
              const SizedBox(height: 16),
              const Text('Entrada Manual (RGBA / HEX)', style: TextStyle(fontWeight: FontWeight.bold)),
              ColorPickerInput(
                initialColor,
                onColorChanged,
              ),
            ],
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

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CredentialModel>();

    return Container(
      width: 400,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: const Border(right: BorderSide(color: Colors.grey)),
      ),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('DISEÑADOR DE CREDENCIALES', 
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(),
          
          _buildOrientationSection(model),
          
          // 1. Logotipo
          _buildExpansionTile(
            title: '1. Logotipo',
            children: [
              _buildImageSelector('Logotipo', model.logoPath, (path) => model.updateLogoPath(path)),
              _buildSlider('Posición Y', model.logoPosY, (v) => model.updateLogoPosY(v)),
              _buildCheckbox('Centrado X', model.logoCenteredX, (v) => model.updateLogoCenteredX(v!)),
              if (!model.logoCenteredX)
                _buildSlider('Posición X', model.logoPosX, (v) => model.updateLogoPosX(v)),
              _buildSlider('Tamaño', model.logoSize, (v) => model.updateLogoSize(v)),
            ],
          ),

          // 2. Fotografía
          _buildExpansionTile(
            title: '2. Fotografía',
            children: [
              _buildImageSelector('Fotografía', model.photoPath, (path) => model.updatePhotoPath(path)),
              _buildSlider('Posición Y', model.photoPosY, (v) => model.updatePhotoPosY(v)),
              _buildCheckbox('Centrado X', model.photoCenteredX, (v) => model.updatePhotoCenteredX(v!)),
              if (!model.photoCenteredX)
                _buildSlider('Posición X', model.photoPosX, (v) => model.updatePhotoPosX(v)),
              _buildSlider('Tamaño', model.photoSize, (v) => model.updatePhotoSize(v)),
            ],
          ),

          // 3. Persona
          _buildExpansionTile(
            title: '3. Persona',
            children: [
              _buildSubHeader('Banda'),
              _buildSlider('Posición Y', model.bandPosY, (v) => model.updateBandPosY(v)),
              _buildSlider('Tamaño (Alto)', model.bandHeight, (v) => model.updateBandHeight(v)),
              _buildColorTile('Color de banda', model.bandColor, (c) => model.updateBandColor(c)),
              _buildCheckbox('Usar Imagen de fondo', model.useBandImage, (v) => model.updateUseBandImage(v!)),
              if (model.useBandImage) ...[
                 _buildImageSelector('Imagen de banda', model.bandImagePath, (path) => model.updateBandImagePath(path)),
                 _buildDropdown<BandImageMode>(
                   label: 'Modo Imagen',
                   value: model.bandImageMode,
                   items: BandImageMode.values,
                   onChanged: (v) => model.updateBandImageMode(v!),
                 ),
              ],
              const Divider(),
              _buildSubHeader('Etiqueta'),
              _buildTextField('Nombre Colaborador', model.collaboratorName, (v) => model.updateCollaboratorName(v), multiline: true),
              _buildSlider('Tamaño letra', model.labelFontSize / 40, (v) => model.updateLabelFontSize(v * 40), min: 0.1),
              _buildDropdown<FontType>(
                label: 'Tipo letra',
                value: model.labelFontType,
                items: FontType.values,
                onChanged: (v) => model.updateLabelFontType(v!),
              ),
              _buildCheckbox('Ajustar texto (Wrap)', model.labelWrapText, (v) => model.updateLabelWrapText(v!)),
              _buildSlider('Borde Vertical', model.labelVerticalBorder / 50, (v) => model.updateLabelVerticalBorder(v * 50)),
              _buildSlider('Borde Horizontal', model.labelHorizontalBorder / 50, (v) => model.updateLabelHorizontalBorder(v * 50)),
              _buildSlider('Interlineado', (model.labelLineSpacing - 0.5) / 2.5, (v) => model.updateLabelLineSpacing(0.5 + v * 2.5)),
              _buildColorTile('Color Texto', model.labelTextColor, (c) => model.updateLabelTextColor(c)),
            ],
          ),

          // 4. Control
          _buildExpansionTile(
            title: '4. Control',
            children: [
              _buildTextField('Dato Código', model.controlData, (v) => model.updateControlData(v)),
              _buildDropdown<CodeType>(
                label: 'Tipo de Código',
                value: model.codeType,
                items: CodeType.values,
                onChanged: (v) => model.updateCodeType(v!),
              ),
              _buildSlider('Posición Y', model.controlPosY, (v) => model.updateControlPosY(v)),
              _buildCheckbox('Centrado X', model.controlCenteredX, (v) => model.updateControlCenteredX(v!)),
              if (!model.controlCenteredX)
                _buildSlider('Posición X', model.controlPosX, (v) => model.updateControlPosX(v)),
              _buildSlider('Tamaño', model.controlSize, (v) => model.updateControlSize(v)),
              _buildColorTile('Color Código', model.controlColor, (c) => model.updateControlColor(c)),
            ],
          ),

          // 5. Empresa
          _buildExpansionTile(
            title: '5. Empresa',
            children: [
              _buildTextField('Nombre Empresa', model.companyName, (v) => model.updateCompanyName(v)),
              _buildSlider('Tamaño letra', model.companyFontSize / 40, (v) => model.updateCompanyFontSize(v * 40), min: 0.1),
              _buildDropdown<FontType>(
                label: 'Tipo letra',
                value: model.companyFontType,
                items: FontType.values,
                onChanged: (v) => model.updateCompanyFontType(v!),
              ),
              _buildSlider('Borde Horizontal', model.companyHorizontalBorder / 50, (v) => model.updateCompanyHorizontalBorder(v * 50)),
              _buildSlider('Interlineado', (model.companyLineSpacing - 0.5) / 2.5, (v) => model.updateCompanyLineSpacing(0.5 + v * 2.5)),
              _buildColorTile('Color Texto', model.companyTextColor, (c) => model.updateCompanyTextColor(c)),
            ],
          ),

          _buildColorTile('Fondo Credencial', model.backgroundColor, (c) => model.updateBackgroundColor(c)),
        ],
      ),
    );
  }

  Widget _buildOrientationSection(CredentialModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Orientación', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          SegmentedButton<CredentialOrientation>(
            segments: const [
              ButtonSegment(value: CredentialOrientation.landscape, label: Text('Horizontal')),
              ButtonSegment(value: CredentialOrientation.portrait, label: Text('Vertical')),
            ],
            selected: {model.orientation},
            onSelectionChanged: (set) => model.updateOrientation(set.first),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        childrenPadding: const EdgeInsets.all(12),
        children: children,
      ),
    );
  }

  Widget _buildSubHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
    );
  }

  Widget _buildImageSelector(String label, String currentPath, Function(String) onPicked) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontSize: 14)),
      subtitle: Text(currentPath.isEmpty ? 'No seleccionada' : currentPath.split('\\').last, overflow: TextOverflow.ellipsis),
      trailing: IconButton(
        icon: const Icon(Icons.image_search),
        onPressed: () => _pickImage(context, onPicked),
      ),
    );
  }

  Widget _buildSlider(String label, double value, Function(double) onChanged, {double min = 0.0, double max = 1.0}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontSize: 14)),
      value: value,
      onChanged: onChanged,
      dense: true,
    );
  }

  Widget _buildTextField(String label, String initialValue, Function(String) onChanged, {bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), isDense: true),
        onChanged: onChanged,
        maxLines: multiline ? null : 1,
        keyboardType: multiline ? TextInputType.multiline : TextInputType.text,
        controller: TextEditingController(text: initialValue)..selection = TextSelection.collapsed(offset: initialValue.length),
      ),
    );
  }

  Widget _buildColorTile(String label, Color color, Function(Color) onPicked) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontSize: 14)),
      trailing: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black26),
          shape: BoxShape.circle,
        ),
      ),
      onTap: () => _pickColor(context, color, onPicked),
    );
  }

  Widget _buildDropdown<T>({required String label, required T value, required List<T> items, required Function(T?) onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          DropdownButton<T>(
            value: value,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e.toString().split('.').last))).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
