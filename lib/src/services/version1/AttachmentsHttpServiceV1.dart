import 'package:pip_services3_rpc/pip_services3_rpc.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

class AttachmentsHttpServiceV1 extends CommandableHttpService {
  AttachmentsHttpServiceV1() : super('v1/attachments') {
    dependencyResolver.put('controller',
        Descriptor('pip-services-attachments', 'controller', '*', '*', '1.0'));
  }
}
