import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../core/utils/auth_service.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_svg_assets.dart';
import '../../../core/values/font_weights.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/status_bar.dart';
import '../controllers/account_controller.dart';
import '../widgets/account_item.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(50.r), // Image radius
                            child:
                                // Obx(
                                //   () =>
                                CachedNetworkImage(
                              fadeInDuration: const Duration(),
                              fadeOutDuration: const Duration(),
                              placeholder: (context, url) {
                                return SvgPicture.asset(AppSvgAssets.male);
                              },
                              imageUrl: AuthService.student?.photoUrl ?? '',
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return SvgPicture.asset(AppSvgAssets.male);
                              },
                            ),
                            // ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          '${AuthService.student?.fullName}',
                          style: h6.copyWith(
                              fontWeight: FontWeights.bold, fontSize: 19.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 28.h,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tài khoản',
                          style: body2.copyWith(color: AppColors.gray),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        const AccountItem(
                          icon: Icons.person,
                          text: 'Tài khoản của tôi',
                          color: AppColors.blue,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 28.h,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tuỳ chọn',
                          style: body2.copyWith(color: AppColors.gray),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        AccountItem(
                          onPress: () {
                            AuthService.logout();
                          },
                          icon: Icons.power_settings_new,
                          text: 'Đăng xuất',
                          color: AppColors.orange,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
