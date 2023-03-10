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
                              '?????i m?? PIN',
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
                        child: Text('M???t kh???u c???a b???n g???m 6 ch??? s???',
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
                            obscuringCharacter: '???',
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
                              hintText: "Nh???p m?? PIN hi???n t???i",
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
                                return 'Vui l??ng nh???p m?? PIN hi???n t???i ????? ti???p t???c';
                              }
                              if (value.toString().length != 6) {
                                return 'Vui l??ng nh???p 6 ch??? s???';
                              }
                              return null;
                            },
                            onSaved: (value) => controller.oldPassword = value,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 10.h),
                          TextFormField(
                            obscureText: true,
                            obscuringCharacter: '???',
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
                              hintText: "Nh???p m?? PIN m???i",
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
                                return 'Vui l??ng nh???p m?? PIN m???i ????? ti???p t???c';
                              }
                              if (value.toString().length != 6) {
                                return 'Vui l??ng nh???p 6 ch??? s???';
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
                            obscuringCharacter: '???',
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
                              hintText: "Nh???p l???i m?? PIN m???i",
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
                                return 'Vui l??ng nh???p l???i m?? PIN m???i ????? ti???p t???c';
                              }
                              if (value.toString().length != 6) {
                                return 'Vui l??ng nh???p 6 ch??? s???';
                              }
                              if (value.toString() !=
                                  controller.newPassword.toString()) {
                                return 'M?? PIN kh??ng tr??ng kh???p';
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
                                title: 'H??? tr???',
                                content:
                                    'N???u c?? v???n ????? v??? t??i kho???n t??i x??? vui l??ng li??n h??? admin qua email: nguyenhuutoan@fpt.edu.vn',
                                primaryButtonText: 'OK',
                              );
                            },
                            child: Text(
                              'B???n c???n gi??p ??????',
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
                      'Vui l??ng ch???',
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
                      '?????i m???t kh???u',
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
