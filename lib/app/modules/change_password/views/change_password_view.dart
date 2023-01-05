import 'package:fbus_mobile_driver/app/core/widget/hyper_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/font_weights.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/status_bar.dart';
import '../../../core/widget/unfocus.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Unfocus(
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
                                color: AppColors.softBlack,
                              ),
                            ),
                            Text(
                              'Đổi mã PIN',
                              style: h5.copyWith(color: AppColors.softBlack),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: 18.w,
                          top: 5.h,
                          right: 18.w,
                        ),
                        child: Text('Mật khẩu của bạn gồm 6 chữ số',
                            style: subtitle1),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Form(
                    key: controller.formKey,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 14.w,
                        top: 5.h,
                        right: 14.w,
                      ),
                      child: Column(
                        children: [
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
                              hintText: "Nhập mã PIN hiện tại",
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
                                return 'Vui lòng nhập mã PIN hiện tại để tiếp tục';
                              }
                              if (value.toString().length != 6) {
                                return 'Vui lòng nhập 6 chữ số';
                              }
                              return null;
                            },
                            onSaved: (value) => controller.oldPassword = value,
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
                              hintText: "Nhập mã PIN mới",
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
                                return 'Vui lòng nhập mã PIN mới để tiếp tục';
                              }
                              if (value.toString().length != 6) {
                                return 'Vui lòng nhập 6 chữ số';
                              }
                              return null;
                            },
                            onChanged: (value) =>
                                controller.newPassword = value,
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
                              hintText: "Nhập lại mã PIN mới",
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
                                return 'Vui lòng nhập lại mã PIN mới để tiếp tục';
                              }
                              if (value.toString().length != 6) {
                                return 'Vui lòng nhập 6 chữ số';
                              }
                              if (value.toString() !=
                                  controller.newPassword.toString()) {
                                return 'Mã PIN không trùng khớp';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 10.h),
                          _confirmButton(),
                          SizedBox(height: 20.h),
                          InkWell(
                            onTap: () {
                              HyperDialog.show(
                                title: 'Hỗ trợ',
                                content:
                                    'Nếu có vấn đề về tài khoản tài xế vui lòng liên hệ admin qua email: nguyenhuutoan@fpt.edu.vn',
                                primaryButtonText: 'OK',
                              );
                            },
                            child: Text(
                              'Bạn cần giúp đỡ?',
                              style: subtitle2.copyWith(
                                color: AppColors.blue900,
                                fontWeight: FontWeights.regular,
                              ),
                            ),
                          )
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

  Widget _confirmButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading ? null : controller.submit,
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
                      'Đổi mật khẩu',
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
