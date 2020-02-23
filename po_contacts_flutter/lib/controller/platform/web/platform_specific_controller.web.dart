import 'package:po_contacts_flutter/controller/platform/platform_specific_controller.dart';
import 'package:po_contacts_flutter/controller/platform/web/file_transit_manager.web.dart';

class PSHelperWeb implements PSHelper {
  @override
  FilesTransitManager createFilesTransitManager() {
    return FileTransitManagerWeb();
  }
}

PSHelper getInstanceImpl() => PSHelperWeb();
