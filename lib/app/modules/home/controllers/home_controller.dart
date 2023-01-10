import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../core/values/app_animation_assets.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/font_weights.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/trip_item.dart';
import '../../../data/models/trip_model.dart';
import '../../../routes/app_pages.dart';
import 'home_ticket_data_service.dart';
import 'statistic_data_service.dart';

class HomeController extends GetxController {
  HomeTripDataService tripDataService = Get.find<HomeTripDataService>();
  StatisticDataService statisticDataService = Get.find<StatisticDataService>();

  Widget statistic() {
    return Obx(
      () {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.r),
              color: AppColors.white,
              boxShadow: kElevationToShadow[2],
            ),
            padding: EdgeInsets.only(
              left: 10.w,
              right: 10.w,
              top: 15.h,
            ),
            child: Column(
              children: [
                Text(
                  'Thống kê theo tuần',
                  style: subtitle2.copyWith(
                    fontWeight: FontWeights.light,
                    color: AppColors.lightBlack,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _summarizeLabel(
                        '${statisticDataService.statistic?.tripCount ?? 0} chuyến',
                        'Đã đi'),
                    _summarizeLabel(
                        '${(statisticDataService.statistic?.tripNotUseCount ?? 0)} chuyến',
                        'Sắp tới'),
                    _summarizeLabel(
                        '${statisticDataService.statistic?.distanceStr ?? 0} km',
                        'Đã đi'),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Column _summarizeLabel(String title, String description) {
    return Column(
      children: [
        Text(title, style: subtitle1.copyWith(fontWeight: FontWeights.bold)),
        Text(description,
            style: subtitle2.copyWith(fontWeight: FontWeights.light)),
      ],
    );
  }

  Widget currentTicket() {
    return Obx(
      () {
        if (tripDataService.isLoading) {
          return Center(
            child: Column(
              children: [
                Lottie.asset(
                  AppAnimationAssets.loading,
                  height: 70.r,
                ),
                SizedBox(height: 15.h),
              ],
            ),
          );
        }
        if (tripDataService.trip == null) return Container();
        Trip trip = tripDataService.trip!;
        return Column(
          children: [
            ticketItem(trip),
            SizedBox(height: 15.h),
          ],
        );
      },
    );
  }

  Widget ticketItem(Trip trip) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      child: TripItem(
        title: trip.title,
        trip: trip,
        state: TripItemExpandedState.less,
        backgroundColor: trip.backgroundColor,
        textColor: trip.textColor,
        onPressed: () {
          Get.toNamed(Routes.TICKET_DETAIL, arguments: {'trip': trip});
        },
      ),
    );
  }
}
