import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/app_png_assets.dart';
import '../../../core/values/app_svg_assets.dart';
import '../../../core/values/font_weights.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/status_bar.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.tap,
      child: StatusBar(
        brightness: Brightness.dark,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 0.45.sh,
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SvgPicture.asset(AppSvgAssets.fbusIsometric),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 30.w,
                    right: 30.w,
                    top: 30.h,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'FBus',
                        style: h4.copyWith(fontWeight: FontWeights.bold),
                      ),
                      Text(
                        'Chào mừng bạn đến với hệ thống đặt xe buýt tại đại học FPT',
                        textAlign: TextAlign.center,
                        style: subtitle1.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35.h,
                ),
                Obx(() => Opacity(
                      opacity: controller.hasTapped.value ? 1 : 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 21.r,
                            height: 21.r,
                            padding: EdgeInsets.all(5.r),
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              AppSvgAssets.lightBulb,
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            'Vui lòng đăng nhập để tiếp tục',
                            style: subtitle2.copyWith(
                              fontWeight: FontWeights.light,
                              color: AppColors.description,
                            ),
                          ),
                        ],
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(
                    left: 30.w,
                    right: 30.w,
                    top: 10.h,
                    bottom: 30.w,
                  ),
                  child: _loginWithGoogleButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginWithGoogleButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.login,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary400,
          disabledBackgroundColor: AppColors.onSurface.withOpacity(0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(300),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: controller.isLoading.value
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(6.w),
                      height: 18.w,
                      width: 18.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.softBlack,
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      'Vui lòng chờ',
                      style: subtitle1.copyWith(
                        fontWeight: FontWeights.medium,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppPngAssets.google,
                      width: 30.w,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      'Đăng nhập với Google',
                      style: subtitle1.copyWith(
                          fontWeight: FontWeights.medium,
                          color: AppColors.white),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
