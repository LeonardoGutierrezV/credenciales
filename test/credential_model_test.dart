import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:credenciales/models/credential_model.dart';

void main() {
  group('CredentialModel Serialization Tests', () {
    test('toJson and loadFromTemplate should preserve all data', () {
      final model = CredentialModel();
      model.updateCollaboratorName('Test User');
      model.updateLogoPosY(0.123);
      model.updateBandColor(Colors.red);
      model.updateOrientation(CredentialOrientation.landscape);
      model.updateLogoCenteredX(false);
      model.updateLogoPosX(0.456);

      final json = model.toJson();
      
      final newModel = CredentialModel();
      newModel.loadFromTemplate(json);

      expect(newModel.collaboratorName, 'Test User');
      expect(newModel.logoPosY, 0.123);
      expect(newModel.bandColor.value, Colors.red.value);
      expect(newModel.orientation, CredentialOrientation.landscape);
      expect(newModel.logoCenteredX, false);
      expect(newModel.logoPosX, 0.456);
    });

    test('reset should restore default values', () {
      final model = CredentialModel();
      model.updateCollaboratorName('Modified');
      model.reset();
      expect(model.collaboratorName, 'Nombre del Colaborador');
      expect(model.orientation, CredentialOrientation.portrait);
    });
  });
}
