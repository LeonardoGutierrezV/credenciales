import 'package:credenciales/models/credential_model.dart';

class CredentialUtils {
  static const double dpi = 300.0;
  static const double mmPerInch = 25.4;

  static double mmToPixel(double mm) {
    return (mm / mmPerInch) * dpi;
  }

  // CR-80 Standard Dimensions in mm
  static const double cr80WidthMm = 85.6;
  static const double cr80HeightMm = 53.98;

  // CR-80 Standard Dimensions in Pixels at 300 DPI
  static double get cr80WidthPx => mmToPixel(cr80WidthMm);
  static double get cr80HeightPx => mmToPixel(cr80HeightMm);

  // Aspect ratio for preview (Width / Height)
  static double aspectRatio(CredentialOrientation orientation) {
    if (orientation == CredentialOrientation.landscape) {
      return cr80WidthMm / cr80HeightMm;
    } else {
      return cr80HeightMm / cr80WidthMm;
    }
  }

  static double widthPx(CredentialOrientation orientation) {
    return orientation == CredentialOrientation.landscape ? cr80WidthPx : cr80HeightPx;
  }

  static double heightPx(CredentialOrientation orientation) {
    return orientation == CredentialOrientation.landscape ? cr80HeightPx : cr80WidthPx;
  }
}
