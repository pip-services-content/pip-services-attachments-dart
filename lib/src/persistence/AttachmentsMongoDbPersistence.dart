import 'dart:async';
import 'package:pip_services3_mongodb/pip_services3_mongodb.dart';
import 'package:pip_services_attachments/src/data/version1/ReferenceV1.dart';

import '../data/version1/BlobAttachmentV1.dart';
import './IAttachmentsPersistence.dart';

class AttachmentsMongoDbPersistence
    extends IdentifiableMongoDbPersistence<BlobAttachmentV1, String>
    implements IAttachmentsPersistence {
  AttachmentsMongoDbPersistence() : super('attachments') {
    maxPageSize = 1000;
  }

  @override
  Future<BlobAttachmentV1> addReference(
      String correlationId, String id, ReferenceV1 reference) async {
    var filter = {'_id': id};

    var data = {
      r'$addToSet': {
        'references': {
          'id': reference.id,
          'type': reference.type,
          'name': reference.name
        }
      }
    };

    var result = await collection.findAndModify(
        query: filter, update: data, returnNew: true, upsert: true);
    var newItem = result != null ? convertToPublic(result) : null;
    if (newItem != null) {
      logger.trace(correlationId, 'Added reference in %s to id = %s',
          [collectionName, id]);
    }

    return newItem;
  }

  @override
  Future<BlobAttachmentV1> removeReference(
      String correlationId, String id, ReferenceV1 reference) async {
    var filter = {'_id': id};

    var data = {
      r'$pull': {
        'references': {'id': reference.id, 'type': reference.type}
      }
    };

    var result = await collection.findAndModify(
        query: filter, update: data, returnNew: true, upsert: true);
    var newItem = result != null ? convertToPublic(result) : null;
    if (newItem != null) {
      logger.trace(correlationId, 'Removed reference in %s from id = %s',
          [collectionName, id]);
    }

    return newItem;
  }
}
