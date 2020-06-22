import 'dart:async';
import 'package:pip_services3_data/pip_services3_data.dart';
import 'package:pip_services_attachments/src/data/version1/ReferenceV1.dart';
import '../data/version1/BlobAttachmentV1.dart';
import './IAttachmentsPersistence.dart';

class AttachmentsMemoryPersistence
    extends IdentifiableMemoryPersistence<BlobAttachmentV1, String>
    implements IAttachmentsPersistence {
  AttachmentsMemoryPersistence() : super();

  @override
  Future<BlobAttachmentV1> addReference(
      String correlationId, String id, ReferenceV1 reference) async {
    var item = items.isNotEmpty ? items.where((item) => item.id == id) : null;

    if (item != null && item.isNotEmpty && item.first != null) {
      item.first.references = item.first.references.where((r) {
        return !(r.id == reference.id && r.type == reference.type);
      }).toList();
      item.first.references.add(reference);
      logger.trace(correlationId, 'Added reference to %s', [id]);
      await save(correlationId);
      return item.first;
    } else {
      var newItem = BlobAttachmentV1(id: id, references: [reference]);
      items.add(newItem);
      logger.trace(correlationId, 'Added reference to %s', [id]);
      await save(correlationId);
      return newItem;
    }
  }

  @override
  Future<BlobAttachmentV1> removeReference(
      String correlationId, String id, ReferenceV1 reference) async {
    var item = items.isNotEmpty ? items.where((item) => item.id == id) : null;
    var removed = false;

    if (item != null) {
      var oldLength = item.first.references.length;
      item.first.references = item.first.references.where((r) {
        return !(r.id == reference.id && r.type == reference.type);
      }).toList();
      removed = item.first.references.length != oldLength;
    }

    if (removed) {
      logger.trace(correlationId, 'Removed reference to %s', [id]);
      await save(correlationId);
    }
    return item.first;
  }
}
