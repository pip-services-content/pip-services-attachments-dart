import 'dart:async';
import '../../src/data/version1/BlobAttachmentV1.dart';
import '../../src/data/version1/ReferenceV1.dart';

abstract class IAttachmentsController {
  /// Gets an attachment by its unique id.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [attachmentId]                an id of attachment to be retrieved.
  /// Return         Future that receives attachment or error.
  Future<BlobAttachmentV1> getAttachmentById(
      String correlationId, String attachmentId);

  /// Adds reference to attachments by ids and return list of these attachments.
  ///
  /// - [correlationId]    (optional) transaction id to trace execution through call chain.
  /// - [reference]              a reference to be added.
  /// - [ids]              an attachments ids to be added to.
  /// Return         (optional) Future that receives list of attachment or error.
  Future<List<BlobAttachmentV1>> addAttachments(
      String correlationId, ReferenceV1 reference, List<String> ids);

  /// Updates reference in all attachments by their ids.
  ///
  /// - [correlationId]    (optional) transaction id to trace execution through call chain.
  /// - [reference]              a reference to be added.
  /// - [oldIds]              an old attachments ids to be updated.
  /// - [newIds]              an new attachments ids to be updated.
  /// Return         (optional) Future that receives list of attachment or error.
  Future<List<BlobAttachmentV1>> updateAttachments(String correlationId,
      ReferenceV1 reference, List<String> oldIds, List<String> newIds);

  /// Removes reference in attachments by their ids and return list of these attachments.
  ///
  /// - [correlationId]    (optional) transaction id to trace execution through call chain.
  /// - [reference]              a reference to be removed.
  /// - [ids]              an attachments ids to be removed to.
  /// Return         (optional) Future that receives list of attachment or error.
  Future<List<BlobAttachmentV1>> removeAttachments(
      String correlationId, ReferenceV1 reference, List<String> ids);

  /// Deletes an attachment by it's unique id.
  ///
  /// - [correlationId]    (optional) transaction id to trace execution through call chain.
  /// - [attachmentId]                an id of the attachment to be deleted
  /// Return                Future that receives deleted attachment
  /// Throws error.
  Future<BlobAttachmentV1> deleteAttachmentById(
      String correlationId, String attachmentId);
}
