import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/utils/notification_service.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_svg_assets.dart';
import '../../../core/values/font_weights.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/hyper_dialog.dart';
import '../../../core/widget/shared.dart';
import '../../../data/models/student_trip_model.dart';
import '../../../routes/app_pages.dart';

class FeedBackController extends BaseController {
  final Rx<Ticket?> _ticket = Rx<Ticket?>(null);
  Ticket? get ticket => _ticket.value;
  set ticket(Ticket? value) {
    _ticket.value = value;
  }

  String? get studentTripId => _ticket.value?.id;

  String? feedbackMessage = '';

  /// Rate
  final Rx<double?> _rate = Rx<double?>(0);
  double? get rate => _rate.value;
  set rate(double? value) {
    _rate.value = value;
  }

  @override
  void onInit() {
    Map<String, dynamic> arg = {};
    if (Get.arguments != null) {
      arg = Get.arguments as Map<String, dynamic>;
    }
    if (arg.containsKey('ticket')) {
      ticket = arg['ticket'];
    } else {
      showToast('Đã có lỗi xảy ra');
      Get.back();
    }
    super.onInit();
  }

  Future<void> feedback() async {
    if (studentTripId == null || rate == null || feedbackMessage == null) {
      debugPrint(
          'Cant send feedback because one of these fields are null: studentTripId, rate, feedbackMessage');
      return;
    }
    var feedbackService =
        repository.feedback(studentTripId!, rate!, feedbackMessage!);

    await callDataService(
      feedbackService,
      onSuccess: ((response) {
        Get.offNamed(Routes.MAIN);
        HyperDialog.showSuccess(
          title: 'Thành công',
          content: 'Gửi đánh giá thành công',
          barrierDismissible: false,
          primaryButtonText: 'OK',
          primaryOnPressed: () {
            NotificationService.reloadData();
            Get.back();
          },
        );
      }),
      onError: (exception) {
        HyperDialog.showFail(
          title: 'Thất bại',
          content: 'Đã có lỗi xảy ra trong quá trình đánh giá',
          barrierDismissible: false,
          primaryButtonText: 'Trở về trang chủ',
          secondaryButtonText: 'Tiếp tục đánh giá',
          primaryOnPressed: () {
            Get.offAllNamed(Routes.MAIN);
          },
          secondaryOnPressed: () {
            Get.back();
          },
        );
      },
    );
  }

  Widget feedbackButton() {
    return Obx(
      () {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          ),
          onPressed: (rate ?? 0) > 0
              ? () async {
                  feedback();
                }
              : null,
          child: Text(
            'Gửi đánh giá',
            style: subtitle2.copyWith(color: AppColors.white),
          ),
        );
      },
    );
  }

  Widget driverInfo() {
    return Obx(() {
      return Column(
        children: [
          ClipOval(
            child: SizedBox.fromSize(
              size: Size.fromRadius(30.r), // Image radius
              child: CachedNetworkImage(
                fadeInDuration: const Duration(),
                fadeOutDuration: const Duration(),
                placeholder: (context, url) {
                  return SvgPicture.asset(AppSvgAssets.male);
                },
                imageUrl: ticket?.trip?.driver?.photoUrl ?? '',
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return SvgPicture.asset(AppSvgAssets.male);
                },
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(ticket?.trip?.driver?.fullName ?? '-', style: h6),
          SizedBox(
            height: 5.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Biển số xe',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeights.regular,
                          letterSpacing: 0.0025.sp,
                        ),
                      ),
                      Text(
                        '${ticket?.trip?.bus?.licensePlates}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeights.medium,
                          letterSpacing: 0.0025.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 30.w,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Màu sắc',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeights.regular,
                          letterSpacing: 0.0025.sp,
                        ),
                      ),
                      Text(
                        '${ticket?.trip?.bus?.color}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeights.medium,
                          letterSpacing: 0.0025.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 30.w,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Số ghế',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeights.regular,
                          letterSpacing: 0.0025.sp,
                        ),
                      ),
                      Text(
                        '${ticket?.trip?.bus?.seat}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeights.medium,
                          letterSpacing: 0.0025.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget stars() {
    return Obx(() {
      if (rate == null) return Container();
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _star(rate! >= 1, () {
            rate = 1;
          }),
          _star(rate! >= 2, () {
            rate = 2;
          }),
          _star(rate! >= 3, () {
            rate = 3;
          }),
          _star(rate! >= 4, () {
            rate = 4;
          }),
          _star(rate! >= 5, () {
            rate = 5;
          }),
        ],
      );
    });
  }

  Widget _star(bool state, Function() onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Icon(
        Icons.star,
        size: 40.w,
        color: state ? AppColors.yellow : AppColors.line,
      ),
    );
  }
}
