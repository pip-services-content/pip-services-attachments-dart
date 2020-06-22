import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../persistence/AttachmentsMemoryPersistence.dart';
import '../persistence/AttachmentsFilePersistence.dart';
import '../persistence/AttachmentsMongoDbPersistence.dart';
import '../logic/AttachmentsController.dart';
import '../services/version1/AttachmentsHttpServiceV1.dart';

class AttachmentsServiceFactory extends Factory {
  static final MemoryPersistenceDescriptor = Descriptor(
      'pip-services-attachments', 'persistence', 'memory', '*', '1.0');
  static final FilePersistenceDescriptor =
      Descriptor('pip-services-attachments', 'persistence', 'file', '*', '1.0');
  static final MongoDbPersistenceDescriptor = Descriptor(
      'pip-services-attachments', 'persistence', 'mongodb', '*', '1.0');
  static final ControllerDescriptor = Descriptor(
      'pip-services-attachments', 'controller', 'default', '*', '1.0');
  static final HttpServiceDescriptor =
      Descriptor('pip-services-attachments', 'service', 'http', '*', '1.0');

  AttachmentsServiceFactory() : super() {
    registerAsType(AttachmentsServiceFactory.MemoryPersistenceDescriptor,
        AttachmentsMemoryPersistence);
    registerAsType(AttachmentsServiceFactory.FilePersistenceDescriptor,
        AttachmentsFilePersistence);
    registerAsType(AttachmentsServiceFactory.MongoDbPersistenceDescriptor,
        AttachmentsMongoDbPersistence);
    registerAsType(
        AttachmentsServiceFactory.ControllerDescriptor, AttachmentsController);
    registerAsType(AttachmentsServiceFactory.HttpServiceDescriptor,
        AttachmentsHttpServiceV1);
  }
}
