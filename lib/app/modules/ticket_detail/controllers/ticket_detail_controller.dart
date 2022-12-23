import 'package:flutter/material.dart' hide Feedback;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/utils/map_utils.dart';
import '../../../core/utils/notification_service.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_svg_assets.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/hyper_dialog.dart';
import '../../../core/widget/shared.dart';
import '../../../core/widget/ticket_item.dart';
import '../../../data/models/station_model.dart';
import '../../../data/models/student_trip_model.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_ticket_data_service.dart';
import '../../map/hyper_map_controller.dart';

class TicketDetailController extends BaseController {
  final Rx<Ticket?> _ticket = Rx<Ticket?>(null);
  Ticket? get ticket => _ticket.value;
  set ticket(Ticket? value) {
    _ticket.value = value;
  }

  HyperMapController hyperMapController = HyperMapController();

  @override
  void onInit() {
    Map<String, dynamic> arg = {};
    if (Get.arguments != null) {
      arg = Get.arguments as Map<String, dynamic>;
    }
    if (arg.containsKey('ticket')) {
      ticket = arg['ticket'];
    } else {
      showToast('Đã có lỗi xảy ra');
      Get.back();
    }
    super.onInit();
  }

  void onMapReady() async {
    await hyperMapController.refreshCurrentLocation();
    moveScreenToTicketPolyline();
  }

  HomeTicketDataService homeTicketDataService =
      Get.find<HomeTicketDataService>();

  Future<bool> cancelTrip(Ticket? ticket) async {
    bool result = false;
    String studentTripId = ticket?.id ?? '';
    var cancelTripService = repository.removeTrip(studentTripId);

    await callDataService(cancelTripService, onSuccess: (response) {
      result = true;
    });
    return result;
  }

