import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_attachments/pip_services_attachments.dart';

void main() {
  group('AttachmentsController', () {
    AttachmentsMemoryPersistence persistence;
    AttachmentsController controller;

    setUp(() async {
      persistence = AttachmentsMemoryPersistence();
      persistence.configure(ConfigParams());

      controller = AttachmentsController();
      controller.configure(ConfigParams());

      var logger = ConsoleLogger();

      var references = References.fromTuples([
        Descriptor('pip-services', 'logger', 'console', 'default', '1.0'),
        logger,
        Descriptor('pip-services-attachments', 'persistence', 'memory',
            'default', '1.0'),
        persistence,
        Descriptor('pip-services-attachments', 'controller', 'default',
            'default', '1.0'),
        controller
      ]);

      controller.setReferences(references);

      await persistence.open(null);
    });

    tearDown(() async {
      await persistence.close(null);
    });

    test('CRUD Operations', () async {
      // Add attachments
      var attachments = await controller.addAttachments(
          null,
          ReferenceV1(
              id: '000000000000000000000011', type: 'goal', name: 'Goal 1'),
          ['1', '2']);

      expect(attachments, isNotNull);

      // Add other attachments
      attachments = await controller.addAttachments(
          null,
          ReferenceV1(
              id: '000000000000000000000012', type: 'goal', name: 'Goal 2'),
          ['2', '3']);

      expect(attachments, isNotNull);

      // Check attachments has references
      var item = await controller.getAttachmentById(null, '2');
      expect(item, isNotNull);
      expect(item.references.length, 2);

      // Remove reference
      attachments = await controller.updateAttachments(
          null,
          ReferenceV1(id: '000000000000000000000011', type: 'goal', name: null),
          ['1', '2'],
          ['1']);

      expect(attachments, isNotNull);

      // Remove another reference
      attachments = await controller.removeAttachments(
          null,
          ReferenceV1(id: '000000000000000000000011', type: 'goal', name: null),
          ['1']);

      expect(attachments, isNotNull);

      // Remove attachments
      item = await controller.deleteAttachmentById(null, '1');

      expect(item, isNull);

      // Get another attachments
      item = await controller.getAttachmentById(null, '2');
      expect(item, isNotNull);
      expect(item.references.length, 1);

      var reference = item.references[0];
      expect(reference.id, '000000000000000000000012');
    });
  });
}
