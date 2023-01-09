import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/utils/auth_service.dart';
import '../../../core/widget/hyper_dialog.dart';

class ChangePasswordController extends BaseController {
  final formKey = GlobalKey<FormState>();
  String? oldPassword;
  String? newPassword;

  final Rx<bool> _isLoading = Rx<bool>(false);
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    if (oldPassword == null || newPassword == null) return;

    isLoading = true;

    String phoneNumber = AuthService.driver?.phone ?? '';

    var changePasswordService = repository.changePassword(
        phoneNumber, oldPassword ?? '', newPassword ?? '');

    await callDataService(
      changePasswordService,
      onSuccess: (response) {
        Get.back();
        HyperDialog.showSuccess(
          title: 'Thành công',
          content: 'Đổi mật khẩu thành công!',
          primaryButtonText: 'OK',
          primaryOnPressed: () {
            Get.back();
          },
        );
      },
    );

    isLoading = false;
  }
}
