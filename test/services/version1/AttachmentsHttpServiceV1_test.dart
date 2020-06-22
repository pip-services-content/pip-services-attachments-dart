import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_attachments/pip_services_attachments.dart';

var httpConfig = ConfigParams.fromTuples([
  'connection.protocol',
  'http',
  'connection.host',
  'localhost',
  'connection.port',
  3000
]);

void main() {
  group('AttachmentsHttpServiceV1', () {
    AttachmentsMemoryPersistence persistence;
    AttachmentsController controller;
    AttachmentsHttpServiceV1 service;
    http.Client rest;
    String url;

    setUp(() async {
      url = 'http://localhost:3000';
      rest = http.Client();

      persistence = AttachmentsMemoryPersistence();
      persistence.configure(ConfigParams());

      controller = AttachmentsController();
      controller.configure(ConfigParams());

      service = AttachmentsHttpServiceV1();
      service.configure(httpConfig);

      var references = References.fromTuples([
        Descriptor('pip-services-attachments', 'persistence', 'memory',
            'default', '1.0'),
        persistence,
        Descriptor('pip-services-attachments', 'controller', 'default',
            'default', '1.0'),
        controller,
        Descriptor(
            'pip-services-attachments', 'service', 'http', 'default', '1.0'),
        service
      ]);

      controller.setReferences(references);
      service.setReferences(references);

      await persistence.open(null);
      await service.open(null);
    });

    tearDown(() async {
      await service.close(null);
      await persistence.close(null);
    });

    test('CRUD Operations', () async {
      // Add attachment
      var resp = await rest.post(url + '/v1/attachments/add_attachments',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'reference': ReferenceV1(
                id: '000000000000000000000011', type: 'goal', name: 'Goal 1'),
            'ids': ['1', '2']
          }));
      expect(resp.body, isNotNull);

      // Add attachment
      resp = await rest.post(url + '/v1/attachments/add_attachments',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'reference': ReferenceV1(
                id: '000000000000000000000012', type: 'goal', name: 'Goal 2'),
            'ids': ['2', '3']
          }));
      expect(resp.body, isNotNull);

      // Check attachments has references
      resp = await rest.post(url + '/v1/attachments/get_attachment_by_id',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'id': '2'}));
      var attachment = BlobAttachmentV1();
      attachment.fromJson(json.decode(resp.body));

      expect(attachment, isNotNull);
      expect(attachment.references.length, 2);

      // Remove reference
      resp = await rest.post(url + '/v1/attachments/update_attachments',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'reference': ReferenceV1(
                id: '000000000000000000000011', type: 'goal', name: null),
            'old_ids': ['1', '2'],
            'new_ids': ['1']
          }));
      expect(resp.body, isNotNull);

      // Remove another reference
      resp = await rest.post(url + '/v1/attachments/remove_attachments',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'reference': ReferenceV1(
                id: '000000000000000000000012', type: 'goal', name: 'Goal 2'),
            'ids': ['1']
          }));
      expect(resp.body, isNotNull);

      // Remove attachments
      resp = await rest.post(url + '/v1/attachments/delete_attachment_by_id',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'id': '1'}));
      attachment = BlobAttachmentV1();
      attachment.fromJson(json.decode(resp.body));

      expect(attachment, isNotNull);

      // Get another attachment
      resp = await rest.post(url + '/v1/attachments/get_attachment_by_id',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'id': '2'}));
      attachment = BlobAttachmentV1();
      attachment.fromJson(json.decode(resp.body));

      expect(attachment, isNotNull);
      expect(attachment.references.length, 1);
      var reference = attachment.references[0];
      expect(reference.id, '000000000000000000000012');
    });
  });
}
