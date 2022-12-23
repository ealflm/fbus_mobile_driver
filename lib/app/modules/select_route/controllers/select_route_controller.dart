import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart' hide Marker;

import '../../../core/utils/map_utils.dart';
import '../../../core/values/app_animation_assets.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_svg_assets.dart';
import '../../../core/values/font_weights.dart';
import '../../../core/values/text_styles.dart';
import '../../../data/models/station_model.dart';
import '../../map/hyper_map_controller.dart';
import 'route_data_service.dart';
import 'select_mode_controller.dart';

class SelectRouteController extends GetxController {
  HyperMapController hyperMapController = HyperMapController();
  RouteDataService routeDataService = RouteDataService();
  SelectModeController selectModeController = SelectModeController();

  @override
  void onInit() async {
    await routeDataService.fetchRoutes();
    moveScreenToSelectedRoute();
    super.onInit();
  }

  void onMapReady() async {
    await hyperMapController.refreshCurrentLocation();
  }

  Widget routesPolyline() {
    return Obx(
      () {
        List<Polyline> polylines = [];

        for (var route in routeDataService.routes.values) {
          polylines.add(
            Polyline(
              color: AppColors.indicator,
              borderColor: AppColors.caption,
              strokeWidth: 4.r,
              borderStrokeWidth: 3.r,
              points: route.points ?? [],
            ),
          );
        }

        return PolylineLayer(
          polylineCulling: true,
          // saveLayers: true,
          polylines: polylines,
        );
      },
    );
  }

  Widget selectedRoutePolyline() {
    return Obx(
      () {
        List<LatLng> points = routeDataService.selectedRoute?.points ?? [];

        if (points.isEmpty) return Container();

        return PolylineLayer(
          polylineCulling: true,
          saveLayers: true,
          polylines: [
            Polyline(
              color: AppColors.blue,
              borderColor: AppColors.darkBlue,
              strokeWidth: 4.r,
              borderStrokeWidth: 3.r,
              points: points,
            ),
          ],
        );
      },
    );
  }

