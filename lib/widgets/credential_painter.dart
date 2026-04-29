import 'dart:io';
import 'package:flutter/material.dart';
import 'package:credenciales/models/credential_model.dart';
import 'package:credenciales/services/credential_utils.dart';
import 'dart:ui' as ui;

class CredentialPainter extends CustomPainter {
  final CredentialModel model;
  final ui.Image? logoImage;
  final ui.Image? photoImage;

  CredentialPainter({
    required this.model,
    this.logoImage,
    this.photoImage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final paintBg = Paint()..color = model.backgroundColor;
    canvas.drawRect(Offset.zero & size, paintBg);

    // 1. Logotipo (Top centered)
    if (logoImage != null) {
      double logoHeight = size.height * model.logoHeightFactor;
      double logoWidth = logoHeight * (logoImage!.width / logoImage!.height);
      canvas.drawImageRect(
        logoImage!,
        Rect.fromLTWH(0, 0, logoImage!.width.toDouble(), logoImage!.height.toDouble()),
        Rect.fromLTWH((size.width - logoWidth) / 2, size.height * 0.02, logoWidth, logoHeight),
        Paint(),
      );
    }

    // 2. Fotografía (Center)
    if (photoImage != null) {
      double photoHeight = size.height * model.photoHeightFactor;
      double photoWidth = photoHeight * (photoImage!.width / photoImage!.height);
      // Center it between Logo area and Band area approximately
      double photoY = (size.height * 0.4) - (photoHeight / 2); 
      if (model.orientation == CredentialOrientation.portrait) {
         photoY = (size.height * 0.45) - (photoHeight / 2);
      }
      
      canvas.drawImageRect(
        photoImage!,
        Rect.fromLTWH(0, 0, photoImage!.width.toDouble(), photoImage!.height.toDouble()),
        Rect.fromLTWH((size.width - photoWidth) / 2, photoY, photoWidth, photoHeight),
        Paint(),
      );
    }

    // 3. Banda de Identidad
    final bandHeight = size.height * model.bandHeightFactor;
    final bandY = size.height * model.bandPositionFactor;
    final paintBand = Paint()..color = model.bandColor;
    canvas.drawRect(Rect.fromLTWH(0, bandY, size.width, bandHeight), paintBand);

    // 4. Nombre (Centered on band)
    final textStyle = TextStyle(
      color: model.textColor,
      fontSize: bandHeight * 0.5,
      fontWeight: FontWeight.bold,
      backgroundColor: model.transparentTextBackground ? null : Colors.black.withOpacity(0.3),
    );
    final textPainter = TextPainter(
      text: TextSpan(text: model.collaboratorName, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, bandY + (bandHeight - textPainter.height) / 2),
    );

    // 6. Footer (Company name)
    final footerStyle = TextStyle(
      color: Colors.black,
      fontSize: size.height * 0.04,
    );
    final footerPainter = TextPainter(
      text: TextSpan(text: model.companyName, style: footerStyle),
      textDirection: TextDirection.ltr,
    );
    footerPainter.layout();
    footerPainter.paint(
      canvas,
      Offset((size.width - footerPainter.width) / 2, size.height * 0.94),
    );
  }

  @override
  bool shouldRepaint(covariant CredentialPainter oldDelegate) {
    return oldDelegate.model != model || 
           oldDelegate.logoImage != logoImage || 
           oldDelegate.photoImage != photoImage;
  }
}
