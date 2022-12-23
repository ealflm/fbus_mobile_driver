import 'package:get/get.dart';

import '../controllers/confirm_ticket_controller.dart';

class ConfirmTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfirmTicketController>(
      () => ConfirmTicketController(),
    );
  }
}
