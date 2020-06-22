import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import 'package:pip_services_attachments/pip_services_attachments.dart';
import './AttachmentsPersistenceFixture.dart';

void main() {
  group('AttachmentsFilePersistence', () {
    AttachmentsFilePersistence persistence;
    AttachmentsPersistenceFixture fixture;

    setUp(() async {
      persistence = AttachmentsFilePersistence('data/attachments.test.json');
      persistence.configure(ConfigParams());

      fixture = AttachmentsPersistenceFixture(persistence);

      await persistence.open(null);
      await persistence.clear(null);
    });

    tearDown(() async {
      await persistence.close(null);
    });

    test('CRUD Operations', () async {
      await fixture.testCrudOperations();
    });
  });
}
