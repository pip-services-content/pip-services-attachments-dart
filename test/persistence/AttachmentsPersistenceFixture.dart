import 'package:test/test.dart';
import 'package:pip_services_attachments/pip_services_attachments.dart';

class AttachmentsPersistenceFixture {
  IAttachmentsPersistence _persistence;

  AttachmentsPersistenceFixture(IAttachmentsPersistence persistence) {
    expect(persistence, isNotNull);
    _persistence = persistence;
  }

  void testCrudOperations() async {
    // Add reference
    var attachment = await _persistence.addReference(
        null,
        '1',
        ReferenceV1(
            id: '000000000000000000000011', type: 'goal', name: 'Goal 1'));

    expect(attachment, isNotNull);
    expect(attachment.references.length, 1);

    // Add another reference
    attachment = await _persistence.addReference(
        null,
        '1',
        ReferenceV1(
            id: '000000000000000000000012', type: 'goal', name: 'Goal 2'));

    expect(attachment, isNotNull);
    expect(attachment.references.length, 2);

    // Add reference again
    attachment = await _persistence.addReference(
        null,
        '1',
        ReferenceV1(
            id: '000000000000000000000012', type: 'goal', name: 'Goal 2'));

    expect(attachment, isNotNull);
    expect(attachment.references.length, 2);

    // Check attachments has references
    attachment = await _persistence.getOneById(null, '1');

    expect(attachment, isNotNull);
    expect(attachment.references.length, 2);

    // Remove reference
    attachment = await _persistence.removeReference(null, '1',
        ReferenceV1(id: '000000000000000000000011', type: 'goal', name: null));

    expect(attachment, isNotNull);
    expect(attachment.references.length, 1);

    // Remove another reference
    attachment = await _persistence.removeReference(null, '1',
        ReferenceV1(id: '000000000000000000000012', type: 'goal', name: null));

    expect(attachment, isNotNull);
    expect(attachment.references.length, 0);

    // Remove attachments
    attachment = await _persistence.deleteById(null, '1');

    expect(attachment, isNotNull);
    expect(attachment.references.length, 0);

    // Try to get deleted attachments
    attachment = await _persistence.getOneById(null, '1');

    expect(attachment, isNull);
  }
}
