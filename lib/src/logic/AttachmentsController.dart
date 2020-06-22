import 'dart:async';

import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../../src/data/version1/BlobAttachmentV1.dart';
import '../../src/data/version1/ReferenceV1.dart';
import '../../src/persistence/IAttachmentsPersistence.dart';
import './IAttachmentsController.dart';
import './AttachmentsCommandSet.dart';

class AttachmentsController
    implements
        IAttachmentsController,
        IConfigurable,
        IReferenceable,
        ICommandable {
  static final ConfigParams _defaultConfig = ConfigParams.fromTuples([
    'dependencies.persistence',
    'pip-services-attachments:persistence:*:*:1.0',
    'dependencies.blobs',
    'pip-services-blos:client:*:*:1.0'
  ]);
  IAttachmentsPersistence persistence;
  AttachmentsCommandSet commandSet;
  DependencyResolver dependencyResolver =
      DependencyResolver(AttachmentsController._defaultConfig);
  // IBlobsClientV1 _blobsClient;

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    dependencyResolver.configure(config);
  }

  /// Set references to component.
  ///
  /// - [references]    references parameters to be set.
  @override
  void setReferences(IReferences references) {
    dependencyResolver.setReferences(references);
    persistence = dependencyResolver
        .getOneRequired<IAttachmentsPersistence>('persistence');
    // _blobsClient = dependencyResolver.getOneOptional<IBlobsClientV1>('blobs');
  }

  /// Gets a command set.
  ///
  /// Return Command set
  @override
  CommandSet getCommandSet() {
    commandSet ??= AttachmentsCommandSet(this);
    return commandSet;
  }

  /// Gets an attachment by its unique id.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [attachmentId]                an id of attachment to be retrieved.
  /// Return         Future that receives attachment or error.
  @override
  Future<BlobAttachmentV1> getAttachmentById(
      String correlationId, String attachmentId) {
    return persistence.getOneById(correlationId, attachmentId);
  }

  /// Adds reference to attachments by ids and return list of these attachments.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [reference]              a reference to be added.
  /// - [ids]              an attachments ids to be added to.
  /// Return         (optional) Future that receives list of attachment or error.
  @override
  Future<List<BlobAttachmentV1>> addAttachments(
      String correlationId, ReferenceV1 reference, List<String> ids) async {
    var attachments = <BlobAttachmentV1>[];

    // Record new references to all blobs
    ids.forEach((id) async {
      var attachment =
          await persistence.addReference(correlationId, id, reference);
      if (attachment != null) {
        attachments.add(attachment);
      }
    });

    // Mark new blobs completed

    var blobIds = [];
    attachments.forEach((a) {
      if (a.references != null && a.references.length <= 1) {
        blobIds.add(a.id);
      }
    });

    // if (_blobsClient != null && blobIds.isNotEmpty) {
    //   _blobsClient.markBlobsCompleted(correlationId, blobIds);
    // }

    return attachments;
  }

  /// Updates reference in all attachments by their ids.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [reference]              a reference to be added.
  /// - [oldIds]              an old attachments ids to be updated.
  /// - [newIds]              an new attachments ids to be updated.
  /// Return         (optional) Future that receives list of attachment or error.
  @override
  Future<List<BlobAttachmentV1>> updateAttachments(String correlationId,
      ReferenceV1 reference, List<String> oldIds, List<String> newIds) async {
    var attachments = <BlobAttachmentV1>[];

    // Remove obsolete ids
    var ids = oldIds.toSet().difference(newIds.toSet()).toList();
    if (ids.isNotEmpty) {
      var removedAttachments =
          await removeAttachments(correlationId, reference, ids);
      removedAttachments.forEach((a) {
        attachments.add(a);
      });
    }

    // Add new ids
    ids = newIds.toSet().difference(oldIds.toSet()).toList();
    if (ids.isNotEmpty) {
      var _addAttachments = await addAttachments(correlationId, reference, ids);
      _addAttachments.forEach((a) {
        attachments.add(a);
      });
    }

    return attachments;
  }

  /// Removes reference in attachments by their ids and return list of these attachments.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [reference]              a reference to be removed.
  /// - [ids]              an attachments ids to be removed to.
  /// Return         (optional) Future that receives list of attachment or error.
  @override
  Future<List<BlobAttachmentV1>> removeAttachments(
      String correlationId, ReferenceV1 reference, List<String> ids) async {
    var attachments = <BlobAttachmentV1>[];

    ids.forEach((id) async {
      var attachment =
          await persistence.removeReference(correlationId, id, reference);
      if (attachment != null) {
        attachments.add(attachment);
      }
      if (attachment.references == null || attachment.references.isEmpty) {
        await deleteAttachmentById(correlationId, attachment.id);
      }
    });

    return attachments;
  }

  /// Deletes an attachment by it's unique id.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [attachmentId]                an id of the attachment to be deleted
  /// Return                Future that receives deleted attachment
  /// Throws error.
  @override
  Future<BlobAttachmentV1> deleteAttachmentById(
      String correlationId, String attachmentId) async {
    var attachment = await persistence.deleteById(correlationId, attachmentId);
    // if (_blobsClient != null) {
    //   _blobsClient.deleteBlobById(correlationId, attachmentId);
    // }
    return attachment;
  }
}
