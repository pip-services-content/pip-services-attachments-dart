import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import 'package:pip_services_attachments/pip_services_attachments.dart';
import './AttachmentsPersistenceFixture.dart';

void main() {
  group('AttachmentsMemoryPersistence', () {
    AttachmentsMemoryPersistence persistence;
    AttachmentsPersistenceFixture fixture;

    setUp(() async {
      persistence = AttachmentsMemoryPersistence();
      persistence.configure(ConfigParams());

      fixture = AttachmentsPersistenceFixture(persistence);

      await persistence.open(null);
    });

    tearDown(() async {
      await persistence.close(null);
    });

    test('CRUD Operations', () async {
      await fixture.testCrudOperations();
    });
  });
}
