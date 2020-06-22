import 'package:pip_services3_container/pip_services3_container.dart';
import 'package:pip_services3_rpc/pip_services3_rpc.dart';

import '../build/AttachmentsServiceFactory.dart';

class AttachmentsProcess extends ProcessContainer {
  AttachmentsProcess() : super('attachments', 'Attachments microservice') {
    factories.add(AttachmentsServiceFactory());
    factories.add(DefaultRpcFactory());
    // factories.add(BlobsClientFactory);
  }
}
