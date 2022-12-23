import 'package:get/get.dart';

import '../../../core/utils/auth_service.dart';

class LoginController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> hasTapped = false.obs;

  void login() async {
    hasTapped.value = false;
    isLoading.value = true;
    bool result = await AuthService.login();
    if (!result) {
      isLoading.value = false;
    }
  }

  void tap() {
    hasTapped.value = true;
  }
}
