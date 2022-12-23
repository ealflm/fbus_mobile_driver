import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/status_bar.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: 18.w,
                        top: 10.h,
                        right: 18.w,
                      ),
                      child: Text(
                        'Thông báo',
                        style: h5.copyWith(color: AppColors.softBlack),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                controller.notificationList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
