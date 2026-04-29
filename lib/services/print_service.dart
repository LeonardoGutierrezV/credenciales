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
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'credencial_${model.employeeId}.pdf');
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

    final logoImage = model.logoPath.isNotEmpty 
        ? pw.MemoryImage(File(model.logoPath).readAsBytesSync()) 
        : null;
    
    final photoImage = model.photoPath.isNotEmpty 
        ? pw.MemoryImage(File(model.photoPath).readAsBytesSync()) 
        : null;

    bc.Barcode barcode;
    switch (model.codeType) {
      case CodeType.qr:
        barcode = bc.Barcode.qrCode();
        break;
      case CodeType.ean13:
        barcode = bc.Barcode.ean13();
        break;
      case CodeType.code128:
      default:
        barcode = bc.Barcode.code128();
        break;
    }

    final width = CredentialUtils.widthPx(model.orientation) * (PdfPageFormat.inch / CredentialUtils.dpi);
    final height = CredentialUtils.heightPx(model.orientation) * (PdfPageFormat.inch / CredentialUtils.dpi);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(width, height, marginAll: 0),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.FullPage(
                ignoreMargins: true,
                child: pw.Container(
                  color: PdfColor.fromInt(model.backgroundColor.value),
                ),
              ),
              
              if (logoImage != null)
                pw.Positioned(
                  top: height * 0.02,
                  left: 0,
                  right: 0,
                  child: pw.Center(
                    child: pw.Image(logoImage, height: height * model.logoHeightFactor),
                  ),
                ),

              if (photoImage != null)
                pw.Positioned(
                  top: height * 0.4 - (height * model.photoHeightFactor / 2),
                  left: 0,
                  right: 0,
                  child: pw.Center(
                    child: pw.Image(photoImage, height: height * model.photoHeightFactor),
                  ),
                ),

              pw.Positioned(
                top: height * model.bandPositionFactor,
                left: 0,
                right: 0,
                child: pw.Container(
                  height: height * model.bandHeightFactor,
                  color: PdfColor.fromInt(model.bandColor.value),
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    model.collaboratorName,
                    style: pw.TextStyle(
                      color: PdfColor.fromInt(model.textColor.value),
                      fontSize: (height * model.bandHeightFactor) * 0.5,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),

              pw.Positioned(
                bottom: height * 0.08,
                left: 20,
                right: 20,
                child: pw.Container(
                  height: height * model.barcodeHeightFactor,
                  child: pw.Center(
                    child: pw.BarcodeWidget(
                      barcode: barcode,
                      data: model.employeeId,
                      drawText: false,
                    ),
                  ),
                ),
              ),

              pw.Positioned(
                bottom: height * 0.02,
                left: 0,
                right: 0,
                child: pw.Center(
                  child: pw.Text(
                    model.companyName,
                    style: pw.TextStyle(fontSize: height * 0.04),
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
}
