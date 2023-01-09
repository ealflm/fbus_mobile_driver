import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/font_weights.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/qr_painter.dart';
import '../../../core/widget/status_bar.dart';
import '../../../core/widget/unfocus.dart';
import '../controllers/qr_code_controller.dart';

class QrCodeView extends GetView<QrCodeController> {
  const QrCodeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.light,
      child: Unfocus(
        child: Scaffold(
          backgroundColor: AppColors.primary400,
          body: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: 10.h,
                          right: 18.w,
                        ),
                        child: Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                shape: const CircleBorder(),
                                padding: EdgeInsets.all(11.r),
                                minimumSize: Size.zero, // Set this
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              'QR Code',
                              style: h5.copyWith(color: AppColors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          vertical: 100.h, horizontal: 10.w),
                      padding: EdgeInsets.symmetric(
                          vertical: 30.h, horizontal: 40.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(9.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Sinh viên vui lòng quét QR để lên xe',
                            style: subtitle1.copyWith(
                                fontSize: 20.sp, fontWeight: FontWeights.light),
                            textAlign: TextAlign.center,
                          ),
                          Expanded(
                            child: Center(
                              child: SizedBox(
                                width: 250.w,
                                height: 250.w,
                                child: Stack(
                                  children: [
                                    CustomPaint(
                                      painter: QRPainter(),
                                      child: const SizedBox(
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(20.w),
                                      child: controller.qrImage(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
