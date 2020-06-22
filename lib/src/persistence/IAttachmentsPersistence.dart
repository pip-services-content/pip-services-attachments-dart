import 'dart:async';
import '../data/version1/BlobAttachmentV1.dart';
import '../data/version1/ReferenceV1.dart';

abstract class IAttachmentsPersistence {
  Future<BlobAttachmentV1> getOneById(String correlationId, String id);

  Future<BlobAttachmentV1> addReference(
      String correlationId, String id, ReferenceV1 reference);

  Future<BlobAttachmentV1> removeReference(
      String correlationId, String id, ReferenceV1 reference);

  Future<BlobAttachmentV1> deleteById(String correlationId, String id);
}
