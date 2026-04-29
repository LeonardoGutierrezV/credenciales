import 'package:flutter/material.dart';

enum CodeType { qr, code128, ean13 }
enum CredentialOrientation { landscape, portrait }
enum BandImageMode { centered, extended, right, left }
enum FontType { normal, thin, ultraThin, bold }

class CredentialModel extends ChangeNotifier {
  // --- General ---
  CredentialOrientation orientation = CredentialOrientation.portrait;
  Color backgroundColor = Colors.white;

  // --- 1. Logotipo ---
  String logoPath = '';
  double logoPosY = 0.05;
  bool logoCenteredX = true;
  double logoPosX = 0.5;
  double logoSize = 0.15; // Factor of height

  // --- 2. Fotografia ---
  String photoPath = '';
  double photoPosY = 0.25;
  bool photoCenteredX = true;
  double photoPosX = 0.5;
  double photoSize = 0.3; // Factor of height

  // --- 3. Persona ---
  // * Banda
  double bandPosY = 0.65;
  double bandHeight = 0.15;
  Color bandColor = Colors.blue;
  String bandImagePath = '';
  BandImageMode bandImageMode = BandImageMode.extended;
  bool useBandImage = false;

  // * Etiqueta
  String collaboratorName = 'Nombre del Colaborador';
  double labelFontSize = 14;
  FontType labelFontType = FontType.bold;
  bool labelWrapText = true;
  double labelVerticalBorder = 4.0;
  double labelHorizontalBorder = 8.0;
  double labelLineSpacing = 1.0;
  Color labelTextColor = Colors.white;

  // --- 4. Control ---
  String controlData = '00123456';
  CodeType codeType = CodeType.code128;
  double controlPosY = 0.85;
  bool controlCenteredX = true;
  double controlPosX = 0.5;
  double controlSize = 0.1;
  Color controlColor = Colors.black;

  // --- 5. Empresa ---
  String companyName = 'Mi Empresa';
  double companyFontSize = 12;
  FontType companyFontType = FontType.normal;
  double companyHorizontalBorder = 8.0;
  double companyLineSpacing = 1.0;
  Color companyTextColor = Colors.black;

  // --- Update Methods ---

  void updateOrientation(CredentialOrientation o) {
    orientation = o;
    notifyListeners();
  }

  void updateBackgroundColor(Color c) {
    backgroundColor = c;
    notifyListeners();
  }

  // Logo
  void updateLogoPath(String path) { logoPath = path; notifyListeners(); }
  void updateLogoPosY(double val) { logoPosY = val; notifyListeners(); }
  void updateLogoCenteredX(bool val) { logoCenteredX = val; notifyListeners(); }
  void updateLogoPosX(double val) { logoPosX = val; notifyListeners(); }
  void updateLogoSize(double val) { logoSize = val; notifyListeners(); }

  // Photo
  void updatePhotoPath(String path) { photoPath = path; notifyListeners(); }
  void updatePhotoPosY(double val) { photoPosY = val; notifyListeners(); }
  void updatePhotoCenteredX(bool val) { photoCenteredX = val; notifyListeners(); }
  void updatePhotoPosX(double val) { photoPosX = val; notifyListeners(); }
  void updatePhotoSize(double val) { photoSize = val; notifyListeners(); }

  // Band
  void updateBandPosY(double val) { bandPosY = val; notifyListeners(); }
  void updateBandHeight(double val) { bandHeight = val; notifyListeners(); }
  void updateBandColor(Color c) { bandColor = c; notifyListeners(); }
  void updateBandImagePath(String path) { bandImagePath = path; notifyListeners(); }
  void updateBandImageMode(BandImageMode mode) { bandImageMode = mode; notifyListeners(); }
  void updateUseBandImage(bool val) { useBandImage = val; notifyListeners(); }

  // Label
  void updateCollaboratorName(String val) { collaboratorName = val; notifyListeners(); }
  void updateLabelFontSize(double val) { labelFontSize = val; notifyListeners(); }
  void updateLabelFontType(FontType val) { labelFontType = val; notifyListeners(); }
  void updateLabelWrapText(bool val) { labelWrapText = val; notifyListeners(); }
  void updateLabelVerticalBorder(double val) { labelVerticalBorder = val; notifyListeners(); }
  void updateLabelHorizontalBorder(double val) { labelHorizontalBorder = val; notifyListeners(); }
  void updateLabelLineSpacing(double val) { labelLineSpacing = val; notifyListeners(); }
  void updateLabelTextColor(Color c) { labelTextColor = c; notifyListeners(); }

  // Control
  void updateControlData(String val) { controlData = val; notifyListeners(); }
  void updateCodeType(CodeType val) { codeType = val; notifyListeners(); }
  void updateControlPosY(double val) { controlPosY = val; notifyListeners(); }
  void updateControlCenteredX(bool val) { controlCenteredX = val; notifyListeners(); }
  void updateControlPosX(double val) { controlPosX = val; notifyListeners(); }
  void updateControlSize(double val) { controlSize = val; notifyListeners(); }
  void updateControlColor(Color c) { controlColor = c; notifyListeners(); }

