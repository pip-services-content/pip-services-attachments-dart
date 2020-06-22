import 'package:pip_services3_commons/pip_services3_commons.dart';
import './ReferenceV1.dart';

class BlobAttachmentV1 implements IStringIdentifiable {
  @override
  String id;
  List<ReferenceV1> references;

  BlobAttachmentV1({String id, List<ReferenceV1> references})
      : id = id,
        references = references;

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    var items = json['references'];
    references = List<ReferenceV1>.from(
        items.map((itemsJson) => ReferenceV1.fromJson(itemsJson)));
  }

  factory BlobAttachmentV1.fromJson(Map<String, dynamic> json) {
    var attachment = BlobAttachmentV1();
    attachment.fromJson(json);
    return attachment;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'references': references};
  }
}
