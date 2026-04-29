import 'package:flutter_test/flutter_test.dart';
import 'package:credenciales/services/credential_utils.dart';
import 'package:credenciales/models/credential_model.dart';

void main() {
  group('CredentialUtils Logic Tests', () {
    test('MM to Pixels conversion at 300 DPI', () {
      // (25.4 mm / 25.4) * 300 = 300
      expect(CredentialUtils.mmToPixel(25.4), 300.0);
      
      // CR-80 Width: 85.6 mm -> (85.6 / 25.4) * 300 = 1011.02...
      expect(CredentialUtils.mmToPixel(85.6), closeTo(1011.02, 0.01));
    });

    test('Aspect Ratio calculation', () {
      // Landscape: 85.6 / 53.98 = 1.585...
      expect(CredentialUtils.aspectRatio(CredentialOrientation.landscape), closeTo(1.585, 0.001));
      
      // Portrait: 53.98 / 85.6 = 0.630...
      expect(CredentialUtils.aspectRatio(CredentialOrientation.portrait), closeTo(0.630, 0.001));
    });

    test('CR-80 Dimensions in Pixels', () {
       expect(CredentialUtils.cr80WidthPx, closeTo(1011.02, 0.01));
       expect(CredentialUtils.cr80HeightPx, closeTo(637.55, 0.01));
    });
  });
}
