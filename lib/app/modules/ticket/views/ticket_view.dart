import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/status_bar.dart';
import '../controllers/ticket_controller.dart';

class TicketView extends GetView<TicketController> {
  const TicketView({Key? key}) : super(key: key);
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
                _header(),
                SizedBox(height: 8.h),
                Expanded(
                  child: Obx(
                    () => IndexedStack(
                      index: controller.tabIndex.value,
                      children: controller.screens,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
                'Vé của tôi',
                style: h5.copyWith(color: AppColors.softBlack),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          height: 32.h,
          width: 327.w,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: TabBar(
            controller: controller.tabController,
            onTap: (index) {
              controller.changeTab(index);
            },
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              color: AppColors.primary400,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                  color: AppColors.primary400.withOpacity(0.4),
                ),
              ],
            ),
            labelColor: AppColors.white,
            unselectedLabelColor: AppColors.description,
            tabs: controller.tabs,
          ),
        ),
      ],
    );
  }
}
