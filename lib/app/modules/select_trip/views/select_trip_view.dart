import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/widget/status_bar.dart';
import '../../../routes/app_pages.dart';
import '../controllers/select_trip_controller.dart';

class SelectTripView extends GetView<SelectTripController> {
  const SelectTripView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        floatingActionButton: SizedBox(
          width: 50.w,
          height: 50.w,
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: AppColors.pink900,
              child: Icon(
                Icons.home,
                color: AppColors.white,
                size: 30.r,
              ),
              onPressed: () {
                Get.offAllNamed(Routes.MAIN);
              },
            ),
          ),
        ),
        body: Column(
          children: [
            controller.calendar(),
            SizedBox(
              height: 10.h,
            ),
            controller.tripList(),
          ],
        ),
      ),
    );
  }
}
