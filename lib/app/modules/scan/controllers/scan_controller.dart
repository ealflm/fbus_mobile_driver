import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/utils/auth_service.dart';
import '../../../core/values/app_values.dart';
import '../../../core/widget/hyper_dialog.dart';
import '../../../routes/app_pages.dart';

class ScanController extends BaseController {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrController;
  var isFlashOn = false.obs;

  void onQRViewCreated(QRViewController controller) {
    qrController = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen(
      (scanData) async {
        result = scanData;
        String? data = result?.code;

        HapticFeedback.lightImpact();

        if (data!.startsWith(AppValues.checkinQRPrefix)) {
          var code = data.substring(AppValues.checkinQRPrefix.length);
          qrController?.pauseCamera();
          HyperDialog.show(
            title: 'Xác nhận',
            content: 'Bạn có chắc chắn muốn điểm danh lên xe?',
            primaryButtonText: 'Đồng ý',
            secondaryButtonText: 'Huỷ',
            primaryOnPressed: () async {
              HyperDialog.showLoading();
              bool isSuccess = await checkin(code);

              if (isSuccess) {
                Get.back();
                HyperDialog.showSuccess(
                  title: 'Thành công',
                  content: 'Điểm danh thành công',
                  barrierDismissible: false,
                  primaryButtonText: 'OK',
                );
              } else {
                HyperDialog.showFail(
                  title: 'Thất bại',
                  content:
                      'Đã có lỗi xảy ra khi điểm danh lên xe. Vui lòng thử lại!',
                  barrierDismissible: false,
                  primaryButtonText: 'Trở về trang chủ',
                  secondaryButtonText: 'Tiếp tục',
                  primaryOnPressed: () {
                    Get.offAllNamed(Routes.MAIN);
                  },
                  secondaryOnPressed: () async {
                    await qrController?.resumeCamera();
                    Get.back();
                  },
                );
              }
            },
            secondaryOnPressed: () async {
              await qrController?.resumeCamera();
              Get.back();
            },
          );
        } else {
          qrController?.pauseCamera();
          HyperDialog.show(
            title: 'Không hỗ trợ',
            content: 'FBus không hỗ trợ đọc QR code này',
            primaryButtonText: 'Đồng ý',
            primaryOnPressed: () async {
              await qrController?.resumeCamera();
              Get.back();
            },
          );
        }
      },
    );
  }

  Future<bool> checkin(String code) async {
    String driverId = AuthService.driver?.id ?? '';
    bool result = false;
    var checkInService = repository.checkIn(code, driverId);

    await callDataService(
      checkInService,
      onSuccess: (response) {
        result = true;
      },
      onError: (exception) {},
    );
    return result;
  }

  void toggleFlash() async {
    if (qrController != null) {
      await qrController?.toggleFlash();
      isFlashOn.value = await qrController?.getFlashStatus() ?? false;
    }
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }
}
