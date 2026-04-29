import 'package:flutter_test/flutter_test.dart';
import 'package:credenciales/services/credential_utils.dart';
import 'package:credenciales/models/credential_model.dart';

void main() {
  group('Credential Logic Tests (Orientation & Sizing)', () {
    test('Aspect Ratio changes with orientation', () {
      final landscapeRatio = CredentialUtils.aspectRatio(CredentialOrientation.landscape);
      final portraitRatio = CredentialUtils.aspectRatio(CredentialOrientation.portrait);
      
      expect(landscapeRatio, closeTo(1.586, 0.001));
      expect(portraitRatio, closeTo(0.630, 0.001));
      expect(landscapeRatio, 1 / portraitRatio);
    });

    test('Pixel dimensions match orientation', () {
      final lw = CredentialUtils.widthPx(CredentialOrientation.landscape);
      final lh = CredentialUtils.heightPx(CredentialOrientation.landscape);
      final pw = CredentialUtils.widthPx(CredentialOrientation.portrait);
      final ph = CredentialUtils.heightPx(CredentialOrientation.portrait);

      expect(lw, ph);
      expect(lh, pw);
      expect(lw > lh, true);
      expect(ph > pw, true);
    });
  });
}
