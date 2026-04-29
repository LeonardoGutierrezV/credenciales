import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:credenciales/models/credential_model.dart';
import 'package:credenciales/services/credential_utils.dart';
import 'package:credenciales/widgets/credential_painter.dart';

class CredentialPreview extends StatefulWidget {
  const CredentialPreview({super.key});

  @override
  State<CredentialPreview> createState() => _CredentialPreviewState();
}

class _CredentialPreviewState extends State<CredentialPreview> {
  ui.Image? _logoImage;
  ui.Image? _photoImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final model = Provider.of<CredentialModel>(context);
    if (model.logoPath.isNotEmpty) {
      final logo = await _loadImage(model.logoPath);
      if (mounted) setState(() => _logoImage = logo);
    } else {
      if (mounted) setState(() => _logoImage = null);
    }
    
    if (model.photoPath.isNotEmpty) {
      final photo = await _loadImage(model.photoPath);
      if (mounted) setState(() => _photoImage = photo);
    } else {
      if (mounted) setState(() => _photoImage = null);
    }
  }

  Future<ui.Image> _loadImage(String path) async {
    final bytes = await File(path).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CredentialModel>();
    final aspectRatio = CredentialUtils.aspectRatio(model.orientation);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;
        
        double width = availableWidth;
        double height = width / aspectRatio;
        
        if (height > availableHeight) {
          height = availableHeight;
          width = height * aspectRatio;
        }

        return Center(
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(width, height),
                  painter: CredentialPainter(
                    model: model,
                    logoImage: _logoImage,
                    photoImage: _photoImage,
                  ),
                ),
                // Overlay Barcode
                Positioned(
                  bottom: height * 0.08,
                  left: width * 0.1,
                  right: width * 0.1,
                  child: SizedBox(
                    height: height * model.barcodeHeightFactor,
                    child: _buildBarcode(model),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBarcode(CredentialModel model) {
    Barcode barcode;
    switch (model.codeType) {
      case CodeType.qr:
        barcode = Barcode.qrCode();
        break;
      case CodeType.ean13:
        barcode = Barcode.ean13();
        break;
      case CodeType.code128:
      default:
        barcode = Barcode.code128();
        break;
    }

    return BarcodeWidget(
      barcode: barcode,
      data: model.employeeId.isEmpty ? ' ' : model.employeeId,
      drawText: false,
    );
  }
}
