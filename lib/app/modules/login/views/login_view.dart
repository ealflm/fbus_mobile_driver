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
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Unfocus(
      child: StatusBar(
        brightness: Brightness.dark,
        child: Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Container(
                    height: 0.35.sh,
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
                          'FBus Driver',
                          style: h4.copyWith(fontWeight: FontWeights.bold),
                        ),
                        Text(
                          'Chúc quý khách thượng lộ bình an',
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
                  Form(
                    key: controller.formKey,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30.sp),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              errorStyle: caption,
                              errorMaxLines: 2,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16.h, horizontal: 20.w),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              hintText: "Nhập số điện thoại",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 11.w),
                                child: const Icon(Icons.phone),
                              ),
                              counterStyle: const TextStyle(
                                height: double.minPositive,
                              ),
                              counterText: "",
                            ),
                            maxLength: 10,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Vui lòng nhập số điện thoại để tiếp tục';
                              }
                              if (!value.toString().startsWith('0') ||
                                  value.toString().length != 10) {
                                return 'Nhập số điện thoại có 10 chữ số và bắt đầu bằng số 0';
                              }
                              return null;
                            },
                            onSaved: (value) => controller.phoneNumber = value,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 10.h),
                          TextFormField(
                            obscureText: true,
                            obscuringCharacter: '•',
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              errorStyle: caption,
                              errorMaxLines: 2,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16.h, horizontal: 20.w),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              hintText: "Nhập mã PIN",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 11.w),
                                child: const Icon(Icons.key),
                              ),
                              counterStyle: const TextStyle(
                                height: double.minPositive,
                              ),
                              counterText: "",
                            ),
                            maxLength: 6,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Vui lòng nhập mã PIN để tiếp tục';
                              }
                              if (value.toString().length != 6) {
                                return 'Vui lòng nhập 6 chữ số';
                              }
                              return null;
                            },
                            onSaved: (value) => controller.password = value,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 10.h),
                          _loginButton(),
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

  Widget _loginButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading ? null : controller.login,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary400,
          disabledBackgroundColor: AppColors.onSurface.withOpacity(0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(300),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: controller.isLoading
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
                    SizedBox(height: 30.h),
                    Text(
                      'Đăng nhập',
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
