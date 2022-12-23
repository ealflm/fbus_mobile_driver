import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../account/views/account_view.dart';
import '../../home/controllers/home_ticket_data_service.dart';
import '../../home/controllers/statistic_data_service.dart';
import '../../home/views/home_view.dart';
import '../../notification/views/notification_view.dart';
import '../../ticket/views/ticket_view.dart';

class MainController extends GetxController {
  @override
  void onInit() {
    Get.put(HomeTicketDataService());
    Get.put(StatisticDataService());
    Map<String, dynamic> arg = {};
    if (Get.arguments != null) {
      arg = Get.arguments as Map<String, dynamic>;
    }
    if (arg.containsKey('tabIndex')) {
      currentTab.value = arg['tabIndex'];
    }
    super.onInit();
  }

  var currentTab = 0.obs;
  final List<Widget> screens = [
    const HomeView(),
    const TicketView(),
    const NotificationView(),
    const AccountView(),
  ];

  void changeTab(int index) {
    currentTab.value = index;
  }
}
