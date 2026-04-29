import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:credenciales/models/credential_model.dart';

class CredentialPainter extends CustomPainter {
  final CredentialModel model;
  final ui.Image? logoImage;
  final ui.Image? photoImage;
  final ui.Image? bandImage;

  CredentialPainter({
    required this.model,
    this.logoImage,
    this.photoImage,
    this.bandImage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 0. Background
    final paintBg = Paint()..color = model.backgroundColor;
    canvas.drawRect(Offset.zero & size, paintBg);

    // 1. Logotipo
    if (logoImage != null) {
      double logoH = size.height * model.logoSize;
      double logoW = logoH * (logoImage!.width / logoImage!.height);
      double x = model.logoCenteredX ? (size.width - logoW) / 2 : size.width * model.logoPosX;
      double y = size.height * model.logoPosY;
      canvas.drawImageRect(
        logoImage!,
        Rect.fromLTWH(0, 0, logoImage!.width.toDouble(), logoImage!.height.toDouble()),
        Rect.fromLTWH(x, y, logoW, logoH),
        Paint(),
      );
    }

    // 2. Fotografía
    if (photoImage != null) {
      double photoH = size.height * model.photoSize;
      double photoW = photoH * (photoImage!.width / photoImage!.height);
      double x = model.photoCenteredX ? (size.width - photoW) / 2 : size.width * model.photoPosX;
      double y = size.height * model.photoPosY;
      canvas.drawImageRect(
        photoImage!,
        Rect.fromLTWH(0, 0, photoImage!.width.toDouble(), photoImage!.height.toDouble()),
        Rect.fromLTWH(x, y, photoW, photoH),
        Paint(),
      );
    }

    // 3. Banda
    double bandY = size.height * model.bandPosY;
    double bandH = size.height * model.bandHeight;
    Rect bandRect = Rect.fromLTWH(0, bandY, size.width, bandH);
    
    // Band Background Color
    canvas.drawRect(bandRect, Paint()..color = model.bandColor);

    // Band Background Image
    if (model.useBandImage && bandImage != null) {
      _paintBandImage(canvas, bandRect, bandImage!, model.bandImageMode);
    }

    // 3.1 Etiqueta (Nombre Colaborador)
    _paintLabel(canvas, bandRect, model);

    // 5. Empresa
    _paintCompany(canvas, size, model);
  }

  void _paintBandImage(Canvas canvas, Rect rect, ui.Image image, BandImageMode mode) {
    double imgW = image.width.toDouble();
    double imgH = image.height.toDouble();
    Rect src;
    Rect dst;

    switch (mode) {
      case BandImageMode.extended:
        src = Rect.fromLTWH(0, 0, imgW, imgH);
        dst = rect;
        break;
      case BandImageMode.centered:
        double aspect = imgW / imgH;
        double drawH = rect.height;
        double drawW = drawH * aspect;
        src = Rect.fromLTWH(0, 0, imgW, imgH);
        dst = Rect.fromLTWH(rect.left + (rect.width - drawW) / 2, rect.top, drawW, drawH);
        break;
      case BandImageMode.right:
        double aspect = imgW / imgH;
        double drawH = rect.height;
        double drawW = drawH * aspect;
        src = Rect.fromLTWH(0, 0, imgW, imgH);
        dst = Rect.fromLTWH(rect.right - drawW, rect.top, drawW, drawH);
        break;
      case BandImageMode.left:
        double aspect = imgW / imgH;
        double drawH = rect.height;
        double drawW = drawH * aspect;
        src = Rect.fromLTWH(0, 0, imgW, imgH);
        dst = Rect.fromLTWH(rect.left, rect.top, drawW, drawH);
        break;
    }
    
    // Clip to band rect
    canvas.save();
    canvas.clipRect(rect);
    canvas.drawImageRect(image, src, dst, Paint());
    canvas.restore();
  }

  void _paintLabel(Canvas canvas, Rect bandRect, CredentialModel model) {
    final textStyle = TextStyle(
      color: model.labelTextColor,
      fontSize: model.labelFontSize,
      fontWeight: _getFontWeight(model.labelFontType),
      fontFamily: 'Arial',
      height: model.labelLineSpacing,
    );

    final fullText = '${model.collaboratorName}\nN.Empleado: ${model.controlData}';

    final textPainter = TextPainter(
      text: TextSpan(text: fullText, style: textStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    double maxWidth = bandRect.width - (model.labelHorizontalBorder * 2);
    textPainter.layout(maxWidth: model.labelWrapText ? maxWidth : double.infinity);

    double x = bandRect.left + (bandRect.width - textPainter.width) / 2;
    double y = bandRect.top + model.labelVerticalBorder;

    // Ensure it doesn't go out of band if possible, but follow borders
    canvas.save();
    canvas.clipRect(bandRect);
    textPainter.paint(canvas, Offset(x, y));
    canvas.restore();
  }

  void _paintCompany(Canvas canvas, Size size, CredentialModel model) {
    final textStyle = TextStyle(
      color: model.companyTextColor,
      fontSize: model.companyFontSize,
      fontWeight: _getFontWeight(model.companyFontType),
      fontFamily: 'Arial',
      height: model.companyLineSpacing,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: model.companyName, style: textStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    double maxWidth = size.width - (model.companyHorizontalBorder * 2);
    textPainter.layout(maxWidth: maxWidth);

    double x = (size.width - textPainter.width) / 2;
    double y = size.height * 0.94; // Default bottom position

    textPainter.paint(canvas, Offset(x, y));
  }

  FontWeight _getFontWeight(FontType type) {
    switch (type) {
      case FontType.thin: return FontWeight.w200;
      case FontType.ultraThin: return FontWeight.w100;
      case FontType.bold: return FontWeight.bold;
      case FontType.normal:
      default: return FontWeight.normal;
    }
  }

  @override
  bool shouldRepaint(covariant CredentialPainter oldDelegate) {
    return oldDelegate.model != model || 
           oldDelegate.logoImage != logoImage || 
           oldDelegate.photoImage != photoImage ||
           oldDelegate.bandImage != bandImage;
  }
}
