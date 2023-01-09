import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/values/app_animation_assets.dart';
import '../../../core/values/font_weights.dart';
import '../../../core/values/text_styles.dart';
import '../../home/controllers/home_ticket_data_service.dart';

class QrCodeController extends GetxController {
  HomeTripDataService homeTripDataService = Get.find<HomeTripDataService>();

  final Rx<String?> _qrData = Rx<String?>(null);
  String? get qrData => _qrData.value;
  set qrData(String? value) {
    _qrData.value = value;
  }

  final Rx<bool> _isLoading = Rx<bool>(false);
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  @override
  void onInit() {
    fetchQRData();
    super.onInit();
  }

  Widget qrImage() {
    return Obx(() {
      if (isLoading || qrData == null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                AppAnimationAssets.loading,
                height: 100.r,
              ),
              Text('Đang tạo mới QR...',
                  style: subtitle1.copyWith(fontWeight: FontWeights.light)),
            ],
          ),
        );
      }
      return Center(
        child: QrImage(
          data: qrData ?? '',
          version: QrVersions.auto,
          gapless: false,
        ),
      );
    });
  }

  Future<void> fetchQRData() async {
    isLoading = true;
    // TODO: Replace qrData
    await Future.delayed(const Duration(seconds: 2));
    qrData =
        'hellofromhyperhellofromhyperhellofromhyperhellofromhyperhellofromhyper';
    isLoading = false;
  }
}
