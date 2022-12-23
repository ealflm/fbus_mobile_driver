import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../core/values/app_animation_assets.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/font_weights.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/ticket_item.dart';
import '../../../data/models/student_trip_model.dart';
import '../../../routes/app_pages.dart';
import 'home_ticket_data_service.dart';
import 'statistic_data_service.dart';

class HomeController extends GetxController {
  HomeTicketDataService ticketDataService = Get.find<HomeTicketDataService>();
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
                  'Thống kê theo tháng',
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
                        '${statisticDataService.statistic?.studentTripCount ?? 0} vé',
                        'Đã đặt'),
                    _summarizeLabel(
                        '${(statisticDataService.statistic?.studentTripNotUseCount ?? 0)} vé',
                        'Đã quét'),
                    _summarizeLabel(
                        '${statisticDataService.statistic?.distance ?? 0} km',
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
        if (ticketDataService.isLoading) {
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
        if (ticketDataService.ticket == null) return Container();
        Ticket ticket = ticketDataService.ticket!;
        return Column(
          children: [
            ticketItem(
              ticket,
              title: ticket.status == 1 ? 'Chuyến đi gần nhất' : 'Đang diễn ra',
              backgroundColor:
                  ticket.status == 1 ? AppColors.purple500 : AppColors.green,
              textColor: ticket.status == 1 ? AppColors.white : AppColors.white,
            ),
            SizedBox(height: 15.h),
          ],
        );
      },
    );
  }

  Widget ticketItem(
    Ticket ticket, {
    String title = '',
    Color backgroundColor = AppColors.white,
    Color textColor = AppColors.softBlack,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      child: TicketItem(
        title: title,
        ticket: ticket,
        state: TicketItemExpandedState.less,
        backgroundColor: backgroundColor,
        textColor: textColor,
        onPressed: () {
          Get.toNamed(Routes.TICKET_DETAIL, arguments: {'ticket': ticket});
        },
      ),
    );
  }
}
