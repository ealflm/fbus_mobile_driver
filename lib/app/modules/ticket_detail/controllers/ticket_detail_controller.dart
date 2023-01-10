import 'package:flutter/material.dart' hide Feedback;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/utils/map_utils.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_svg_assets.dart';
import '../../../core/values/font_weights.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/shared.dart';
import '../../../core/widget/trip_item.dart';
import '../../../data/models/station_model.dart';
import '../../../data/models/student_count_model.dart';
import '../../../data/models/student_trip_model.dart';
import '../../../data/models/trip_model.dart';
import '../../home/controllers/home_ticket_data_service.dart';
import '../../map/hyper_map_controller.dart';

class TicketDetailController extends BaseController {
  final Rx<Trip?> _trip = Rx<Trip?>(null);
  Trip? get trip => _trip.value;
  set trip(Trip? value) {
    _trip.value = value;
  }

  final Rx<String?> _selectedStationId = Rx<String?>(null);
  String? get selectedStationId => _selectedStationId.value;
  set selectedStationId(String? value) {
    _selectedStationId.value = value;
  }

  Station? get selectedStation {
    Station? result;
    for (Station station in trip?.route?.stations ?? []) {
      if (station.id == selectedStationId) {
        result = station;
        break;
      }
    }
    return result;
  }

  final Rx<List<LatLng>> _points = Rx<List<LatLng>>([]);
  List<LatLng> get points => _points.value;
  set points(List<LatLng> value) {
    _points.value = value;
  }

  final Rx<Map<String, int>> _studentNumberInStations =
      Rx<Map<String, int>>({});
  Map<String, int> get studentNumberInStations =>
      _studentNumberInStations.value;
  set studentNumberInStations(Map<String, int> value) {
    _studentNumberInStations.value = value;
  }

  HyperMapController hyperMapController = HyperMapController();

  HomeTripDataService homeTripDataService = Get.find<HomeTripDataService>();

  @override
  void onInit() {
    Map<String, dynamic> arg = {};
    if (Get.arguments != null) {
      arg = Get.arguments as Map<String, dynamic>;
    }
    if (arg.containsKey('trip')) {
      trip = arg['trip'];
      selectedStationId = trip?.route?.startStation?.id;
    } else {
      showToast('Đã có lỗi xảy ra');
      Get.back();
    }
    super.onInit();
  }

  void onMapReady() async {
    await hyperMapController.refreshCurrentLocation();
    await fetchPoints();
    fetchStudentNumber();
    moveScreenToTicketPolyline();
  }

  Future<void> fetchStudentNumber() async {
    if (trip?.id == null) return;
    var studentCountsService = repository.getStudentCounts(trip?.id ?? '');
    List<StudentCount> studentCounts = [];

    await callDataService(studentCountsService, onSuccess: (response) {
      studentCounts = response;
    });

    Map<String, int> result = {};

    for (StudentCount studentCount in studentCounts) {
      if (studentCount.station?.id != null) {
        result[studentCount.station?.id ?? ''] = studentCount.count ?? 0;
      }
    }

    studentNumberInStations = result;
  }

  Future<void> fetchPoints() async {
    points = await goongRepository
        .getRoutePoints(trip?.route?.stationLocations ?? []);
  }

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
    return Obx(() {
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
            ticketItem(trip!),
          ],
        ),
      );
    });
  }

  Widget ticketItem(Trip trip) {
    if (trip.id == homeTripDataService.trip?.id) {
      trip.isCurrent = true;
    }

    List<Widget> stationList = [];
    for (Station station in trip.route?.stations ?? []) {
      stationList
          .add(_stationItem(station, trip.backgroundColor, trip.textColor));
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      child: TripItem(
        title: trip.title,
        trip: trip,
        state: TripItemExpandedState.more,
        backgroundColor: trip.backgroundColor,
        textColor: trip.textColor,
        stationList: stationList,
      ),
    );
  }

  Widget _stationItem(Station station, Color backgroundColor, Color textColor) {
    return Obx(() {
      String description = '';
      var studentNumber = studentNumberInStations[station.id];
      if (studentNumber != null) {
        description = '$studentNumber người';
      }

      return _selectItem(
        onPressed: () {
          selectedStationId = station.id;
          moveScreenToSelectedStation();
        },
        isSelected: station.id == selectedStationId,
        name: station.name,
        description: description,
        backgroundColor: backgroundColor,
        textColor: textColor,
      );
    });
  }

  Widget _selectItem({
    Function()? onPressed,
    bool isSelected = false,
    String? name,
    String? description,
    Color backgroundColor = AppColors.white,
    Color textColor = AppColors.softBlack,
  }) {
    return Column(
      children: [
        Material(
          child: InkWell(
            onTap: onPressed,
            child: Container(
              color: isSelected ? AppColors.gray.withOpacity(0.3) : null,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              width: double.infinity,
              height: 40.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '$name',
                      overflow: TextOverflow.ellipsis,
                      style: subtitle2.copyWith(
                        fontWeight: isSelected
                            ? FontWeights.medium
                            : FontWeights.regular,
                      ),
                    ),
                  ),
                  if (description != null)
                    Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          description,
                          style: subtitle2.copyWith(
                            fontWeight: FontWeights.regular,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 1,
        ),
      ],
    );
  }

  Widget stationMarkers() {
    return Obx(
      () {
        List<Marker> markers = [];

        for (Station station in trip?.route?.stations ?? []) {
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
              points: points,
            ),
          ],
        );
      },
    );
  }

  Widget selectedStationMarker() {
    return Obx(
      () {
        int type = 0;
        Station? station = selectedStation;
        if (station == null) return Container();
        if (station.id == trip?.route?.startStation?.id) {
          type = 1;
        } else if (station.id == trip?.route?.endStation?.id) {
          type = 2;
        }
        return MarkerLayer(
          markers: [
            Marker(
              width: 200.r,
              height: 120.r,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${station.name}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: body2.copyWith(
                              color: AppColors.softBlack,
                            ),
                          ),
                          Text(
                            'Số người cần đón: ${studentNumberInStations[station.id] ?? 0}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: caption.copyWith(
                              fontWeight: FontWeights.medium,
                              color: AppColors.softBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SvgPicture.asset(
                      type == 1
                          ? AppSvgAssets.busIconFrom
                          : type == 2
                              ? AppSvgAssets.busIconTo
                              : AppSvgAssets.busIcon,
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
    List<LatLng> points = this.points;

    if (points.isNotEmpty) {
      var bounds = LatLngBounds();
      for (LatLng point in points) {
        bounds.extend(point);
      }

      bounds = MapUtils.padBottom(bounds, 0.3, 1);

      hyperMapController.centerZoomFitBounds(bounds);
    }
  }

  void moveScreenToSelectedStation() {
    if (selectedStation == null) return;
    if (selectedStation?.location != null) {
      var bounds = LatLngBounds();
      bounds.extend(selectedStation?.location!);

      bounds = MapUtils.padBottomSinglePoint(bounds, 0.03, 0.042);

      hyperMapController.centerZoomFitBounds(bounds);
    }
  }
}

enum TicketState { feedback, hasFeedbacked, disabledCancel, cancel }
