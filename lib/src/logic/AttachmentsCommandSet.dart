import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../../src/data/version1/ReferenceV1Schema.dart';
import '../../src/logic/IAttachmentsController.dart';
import '../../src/data/version1/ReferenceV1.dart';

class AttachmentsCommandSet extends CommandSet {
  IAttachmentsController _controller;

  AttachmentsCommandSet(IAttachmentsController controller) : super() {
    _controller = controller;

    addCommand(_makeGetAttachmentByIdCommand());
    addCommand(_makeAddAttachmentsCommand());
    addCommand(_makeUpdateAttachmentsCommand());
    addCommand(_makeRemoveAttachmentsCommand());
    addCommand(_makeDeleteAttachmentByIdCommand());
  }

  ICommand _makeGetAttachmentByIdCommand() {
    return Command('get_attachment_by_id',
        ObjectSchema(true).withRequiredProperty('id', TypeCode.String),
        (String correlationId, Parameters args) {
      var attachmentId = args.getAsNullableString('id');
      return _controller.getAttachmentById(correlationId, attachmentId);
    });
  }

  ICommand _makeAddAttachmentsCommand() {
    return Command(
        'add_attachments',
        ObjectSchema(true)
            .withRequiredProperty('reference', ReferenceV1Schema())
            .withRequiredProperty('ids', ArraySchema(TypeCode.String)),
        (String correlationId, Parameters args) {
      var reference = ReferenceV1();
      reference.fromJson(args.get('reference'));
      var ids = List<String>.from(args.get('ids'));
      return _controller.addAttachments(correlationId, reference, ids);
    });
  }

  ICommand _makeUpdateAttachmentsCommand() {
    return Command(
        'update_attachments',
        ObjectSchema(true)
            .withRequiredProperty('reference', ReferenceV1Schema())
            .withRequiredProperty('old_ids', ArraySchema(TypeCode.String))
            .withRequiredProperty('new_ids', ArraySchema(TypeCode.String)),
        (String correlationId, Parameters args) {
      var reference = ReferenceV1();
      reference.fromJson(args.get('reference'));
      var oldIds = List<String>.from(args.get('old_ids'));
      var newIds = List<String>.from(args.get('new_ids'));
      return _controller.updateAttachments(
          correlationId, reference, oldIds, newIds);
    });
  }

  ICommand _makeRemoveAttachmentsCommand() {
    return Command(
        'remove_attachments',
        ObjectSchema(true)
            .withRequiredProperty('reference', ReferenceV1Schema())
            .withRequiredProperty('ids', ArraySchema(TypeCode.String)),
        (String correlationId, Parameters args) {
      var reference = ReferenceV1();
      reference.fromJson(args.get('reference'));
      var ids = List<String>.from(args.get('ids'));
      return _controller.removeAttachments(correlationId, reference, ids);
    });
  }

  ICommand _makeDeleteAttachmentByIdCommand() {
    return Command('delete_attachment_by_id', null,
        (String correlationId, Parameters args) {
      var attachmentId = args.getAsNullableString('id');
      return _controller.deleteAttachmentById(correlationId, attachmentId);
    });
  }
}
