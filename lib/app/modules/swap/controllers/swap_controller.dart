import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/utils/auth_service.dart';
import '../../../core/utils/notification_service.dart';
import '../../../core/widget/hyper_dialog.dart';

class SwapController extends BaseController {
  final formKey = GlobalKey<FormState>();
  String? tripId;
  String? content;

  final Rx<bool> _isLoading = Rx<bool>(false);
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  @override
  void onInit() {
    Map<String, dynamic> arg = {};
    if (Get.arguments != null) {
      arg = Get.arguments as Map<String, dynamic>;
    }
    if (arg.containsKey('tripId')) {
      tripId = arg['tripId'];
    }
    super.onInit();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    if (tripId == null) return;

    isLoading = true;

    String driverId = AuthService.driver?.id ?? '';

    var requestSwapService = repository.requestSwap(
      driverId,
      tripId ?? '',
      content,
    );

    await callDataService(
      requestSwapService,
      onSuccess: (response) {
        Get.back();
        HyperDialog.showSuccess(
          title: 'Thành công',
          content: 'Gửi yêu cầu thành công',
          barrierDismissible: false,
          primaryButtonText: 'OK',
          primaryOnPressed: () {
            Get.back();
          },
        );
      },
      onError: (exception) {
        HyperDialog.showFail(
          title: 'Thất bại',
          content: 'Đã có lỗi xảy ra trong quá trình gửi yêu cầu',
          barrierDismissible: false,
          primaryButtonText: 'Quay lại',
          secondaryButtonText: 'Tiếp tục',
          primaryOnPressed: () {
            Get.back();
            Get.back();
          },
          secondaryOnPressed: () {
            Get.back();
          },
        );
      },
    );

    isLoading = false;
  }
}
