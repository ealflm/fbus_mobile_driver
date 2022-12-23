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
            title: 'Liên kết thẻ',
            content: 'Bạn có chắc chắn muốn checkin lên xe này không?',
            primaryButtonText: 'Đồng ý',
            secondaryButtonText: 'Huỷ',
            primaryOnPressed: () async {
              HyperDialog.showLoading();
              bool isSuccess = await checkin(code);

              if (isSuccess) {
                HyperDialog.showSuccess(
                  title: 'Thành công',
                  content: 'Đặt vé thành công!',
                  barrierDismissible: false,
                  primaryButtonText: 'Trở về trang chủ',
                  secondaryButtonText: 'Tiếp tục đặt',
                  primaryOnPressed: () {
                    Get.offAllNamed(Routes.MAIN);
                  },
                  secondaryOnPressed: () async {
                    await qrController?.resumeCamera();
                    Get.back();
                  },
                );
              } else {
                HyperDialog.showFail(
                  title: 'Thất bại',
                  content:
                      'Không tìm thấy vé xe cho chuyến đi này. Vui lòng đến đúng thời gian và địa điểm ghi trên vé để checkin.',
                  barrierDismissible: false,
                  primaryButtonText: 'Trở về trang chủ',
                  secondaryButtonText: 'Tiếp tục đặt',
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
    String studentId = AuthService.student?.id ?? '';
    bool result = false;
    var checkinService = repository.checkin(studentId, code);

    await callDataService(
      checkinService,
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