  Widget ticketDetail() {
    return Obx((() {
      return Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(bottom: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 15.h, right: 15.w),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: AppColors.white,
                      padding: EdgeInsets.all(10.r),
                      minimumSize: Size.zero,
                    ),
                    onPressed: (() {
                      moveScreenToTicketPolyline();
                    }),
                    child: const Icon(
                      Icons.my_location,
                      color: AppColors.lightBlack,
                    ),
                  ),
                ),
              ],
            ),
            ticketItem(ticket?.title ?? ''),
          ],
        ),
      );
    }));
  }

  Widget ticketItem(String title) {
    Color backgroundColor = AppColors.white;
    Color textColor = AppColors.softBlack;
    Ticket? currentTicket = homeTicketDataService.ticket;
    TicketState ticketState = TicketState.disabledCancel;
    Function()? onPressed;
    Widget? buttonChild;
    Feedback? feedback;
    bool hideButton = false;

    if (currentTicket?.id == ticket?.id) {
      if (ticket?.status == 2) {
        backgroundColor = AppColors.green;
        textColor = AppColors.white;
        title = 'Đang diễn ra';
      } else {
        backgroundColor = AppColors.purple500;
        textColor = AppColors.white;
        title = 'Chuyến đi gần nhất';
      }
    }

    if (ticket?.isPassed == true) {
      backgroundColor = AppColors.caption;
      textColor = AppColors.white;
      title = 'Đã sử dụng';
      if (ticket?.rate != null && ticket?.rate != 0) {
        ticketState = TicketState.hasFeedbacked;
      } else {
        ticketState = TicketState.feedback;
      }
    } else {
      if (ticket?.trip!.date != null) {
        DateTime date = ticket!.trip!.date!;
        DateTime now = DateTime.now();

        if (now.add(const Duration(minutes: 30)).compareTo(date) <= 0) {
          ticketState = TicketState.cancel;
        } else {
          ticketState = TicketState.disabledCancel;
        }
      }
    }

    switch (ticketState) {
      case TicketState.feedback:
        onPressed = () {
          Get.toNamed(Routes.FEED_BACK, arguments: {
            'ticket': ticket,
          });
        };
        buttonChild = Text(
          'Đánh giá',
          style: subtitle2.copyWith(color: AppColors.white),
        );
        break;
      case TicketState.disabledCancel:
        buttonChild = Text(
          'Huỷ',
          style: subtitle2.copyWith(color: AppColors.white),
        );
        break;
      case TicketState.cancel:
        onPressed = () {
          HyperDialog.show(
            title: 'Xác nhận',
            content: 'Bạn có chắc chắn muốn huỷ chuyến xe này không?',
            primaryButtonText: 'Xác nhận',
            secondaryButtonText: 'Huỷ',
            primaryOnPressed: () async {
              HyperDialog.showLoading();
              bool isSuccess = await cancelTrip(ticket);
              if (isSuccess) {
                HyperDialog.showSuccess(
                  title: 'Thành công',
                  content: 'Huỷ vé thành công!',
                  barrierDismissible: false,
                  primaryButtonText: 'Trở về trang chủ',
                  secondaryButtonText: 'Đóng',
                  primaryOnPressed: () {
                    Get.offAllNamed(Routes.MAIN);
                  },
                  secondaryOnPressed: () {
                    NotificationService.reloadData();
                    Get.back();
                    Get.back();
                  },
                );
              } else {
                HyperDialog.showFail(
                  title: 'Thất bại',
                  content: 'Đã có lỗi xảy ra trong quá trình huỷ vé',
                  barrierDismissible: false,
                  primaryButtonText: 'Trở về trang chủ',
                  secondaryButtonText: 'Đóng',
                  primaryOnPressed: () {
                    Get.offAllNamed(Routes.MAIN);
                  },
                  secondaryOnPressed: () {
                    Get.back();
                  },
                );
              }
            },
            secondaryOnPressed: () {
              Get.back();
            },
          );
        };
        buttonChild = Text(
          'Huỷ',
          style: subtitle2.copyWith(color: AppColors.white),
        );
        break;
      case TicketState.hasFeedbacked:
        hideButton = true;
        feedback =
            Feedback(rate: ticket?.rate ?? 0, message: ticket?.feedback ?? '');
        break;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      child: TicketItem(
        title: title,
        ticket: ticket!,
        state: TicketItemExpandedState.more,
        backgroundColor: backgroundColor,
        textColor: textColor,
        expandedBackgroundColor: backgroundColor,
        expandedTextColor: textColor,
        button: ElevatedButton(
          style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
          onPressed: onPressed,
          child: buttonChild,
        ),
        feedback: feedback,
        hideButton: hideButton,
      ),
    );
  }

  Widget stationMarkers() {
    return Obx(
      () {
        List<Marker> markers = [];

        for (Station station in ticket?.route?.stations ?? []) {
          markers.add(
            Marker(
              width: 80.r,
              height: 80.r,
              point: station.location ?? LatLng(0, 0),
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(30.r),
                  child: Opacity(
                    opacity: 0.6,
                    child: SvgPicture.asset(
                      AppSvgAssets.busIcon,
                    ),
                  ),
                );
              },
            ),
          );
        }

        return MarkerLayer(
          markers: markers,
        );
      },
    );
  }

  Widget routesPolyline() {
    return Obx(
      () {
        return PolylineLayer(
          polylineCulling: true,
          // saveLayers: true,
          polylines: [
            Polyline(
              color: AppColors.indicator,
              borderColor: AppColors.caption,
              strokeWidth: 4.r,
              borderStrokeWidth: 3.r,
              points: ticket?.route?.points ?? [],
            ),
          ],
        );
      },
    );
  }

  Widget ticketPolyline() {
    return Obx(
      () {
        return PolylineLayer(
          polylineCulling: true,
          // saveLayers: true,
          polylines: [
            Polyline(
              gradientColors: [
                AppColors.purpleStart,
                AppColors.purpleStart,
                AppColors.purpleStart,
                AppColors.purpleStart,
                AppColors.purpleEnd,
              ],
              borderColor: AppColors.purple900,
              strokeWidth: 5.r,
              borderStrokeWidth: 2.r,
              points: ticket?.direction?.points ?? [],
            )
          ],
        );
      },
    );
  }

  Widget untouchableStation() {
    return Obx(
      () {
        Station? station;
        if (ticket?.type == false) {
          station = ticket?.route?.stations?.first;
        } else if (ticket?.type == true) {
          station = ticket?.route?.stations?.last;
        } else {
          return Container();
        }
        if (station == null) {
          return Container();
        }
        return MarkerLayer(
          markers: [
            Marker(
              width: 200.r,
              height: 90.r,
              point: station.location ?? LatLng(0, 0),
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 2),
                            blurRadius: 2,
                            spreadRadius: 0,
                            color: AppColors.black.withOpacity(0.2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${station?.name}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: body2.copyWith(
                          color: AppColors.softBlack,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SvgPicture.asset(
                      ticket?.type == true
                          ? AppSvgAssets.busIconTo
                          : AppSvgAssets.busIconFrom,
                      height: 25.r,
                      width: 25.r,
                    ),
                  ],
                );
              },
            )
          ],
        );
      },
    );
  }

  Widget selectedStationMarker() {
    return Obx(
      () {
        if (ticket?.selectedStation == null) return Container();
        Station station = ticket!.selectedStation!;
        return MarkerLayer(
          markers: [
            Marker(
              width: 200.r,
              height: 90.r,
              point: station.location ?? LatLng(0, 0),
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 2),
                            blurRadius: 2,
                            spreadRadius: 0,
                            color: AppColors.black.withOpacity(0.2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${station.name}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: body2.copyWith(
                          color: AppColors.softBlack,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SvgPicture.asset(
                      ticket?.type == true
                          ? AppSvgAssets.busIconFrom
                          : AppSvgAssets.busIconTo,
                      height: 25.r,
                      width: 25.r,
                    ),
                  ],
                );
              },
            )
          ],
        );
      },
    );
  }

  void moveScreenToTicketPolyline() {
    List<LatLng> points = ticket?.direction?.points ?? [];

    if (points.isNotEmpty) {
      var bounds = LatLngBounds();
      for (LatLng point in points) {
        bounds.extend(point);
      }

      bounds = MapUtils.padTop(bounds, 0.3, 0.7);

      hyperMapController.centerZoomFitBounds(bounds);
    }
  }
}

enum TicketState { feedback, hasFeedbacked, disabledCancel, cancel }
