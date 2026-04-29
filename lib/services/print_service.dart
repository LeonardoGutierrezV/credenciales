import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:credenciales/models/credential_model.dart';
import 'package:credenciales/services/credential_utils.dart';
import 'package:barcode/barcode.dart' as bc;

class PrintService {
  static Future<void> exportPdf(CredentialModel model) async {
    final pdf = await generatePdf(model);
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'credencial_${model.controlData}.pdf');
  }

  static Future<void> printCredential(CredentialModel model) async {
    final pdf = await generatePdf(model);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Credencial ${model.collaboratorName}',
      format: PdfPageFormat(
        CredentialUtils.widthPx(model.orientation) * (PdfPageFormat.inch / CredentialUtils.dpi),
        CredentialUtils.heightPx(model.orientation) * (PdfPageFormat.inch / CredentialUtils.dpi),
      ),
    );
  }

  static Future<pw.Document> generatePdf(CredentialModel model) async {
    final pdf = pw.Document();

    final logoImage = model.logoPath.isNotEmpty && File(model.logoPath).existsSync()
        ? pw.MemoryImage(File(model.logoPath).readAsBytesSync()) 
        : null;
    
    final photoImage = model.photoPath.isNotEmpty && File(model.photoPath).existsSync()
        ? pw.MemoryImage(File(model.photoPath).readAsBytesSync()) 
        : null;

    final bandImage = model.useBandImage && model.bandImagePath.isNotEmpty && File(model.bandImagePath).existsSync()
        ? pw.MemoryImage(File(model.bandImagePath).readAsBytesSync())
        : null;

    bc.Barcode barcode;
    switch (model.codeType) {
      case CodeType.qr: barcode = bc.Barcode.qrCode(); break;
      case CodeType.ean13: barcode = bc.Barcode.ean13(); break;
      case CodeType.code128:
      default: barcode = bc.Barcode.code128(); break;
    }

    final width = CredentialUtils.widthPx(model.orientation) * (PdfPageFormat.inch / CredentialUtils.dpi);
    final height = CredentialUtils.heightPx(model.orientation) * (PdfPageFormat.inch / CredentialUtils.dpi);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(width, height, marginAll: 0),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // 0. Background
              pw.FullPage(
                ignoreMargins: true,
                child: pw.Container(color: PdfColor.fromInt(model.backgroundColor.value)),
              ),
              
              // 1. Logotipo
              if (logoImage != null)
                pw.Positioned(
                  top: height * model.logoPosY,
                  left: model.logoCenteredX ? 0 : width * model.logoPosX,
                  right: model.logoCenteredX ? 0 : null,
                  child: pw.Container(
                    alignment: model.logoCenteredX ? pw.Alignment.topCenter : pw.Alignment.topLeft,
                    child: pw.Image(logoImage, height: height * model.logoSize),
                  ),
                ),

              // 2. Fotografía
              if (photoImage != null)
                pw.Positioned(
                  top: height * model.photoPosY,
                  left: model.photoCenteredX ? 0 : width * model.photoPosX,
                  right: model.photoCenteredX ? 0 : null,
                  child: pw.Container(
                    alignment: model.photoCenteredX ? pw.Alignment.topCenter : pw.Alignment.topLeft,
                    child: pw.Image(photoImage, height: height * model.photoSize),
                  ),
                ),

              // 3. Banda
              pw.Positioned(
                top: height * model.bandPosY,
                left: 0,
                right: 0,
                child: pw.Container(
                  height: height * model.bandHeight,
                  color: PdfColor.fromInt(model.bandColor.value),
                  child: pw.Stack(
                    children: [
                      if (bandImage != null)
                        pw.Positioned.fill(
                          child: _buildBandImagePdf(bandImage, model.bandImageMode),
                        ),
                      pw.Padding(
                        padding: pw.EdgeInsets.symmetric(
                          vertical: model.labelVerticalBorder * (height / CredentialUtils.heightPx(model.orientation)),
                          horizontal: model.labelHorizontalBorder * (width / CredentialUtils.widthPx(model.orientation)),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            model.collaboratorName,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(model.labelTextColor.value),
                              fontSize: model.labelFontSize * (height / CredentialUtils.heightPx(model.orientation)) * 1.5, // Scaling adjustment
                              fontWeight: _getPdfFontWeight(model.labelFontType),
                              lineSpacing: model.labelLineSpacing,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Control
              pw.Positioned(
                top: height * model.controlPosY,
                left: model.controlCenteredX ? 0 : width * model.controlPosX,
                right: model.controlCenteredX ? 0 : null,
                child: pw.Container(
                  alignment: model.controlCenteredX ? pw.Alignment.topCenter : pw.Alignment.topLeft,
                  child: pw.SizedBox(
                    height: height * model.controlSize,
                    width: model.codeType == CodeType.qr ? height * model.controlSize : (height * model.controlSize) * 2,
                    child: pw.BarcodeWidget(
                      barcode: barcode,
                      data: model.controlData,
                      color: PdfColor.fromInt(model.controlColor.value),
                      drawText: false,
                    ),
                  ),
                ),
              ),

              // 5. Empresa
              pw.Positioned(
                bottom: height * 0.04,
                left: model.companyHorizontalBorder * (width / CredentialUtils.widthPx(model.orientation)),
                right: model.companyHorizontalBorder * (width / CredentialUtils.widthPx(model.orientation)),
                child: pw.Center(
                  child: pw.Text(
                    model.companyName,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColor.fromInt(model.companyTextColor.value),
                      fontSize: model.companyFontSize * (height / CredentialUtils.heightPx(model.orientation)) * 1.5,
                      fontWeight: _getPdfFontWeight(model.companyFontType),
                      lineSpacing: model.companyLineSpacing,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _buildBandImagePdf(pw.MemoryImage image, BandImageMode mode) {
    pw.Alignment alignment;
    pw.BoxFit fit;

    switch (mode) {
      case BandImageMode.extended:
        alignment = pw.Alignment.center;
        fit = pw.BoxFit.fill;
        break;
      case BandImageMode.centered:
        alignment = pw.Alignment.center;
        fit = pw.BoxFit.contain;
        break;
      case BandImageMode.right:
        alignment = pw.Alignment.centerRight;
        fit = pw.BoxFit.contain;
        break;
      case BandImageMode.left:
        alignment = pw.Alignment.centerLeft;
        fit = pw.BoxFit.contain;
        break;
    }

    return pw.Image(image, alignment: alignment, fit: fit);
  }

  static pw.FontWeight _getPdfFontWeight(FontType type) {
    if (type == FontType.bold) return pw.FontWeight.bold;
    return pw.FontWeight.normal;
  }
}
