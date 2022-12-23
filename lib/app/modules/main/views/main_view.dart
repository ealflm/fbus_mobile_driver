import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../core/values/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/main_controller.dart';
import '../widgets/nav_button.dart';

class MainView extends GetView<MainController> {
  const MainView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentTab.value,
          children: controller.screens,
        ),
      ),
      extendBody: true,
      floatingActionButton: SizedBox(
        width: 50.w,
        height: 50.w,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: AppColors.primary400,
            child: Icon(
              Icons.qr_code_scanner,
              color: AppColors.white,
              size: 30.r,
            ),
            onPressed: () {
              Get.toNamed(Routes.SCAN);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.h,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          height: 60.h,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  children: [
                    NavButton(
                      title: 'Trang chủ',
                      icon: Icons.explore,
                      iconOutlined: Icons.explore_outlined,
                      onPressed: () {
                        controller.changeTab(0);
                      },
                      state: controller.currentTab.value == 0,
                    ),
                    NavButton(
                      title: 'Vé của tôi',
                      icon: Icons.confirmation_number,
                      iconOutlined: Icons.confirmation_number_outlined,
                      onPressed: () {
                        controller.changeTab(1);
                      },
                      state: controller.currentTab.value == 1,
                    ),
                  ],
                ),
                SizedBox(
                  width: 60.w,
                ),
                Row(
                  children: [
                    NavButton(
                      title: 'Thông báo',
                      icon: Icons.notifications,
                      iconOutlined: Icons.notifications_outlined,
                      onPressed: () {
                        controller.changeTab(2);
                      },
                      state: controller.currentTab.value == 2,
                    ),
                    NavButton(
                      title: 'Tài khoản',
                      icon: Icons.person,
                      iconOutlined: Icons.person_outlined,
                      onPressed: () {
                        controller.changeTab(3);
                      },
                      state: controller.currentTab.value == 3,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
