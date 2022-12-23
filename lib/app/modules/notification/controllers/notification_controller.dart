import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/utils/auth_service.dart';
import '../../../core/values/app_animation_assets.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '../../../data/models/notification_model.dart';
import '../widgets/transaction_item.dart';

class NotificationController extends BaseController {
  final Rx<bool> _isLoading = Rx<bool>(false);
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  final Rx<List<Notification>> _notifications = Rx<List<Notification>>([]);
  List<Notification> get notifications => _notifications.value;
  set notifications(List<Notification> value) {
    _notifications.value = value;
  }

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  void fetchNotifications() async {
    isLoading = true;

    List<Notification> result = [];

    String studentId = AuthService.student?.id ?? '';
    var fetchNotificationsDataService = repository.getNotifications(studentId);

    await callDataService(
      fetchNotificationsDataService,
      onSuccess: (List<Notification> response) {
        result = response;
        debugPrint('Nam: $result');
      },
      onError: (exception) {},
    );

    result.sort(((a, b) {
      return b.createdDate?.compareTo(a.createdDate!) ?? 0;
    }));

    bool flag = false;
    for (Notification item in result) {
      if (compare(item.createdDate, DateTime.now()) && flag == false) {
        item.filter = 0;
        flag = true;
      } else if (!compare(item.createdDate, DateTime.now()) && flag == true) {
        item.filter = 1;
        break;
      }
    }

    notifications = result;
    isLoading = false;
  }

  bool compare(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget notificationList() {
    return Obx(
      () {
        if (isLoading) {
          return Center(
            child: Lottie.asset(
              AppAnimationAssets.loading,
              height: 100.r,
            ),
          );
        }

        return notifications.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      var item = notifications[index];
                      if (item.filter == 0) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 18.w, right: 18.w, top: 10.h),
                              child: Row(
                                children: [
                                  Text(
                                    'Hôm nay',
                                    style: h6.copyWith(
                                        color: AppColors.softBlack,
                                        fontSize: 18.sp),
                                  ),
                                ],
                              ),
                            ),
                            NotificationItem(
                              model: item,
                            ),
                          ],
                        );
                      } else if (item.filter == 1) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 18.w, right: 18.w, top: 10.h),
                              child: Row(
                                children: [
                                  Text(
                                    'Trước đó',
                                    style: h6.copyWith(
                                        color: AppColors.softBlack,
                                        fontSize: 18.sp),
                                  ),
                                ],
                              ),
                            ),
                            NotificationItem(
                              model: item,
                            ),
                          ],
                        );
                      }
                      return NotificationItem(
                        model: item,
                      );
                    }),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Text(
                      'Không có thông báo',
                      style: body2.copyWith(
                        color: AppColors.description,
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }
}
