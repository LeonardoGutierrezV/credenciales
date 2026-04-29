import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:credenciales/models/credential_model.dart';

void main() {
  group('CredentialModel Tests', () {
    test('Default values are correct', () {
      final model = CredentialModel();
      expect(model.collaboratorName, 'Nombre del Colaborador');
      expect(model.backgroundColor, Colors.white);
      expect(model.codeType, CodeType.code128);
    });

    test('Update methods notify listeners', () {
      final model = CredentialModel();
      int callCount = 0;
      model.addListener(() {
        callCount++;
      });

      model.updateCollaboratorName('John Doe');
      expect(model.collaboratorName, 'John Doe');
      expect(callCount, 1);

      model.updateBackgroundColor(Colors.red);
      expect(model.backgroundColor, Colors.red);
      expect(callCount, 2);
    });

    test('Reset works correctly', () {
      final model = CredentialModel();
      model.updateCollaboratorName('Changed');
      model.updateBackgroundColor(Colors.black);
      
      model.reset();
      
      expect(model.collaboratorName, 'Nombre del Colaborador');
      expect(model.backgroundColor, Colors.white);
    });
  });
}
