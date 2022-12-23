import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../values/app_animation_assets.dart';
import '../values/app_colors.dart';
import '../values/font_weights.dart';
import '../values/text_styles.dart';

abstract class HyperDialog {
  static Future<void> show({
    String title = '',
    String content = '',
    String primaryButtonText = '',
    String? secondaryButtonText,
    bool barrierDismissible = true,
    Function()? primaryOnPressed,
    Function()? secondaryOnPressed,
  }) async {
    navigator?.popUntil((route) => !Get.isDialogOpen!);
    await Get.dialog(
      AlertDialog(
        title: Text(
          title,
          style: subtitle1.copyWith(color: AppColors.softBlack),
        ),
        content: Text(
          content,
          style: subtitle1.copyWith(color: AppColors.description),
        ),
        actions: [
          if (secondaryButtonText != null && secondaryButtonText.isNotEmpty)
            TextButton(
              child: Text(
                secondaryButtonText,
                style: body2.copyWith(
                  color: AppColors.description,
                ),
              ),
              onPressed: () => secondaryOnPressed != null
                  ? secondaryOnPressed()
                  : Get.back(),
            ),
          TextButton(
            child: Text(
              primaryButtonText,
              style: body2.copyWith(
                color: AppColors.primary400,
              ),
            ),
            onPressed: () =>
                primaryOnPressed != null ? primaryOnPressed() : Get.back(),
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<void> showLoading({
    String title = '',
    String content = '',
    String primaryButtonText = '',
    String? secondaryButtonText,
    bool barrierDismissible = false,
    Function()? primaryOnPressed,
    Function()? secondaryOnPressed,
  }) async {
    navigator?.popUntil((route) => !Get.isDialogOpen!);
    await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          title,
          style: subtitle1.copyWith(color: AppColors.softBlack),
        ),
        contentPadding: EdgeInsets.only(left: 24.w, right: 24.w, top: 20.h),
        content: Lottie.asset(
          AppAnimationAssets.loading,
          height: 100.r,
        ),
        actions: [
          if (secondaryButtonText != null && secondaryButtonText.isNotEmpty)
            TextButton(
              child: Text(
                secondaryButtonText,
                style: body2.copyWith(
                  color: AppColors.description,
                ),
              ),
              onPressed: () => secondaryOnPressed != null
                  ? secondaryOnPressed()
                  : Get.back(),
            ),
          TextButton(
            child: Text(
              primaryButtonText,
              style: body2.copyWith(
                color: AppColors.primary400,
              ),
            ),
            onPressed: () =>
                primaryOnPressed != null ? primaryOnPressed() : Get.back(),
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<void> showSuccess({
    String title = '',
    String content = '',
    String primaryButtonText = '',
    String? secondaryButtonText,
    bool barrierDismissible = true,
    Function()? primaryOnPressed,
    Function()? secondaryOnPressed,
  }) async {
    navigator?.popUntil((route) => !Get.isDialogOpen!);

    await Get.dialog(
      AlertDialog(
        title: Text(
          title,
          style: subtitle1.copyWith(color: AppColors.softBlack),
        ),
        contentPadding: EdgeInsets.only(left: 24.w, right: 24.w, top: 10.h),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              AppAnimationAssets.successful,
              height: 120.r,
              repeat: false,
            ),
            SizedBox(
              height: 11.h,
            ),
            Text(
              content,
              style: subtitle1.copyWith(
                fontWeight: FontWeights.medium,
                color: AppColors.softBlack,
              ),
            ),
          ],
        ),
        actions: [
          if (secondaryButtonText != null && secondaryButtonText.isNotEmpty)
            TextButton(
              child: Text(
                secondaryButtonText,
                style: body2.copyWith(
                  color: AppColors.description,
                ),
              ),
              onPressed: () => secondaryOnPressed != null
                  ? secondaryOnPressed()
                  : Get.back(),
            ),
          TextButton(
            child: Text(
              primaryButtonText,
              style: body2.copyWith(
                color: AppColors.primary400,
              ),
            ),
            onPressed: () =>
                primaryOnPressed != null ? primaryOnPressed() : Get.back(),
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<void> showFail({
    String title = '',
    String content = '',
    String primaryButtonText = '',
    String? secondaryButtonText,
    bool barrierDismissible = true,
    Function()? primaryOnPressed,
    Function()? secondaryOnPressed,
  }) async {
    navigator?.popUntil((route) => !Get.isDialogOpen!);
    await Get.dialog(
      AlertDialog(
        title: Text(
          title,
          style: subtitle1.copyWith(color: AppColors.softBlack),
        ),
        // contentPadding: EdgeInsets.only(left: 24.w, right: 24.w, top: 20.h),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              content,
              style: body2.copyWith(
                color: AppColors.lightBlack,
              ),
            ),
          ],
        ),
        actions: [
          if (secondaryButtonText != null && secondaryButtonText.isNotEmpty)
            TextButton(
              child: Text(
                secondaryButtonText,
                style: body2.copyWith(
                  color: AppColors.description,
                ),
              ),
              onPressed: () => secondaryOnPressed != null
                  ? secondaryOnPressed()
                  : Get.back(),
            ),
          TextButton(
            child: Text(
              primaryButtonText,
              style: body2.copyWith(
                color: AppColors.primary400,
              ),
            ),
            onPressed: () =>
                primaryOnPressed != null ? primaryOnPressed() : Get.back(),
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }
}
