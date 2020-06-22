import 'package:pip_services3_data/pip_services3_data.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../data/version1/BlobAttachmentV1.dart';
import './AttachmentsMemoryPersistence.dart';

class AttachmentsFilePersistence extends AttachmentsMemoryPersistence {
  JsonFilePersister<BlobAttachmentV1> persister;

  AttachmentsFilePersistence([String path]) : super() {
    persister = JsonFilePersister<BlobAttachmentV1>(path);
    loader = persister;
    saver = persister;
  }
  @override
  void configure(ConfigParams config) {
    super.configure(config);
    persister.configure(config);
  }
}
