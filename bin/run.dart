import 'package:pip_services_attachments/pip_services_attachments.dart';

void main(List<String> argument) {
  try {
    var proc = AttachmentsProcess();
    proc.configPath = './config/config.yml';
    proc.run(argument);
  } catch (ex) {
    print(ex);
  }
}
