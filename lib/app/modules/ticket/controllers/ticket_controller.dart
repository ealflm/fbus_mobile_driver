import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

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

  HomeTripDataService homeTripDataService = Get.find<HomeTripDataService>();

  Widget pastTickets() {
    return Obx(
      () {
        List<Widget> trips = [];

        if (tripDataService.isLoading) {
          for (int i = 0; i < 7; i++) {
            trips.add(
              Shimmer.fromColors(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.shimmerHighlightColor,
                child: ticketItem(Trip()),
              ),
            );
            trips.add(SizedBox(
              height: 10.h,
            ));
          }
        } else {
          for (Trip trip in tripDataService.pastTrips ?? []) {
            trips.add(ticketItem(trip));
            trips.add(SizedBox(
              height: 10.h,
            ));
          }

          if (trips.isEmpty) {
            return Center(child: Text('Không có chuyến đi', style: body2));
          }
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
        List<Widget> trips = [];

        if (tripDataService.isLoading) {
          for (int i = 0; i < 7; i++) {
            trips.add(
              Shimmer.fromColors(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.shimmerHighlightColor,
                child: ticketItem(Trip()),
              ),
            );
            trips.add(SizedBox(
              height: 10.h,
            ));
          }
        } else {
          for (Trip trip in tripDataService.futureTrips ?? []) {
            trips.add(ticketItem(trip));
            trips.add(SizedBox(
              height: 10.h,
            ));
          }

          if (trips.isEmpty) {
            return Center(child: Text('Không có chuyến đi', style: body2));
          }
        }

        return Column(
          children: trips,
        );
      },
    );
  }

  Widget ticketItem(Trip trip) {
    if (trip.id == homeTripDataService.trip?.id) {
      trip.isCurrent = true;
    }
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
          if (trip.id != null) {
            Get.toNamed(Routes.TICKET_DETAIL, arguments: {'trip': trip});
          }
        },
      ),
    );
  }
}
