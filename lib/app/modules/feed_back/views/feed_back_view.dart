import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/app_svg_assets.dart';
import '../../../core/values/font_weights.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/status_bar.dart';
import '../../../core/widget/unfocus.dart';
import '../controllers/feed_back_controller.dart';

class FeedBackView extends GetView<FeedBackController> {
  const FeedBackView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Unfocus(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 15.w, top: 10.h),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: AppColors.white,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: const EdgeInsets.all(0),
                            minimumSize: Size(40.r, 40.r),
                          ),
                          child: SizedBox(
                            height: 40.r,
                            width: 40.r,
                            child: Icon(
                              Icons.close,
                              size: 18.r,
                              color: AppColors.gray,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0.05.sh,
                ),
                controller.driverInfo(),
                SizedBox(height: 10.h),
                controller.stars(),
                SizedBox(height: 10.h),
                lightBub(
                    'Vui lòng chọn sao để đánh giá chuyến đi. Đánh giá sẽ được gửi về admin và tài xế phụ trách chuyến đi'),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 12.h),
                      hintText: 'Góp ý chuyến đi',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: AppColors.softBlack,
                        ),
                      ),
                    ),
                    onChanged: ((value) {
                      controller.feedbackMessage = value;
                    }),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                controller.feedbackButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget lightBub(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 19.r,
                height: 19.r,
                padding: EdgeInsets.all(3.r),
                decoration: const BoxDecoration(
                  color: AppColors.yellow600,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppSvgAssets.lightBulb,
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              Expanded(
                child: Text(
                  text,
                  style: subtitle2.copyWith(fontWeight: FontWeights.light),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