  // Company
  void updateCompanyName(String val) { companyName = val; notifyListeners(); }
  void updateCompanyFontSize(double val) { companyFontSize = val; notifyListeners(); }
  void updateCompanyFontType(FontType val) { companyFontType = val; notifyListeners(); }
  void updateCompanyHorizontalBorder(double val) { companyHorizontalBorder = val; notifyListeners(); }
  void updateCompanyLineSpacing(double val) { companyLineSpacing = val; notifyListeners(); }
  void updateCompanyTextColor(Color c) { companyTextColor = c; notifyListeners(); }

  void reset() {
    logoPath = '';
    photoPath = '';
    bandImagePath = '';
    orientation = CredentialOrientation.portrait;
    backgroundColor = Colors.white;
    bandColor = Colors.blue;
    collaboratorName = 'Nombre del Colaborador';
    companyName = 'Mi Empresa';
    controlData = '00123456';
    codeType = CodeType.code128;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'orientation': orientation.index,
      'backgroundColor': backgroundColor.value,
      'logoPath': logoPath,
      'logoPosY': logoPosY,
      'logoCenteredX': logoCenteredX,
      'logoPosX': logoPosX,
      'logoSize': logoSize,
      'photoPath': photoPath,
      'photoPosY': photoPosY,
      'photoCenteredX': photoCenteredX,
      'photoPosX': photoPosX,
      'photoSize': photoSize,
      'bandPosY': bandPosY,
      'bandHeight': bandHeight,
      'bandColor': bandColor.value,
      'bandImagePath': bandImagePath,
      'bandImageMode': bandImageMode.index,
      'useBandImage': useBandImage,
      'collaboratorName': collaboratorName,
      'labelFontSize': labelFontSize,
      'labelFontType': labelFontType.index,
      'labelWrapText': labelWrapText,
      'labelVerticalBorder': labelVerticalBorder,
      'labelHorizontalBorder': labelHorizontalBorder,
      'labelLineSpacing': labelLineSpacing,
      'labelTextColor': labelTextColor.value,
      'controlData': controlData,
      'codeType': codeType.index,
      'controlPosY': controlPosY,
      'controlCenteredX': controlCenteredX,
      'controlPosX': controlPosX,
      'controlSize': controlSize,
      'controlColor': controlColor.value,
      'companyName': companyName,
      'companyFontSize': companyFontSize,
      'companyFontType': companyFontType.index,
      'companyHorizontalBorder': companyHorizontalBorder,
      'companyLineSpacing': companyLineSpacing,
      'companyTextColor': companyTextColor.value,
    };
  }

  void loadFromTemplate(Map<String, dynamic> json) {
    orientation = CredentialOrientation.values[json['orientation'] ?? 1];
    backgroundColor = Color(json['backgroundColor'] ?? Colors.white.value);
    logoPath = json['logoPath'] ?? '';
    logoPosY = (json['logoPosY'] ?? 0.05).toDouble();
    logoCenteredX = json['logoCenteredX'] ?? true;
    logoPosX = (json['logoPosX'] ?? 0.5).toDouble();
    logoSize = (json['logoSize'] ?? 0.15).toDouble();
    photoPath = json['photoPath'] ?? '';
    photoPosY = (json['photoPosY'] ?? 0.25).toDouble();
    photoCenteredX = json['photoCenteredX'] ?? true;
    photoPosX = (json['photoPosX'] ?? 0.5).toDouble();
    photoSize = (json['photoSize'] ?? 0.3).toDouble();
    bandPosY = (json['bandPosY'] ?? 0.65).toDouble();
    bandHeight = (json['bandHeight'] ?? 0.15).toDouble();
    bandColor = Color(json['bandColor'] ?? Colors.blue.value);
    bandImagePath = json['bandImagePath'] ?? '';
    bandImageMode = BandImageMode.values[json['bandImageMode'] ?? 1];
    useBandImage = json['useBandImage'] ?? false;
    collaboratorName = json['collaboratorName'] ?? 'Nombre del Colaborador';
    labelFontSize = (json['labelFontSize'] ?? 14).toDouble();
    labelFontType = FontType.values[json['labelFontType'] ?? 3];
    labelWrapText = json['labelWrapText'] ?? true;
    labelVerticalBorder = (json['labelVerticalBorder'] ?? 4.0).toDouble();
    labelHorizontalBorder = (json['labelHorizontalBorder'] ?? 8.0).toDouble();
    labelLineSpacing = (json['labelLineSpacing'] ?? 1.0).toDouble();
    labelTextColor = Color(json['labelTextColor'] ?? Colors.white.value);
    controlData = json['controlData'] ?? '00123456';
    codeType = CodeType.values[json['codeType'] ?? 1];
    controlPosY = (json['controlPosY'] ?? 0.85).toDouble();
    controlCenteredX = json['controlCenteredX'] ?? true;
    controlPosX = (json['controlPosX'] ?? 0.5).toDouble();
    controlSize = (json['controlSize'] ?? 0.1).toDouble();
    controlColor = Color(json['controlColor'] ?? Colors.black.value);
    companyName = json['companyName'] ?? 'Mi Empresa';
    companyFontSize = (json['companyFontSize'] ?? 12).toDouble();
    companyFontType = FontType.values[json['companyFontType'] ?? 0];
    companyHorizontalBorder = (json['companyHorizontalBorder'] ?? 8.0).toDouble();
    companyLineSpacing = (json['companyLineSpacing'] ?? 1.0).toDouble();
    companyTextColor = Color(json['companyTextColor'] ?? Colors.black.value);
    notifyListeners();
  }
}
