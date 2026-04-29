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
  ui.Image? _bandImage;

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

    if (model.useBandImage && model.bandImagePath.isNotEmpty) {
      final band = await _loadImage(model.bandImagePath);
      if (mounted) setState(() => _bandImage = band);
    } else {
      if (mounted) setState(() => _bandImage = null);
    }
  }

  Future<ui.Image?> _loadImage(String path) async {
    try {
      if (path.isEmpty) return null;
      final file = File(path);
      if (!await file.exists()) return null;
      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      return frame.image;
    } catch (e) {
      debugPrint('Error loading image $path: $e');
      return null;
    }
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
                    bandImage: _bandImage,
                  ),
                ),
                _buildBarcodeOverlay(model, width, height),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBarcodeOverlay(CredentialModel model, double width, double height) {
    Barcode barcode;
    switch (model.codeType) {
      case CodeType.qr: barcode = Barcode.qrCode(); break;
      case CodeType.ean13: barcode = Barcode.ean13(); break;
      case CodeType.code128:
      default: barcode = Barcode.code128(); break;
    }

    double codeH = height * model.controlSize;
    double codeW = model.codeType == CodeType.qr ? codeH : codeH * 2; 

    double x = model.controlCenteredX ? (width - codeW) / 2 : width * model.controlPosX;
    double y = height * model.controlPosY;

    return Positioned(
      left: x,
      top: y,
      child: SizedBox(
        width: codeW,
        height: codeH,
        child: BarcodeWidget(
          barcode: barcode,
          data: model.controlData.isEmpty ? ' ' : model.controlData,
          color: model.controlColor,
          drawText: false,
        ),
      ),
    );
  }
}
