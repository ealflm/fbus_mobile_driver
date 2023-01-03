import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../core/values/app_animation_assets.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/trip_item.dart';
import '../../../data/models/trip_model.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_ticket_data_service.dart';
import '../views/tab_views/future_ticket_view.dart';
import '../views/tab_views/past_ticket_view.dart';
import 'trip_data_service.dart';

class TicketController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final tabs = [
    const Tab(text: 'Sắp tới'),
    const Tab(text: 'Trước đó'),
  ];

  Rx<int> tabIndex = 0.obs;
  final List<Widget> screens = [
    const FutureTicketView(),
    const PastTicketView(),
  ];

  void changeTab(int index) {
    tabController.index = index;
    tabIndex.value = index;
  }

  TripDataService tripDataService = TripDataService();

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    tripDataService.fetch();
    super.onInit();
  }

  HomeTicketDataService homeTicketDataService =
      Get.find<HomeTicketDataService>();

  Widget pastTickets() {
    return Obx(
      () {
        if (tripDataService.isLoading) {
          return Center(
            child: Lottie.asset(
              AppAnimationAssets.loading,
              height: 100.r,
            ),
          );
        }

        List<Widget> trips = [];

        for (Trip trip in tripDataService.pastTrips ?? []) {
          trips.add(ticketItem(trip));
          trips.add(SizedBox(
            height: 10.h,
          ));
        }

        if (trips.isEmpty) {
          return Center(child: Text('Không có chuyến đi', style: body2));
        }

        return Column(
          children: trips,
        );
      },
    );
  }

  Widget futureTickets() {
    return Obx(
      () {
        if (tripDataService.isLoading) {
          return Center(
            child: Lottie.asset(
              AppAnimationAssets.loading,
              height: 100.r,
            ),
          );
        }

        List<Widget> trips = [];

        for (Trip trip in tripDataService.futureTrips ?? []) {
          trips.add(ticketItem(trip));
          trips.add(SizedBox(
            height: 10.h,
          ));
        }

        if (trips.isEmpty) {
          return Center(child: Text('Không có chuyến đi', style: body2));
        }

        return Column(
          children: trips,
        );
      },
    );
  }

  Widget ticketItem(Trip trip) {
    Color backgroundColor = AppColors.white;
    Color textColor = AppColors.softBlack;

    if (trip.title == 'Đã qua') {
      backgroundColor = AppColors.caption;
      textColor = AppColors.white;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      child: TripItem(
        title: trip.title,
        trip: trip,
        state: TripItemExpandedState.less,
        backgroundColor: backgroundColor,
        textColor: textColor,
        onPressed: () {
          Get.toNamed(Routes.TICKET_DETAIL, arguments: {'trip': trip});
        },
      ),
    );
  }
}