  Widget selectedRouteTripPolyline() {
    return Obx(
      () {
        List<LatLng> points = routeDataService.selectedTrip.points ?? [];

        if (points.isEmpty) return Container();

        return PolylineLayer(
          polylineCulling: true,
          saveLayers: true,
          polylines: [
            Polyline(
              // color: AppColors.purpleEnd,
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

  Widget stationMarkers() {
    return Obx(
      () {
        List<Marker> markers = [];

        for (Station station in routeDataService.stations.values) {
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

  Widget selectedRouteStationMarkers() {
    return Obx(
      () {
        List<Marker> markers = [];

        for (Station station
            in routeDataService.selectedRoute?.stations ?? []) {
          markers.add(
            Marker(
              width: 80.r,
              height: 80.r,
              point: station.location ?? LatLng(0, 0),
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(30.r),
                  child: SvgPicture.asset(
                    AppSvgAssets.busIcon,
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

  Widget selectedStationMarker() {
    return Obx(
      () {
        if (routeDataService.selectedStation == null) return Container();
        Station station = routeDataService.selectedStation!;
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
                      routeDataService.startStation != null
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

  Widget untouchableStation() {
    return Obx(
      () {
        Station station;
        if (routeDataService.startStation != null) {
          station = routeDataService.startStation!;
        } else if (routeDataService.endStation != null) {
          station = routeDataService.endStation!;
        } else {
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
                      routeDataService.startStation != null
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

  Widget routeSelect() {
    return Obx(
      () {
        List<Widget> lines = [];

        for (var route in routeDataService.routes.values) {
          lines.add(
            selectItem(
              name: route.name,
              isSelected: route.id == routeDataService.selectedRouteId,
              onPressed: () {
                routeDataService.selectRoute(route.id ?? '');
                moveScreenToSelectedRoute();
              },
            ),
          );
        }

        return routeDataService.isLoading
            ? Center(
                child: Lottie.asset(AppAnimationAssets.dot, height: 50.h),
              )
            : Column(
                children: [
                  Text('Chọn tuyến', style: subtitle2),
                  SizedBox(
                    height: 3.h,
                  ),
                  const Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: lines,
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              );
      },
    );
  }

  Widget stationSelect() {
    return Obx(
      () {
        List<Widget> lines = [];

        for (Station station
            in routeDataService.selectedRoute?.stations ?? []) {
          lines.add(
            selectItem(
              name: station.name,
              isSelected: station.id == routeDataService.selectedStationId,
              description: routeDataService.startStation != null
                  ? 'Trạm xuống'
                  : 'Trạm lên',
              onPressed: () {
                routeDataService.selectStation(station.id ?? '');
                routeDataService.selectedTrip
                    .updatePoints(moveScreenToSelectedRouteTrip);
              },
            ),
          );
        }

        if (routeDataService.startStation != null) {
          lines.first = selectedItem(
              name: routeDataService.startStation?.name,
              description: 'Trạm lên');
        } else {
          lines.last = selectedItem(
              name: routeDataService.endStation?.name,
              description: 'Trạm xuống');
        }

        return Column(
          children: [
            Text(
              routeDataService.startStation != null
                  ? 'Chọn trạm xuống'
                  : 'Chọn trạm lên',
              style: subtitle2,
            ),
            SizedBox(
              height: 3.h,
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: lines,
                ),
              ),
            ),
            const Divider(),
          ],
        );
      },
    );
  }

  Widget selectItem(
      {Function()? onPressed,
      bool isSelected = false,
      String? name,
      String? description}) {
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
                              : FontWeights.regular),
                    ),
                  ),
                  if (isSelected && description != null)
                    Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          description,
                          style: subtitle2.copyWith(
                              fontWeight: FontWeights.regular),
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

  Widget selectedItem({String? name, String? description}) {
    return Column(
      children: [
        Container(
          color: AppColors.gray.withOpacity(0.3),
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
                    fontWeight: FontWeights.medium,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                '$description',
                style: subtitle2.copyWith(
                  fontWeight: FontWeights.regular,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 1,
        ),
      ],
    );
  }

  Widget bottomDetail() {
    return Obx(
      (() {
        return selectModeController.mode == SelectMode.route
            ? routeSelect()
            : stationSelect();
      }),
    );
  }

  void moveScreenToSelectedRoute() {
    List<LatLng> points = routeDataService.selectedRoute?.points ?? [];

    if (points.isNotEmpty) {
      var bounds = LatLngBounds();
      for (LatLng point in points) {
        bounds.extend(point);
      }

      bounds = MapUtils.padTop(bounds, 0.3, 0.92);

      hyperMapController.centerZoomFitBounds(bounds);
    }
  }

  void moveScreenToSelectedRouteTrip() {
    List<LatLng> points = routeDataService.selectedTrip.points ?? [];

    if (points.isNotEmpty) {
      var bounds = LatLngBounds();
      for (LatLng point in points) {
        bounds.extend(point);
      }

      bounds = MapUtils.padTop(bounds, 0.3, 0.92);

      hyperMapController.centerZoomFitBounds(bounds);
    }
  }

  Widget backButton() {
    return Obx(
      (() {
        return selectModeController.canBack()
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                onPressed: () {
                  selectModeController.back();
                  routeDataService.selectStation('');
                  routeDataService.selectedTrip.clearSelection();
                  moveScreenToSelectedRoute();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.navigate_before,
                      color: AppColors.white,
                      size: 20.r,
                    ),
                    Text(
                      'Trở lại',
                      style: subtitle2.copyWith(color: AppColors.white),
                    ),
                    SizedBox(
                      width: 9.w,
                    ),
                  ],
                ),
              )
            : Container();
      }),
    );
  }

  Widget nextButton() {
    return Obx(
      (() {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
          onPressed: routeDataService.isLoading ||
                  (selectModeController.mode == SelectMode.station &&
                      routeDataService.selectedStation == null)
              ? null
              : () {
                  selectModeController.next(routeDataService.selectedTrip);
                },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 9.w,
              ),
              Text(
                'Tiếp tục',
                style: subtitle2.copyWith(color: AppColors.white),
              ),
              Icon(
                Icons.navigate_next,
                color: AppColors.white,
                size: 20.r,
              ),
            ],
          ),
        );
      }),
    );
  }
}
