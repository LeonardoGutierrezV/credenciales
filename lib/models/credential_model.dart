import 'package:flutter/material.dart';

enum CodeType { qr, code128, ean13 }
enum CredentialOrientation { landscape, portrait }

class CredentialModel extends ChangeNotifier {
  String logoPath = '';
  String photoPath = '';
  String collaboratorName = 'Nombre del Colaborador';
  String companyName = 'Mi Empresa';
  String employeeId = '00123456';
  CodeType codeType = CodeType.code128;
  CredentialOrientation orientation = CredentialOrientation.landscape;
  
  Color backgroundColor = Colors.white;
  Color bandColor = Colors.blue;
  Color textColor = Colors.white;
  bool transparentTextBackground = false;

  // Flexible Layout Parameters (Factors relative to total size)
  double logoHeightFactor = 0.2;
  double photoHeightFactor = 0.4;
  double bandHeightFactor = 0.15;
  double barcodeHeightFactor = 0.1;
  double bandPositionFactor = 0.7; // Y position

  void updateOrientation(CredentialOrientation o) {
    orientation = o;
    notifyListeners();
  }

  void updateLogoHeight(double value) {
    logoHeightFactor = value;
    notifyListeners();
  }

  void updatePhotoHeight(double value) {
    photoHeightFactor = value;
    notifyListeners();
  }

  void updateBandHeight(double value) {
    bandHeightFactor = value;
    notifyListeners();
  }

  void updateBandPosition(double value) {
    bandPositionFactor = value;
    notifyListeners();
  }

  void updateBarcodeHeight(double value) {
    barcodeHeightFactor = value;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'backgroundColor': backgroundColor.value,
      'bandColor': bandColor.value,
      'textColor': textColor.value,
      'transparentTextBackground': transparentTextBackground,
      'logoHeightFactor': logoHeightFactor,
      'photoHeightFactor': photoHeightFactor,
      'bandHeightFactor': bandHeightFactor,
      'barcodeHeightFactor': barcodeHeightFactor,
      'bandPositionFactor': bandPositionFactor,
      'orientation': orientation.index,
    };
  }

  void loadFromTemplate(Map<String, dynamic> json) {
    backgroundColor = Color(json['backgroundColor']);
    bandColor = Color(json['bandColor']);
    textColor = Color(json['textColor']);
    transparentTextBackground = json['transparentTextBackground'];
    logoHeightFactor = json['logoHeightFactor'];
    photoHeightFactor = json['photoHeightFactor'];
    bandHeightFactor = json['bandHeightFactor'];
    barcodeHeightFactor = json['barcodeHeightFactor'];
    bandPositionFactor = json['bandPositionFactor'];
    orientation = CredentialOrientation.values[json['orientation']];
    notifyListeners();
  }

  void updateLogo(String path) {
    logoPath = path;
    notifyListeners();
  }

  void updatePhoto(String path) {
    photoPath = path;
    notifyListeners();
  }

  void updateCollaboratorName(String name) {
    collaboratorName = name;
    notifyListeners();
  }

  void updateCompanyName(String name) {
    companyName = name;
    notifyListeners();
  }

  void updateEmployeeId(String id) {
    employeeId = id;
    notifyListeners();
  }

  void updateCodeType(CodeType type) {
    codeType = type;
    notifyListeners();
  }

  void updateBackgroundColor(Color color) {
    backgroundColor = color;
    notifyListeners();
  }

  void updateBandColor(Color color) {
    bandColor = color;
    notifyListeners();
  }

  void updateTextColor(Color color) {
    textColor = color;
    notifyListeners();
  }

  void toggleTransparentTextBackground(bool? value) {
    transparentTextBackground = value ?? false;
    notifyListeners();
  }

  void reset() {
    logoPath = '';
    photoPath = '';
    collaboratorName = 'Nombre del Colaborador';
    companyName = 'Mi Empresa';
    employeeId = '00123456';
    codeType = CodeType.code128;
    backgroundColor = Colors.white;
    bandColor = Colors.blue;
    textColor = Colors.white;
    transparentTextBackground = false;
    notifyListeners();
  }
}
