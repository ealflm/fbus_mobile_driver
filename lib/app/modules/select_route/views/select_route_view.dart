import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/utils/hyper_app_settings.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/widget/status_bar.dart';
import '../controllers/select_route_controller.dart';

class SelectRouteView extends GetView<SelectRouteController> {
  const SelectRouteView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              mapController: controller.hyperMapController.mapController,
              options: MapOptions(
                interactiveFlags:
                    InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                center: LatLng(10.841411, 106.809936),
                zoom: 9,
                minZoom: 3,
                maxZoom: 18.4,
                slideOnBoundaries: true,
                onMapReady: controller.onMapReady,
              ),
              children: [
                TileLayer(
                  urlTemplate: AppSettings.get('mapboxUrlTemplate'),
                  additionalOptions: {
                    "access_token": AppSettings.get('mapboxAccessToken'),
                  },
                ),
                Stack(
                  children: [
                    controller.routesPolyline(),
                    controller.selectedRoutePolyline(),
                    controller.selectedRouteTripPolyline(),
                    _currentLocationMarker(),
                    controller.stationMarkers(),
                    controller.selectedRouteStationMarkers(),
                    controller.untouchableStation(),
                    controller.selectedStationMarker(),
                    // _routes(),
                    // _busStationMarker(),
                    // _currentLocationMarker(),
                  ],
                ),
              ],
            ),
            _top(),
            _bottom(),
          ],
        ),
      ),
    );
  }

  Widget _top() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 10.h, left: 15.w),
        child: ElevatedButton(
          onPressed: () async {
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: AppColors.white,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.all(0),
            minimumSize: Size(40.r, 40.r),
          ),
          child: SizedBox(
            height: 40.r,
            width: 40.r,
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 18.r,
              color: AppColors.gray,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottom() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: 0.45.sh,
            ),
            margin: EdgeInsets.only(
              bottom: 15.h,
              left: 15.w,
              right: 15.w,
            ),
            padding: EdgeInsets.only(
              top: 10.h,
              bottom: 10.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(9.r),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: controller.bottomDetail(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      controller.backButton(),
                      controller.nextButton(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _currentLocationMarker() {
    return IgnorePointer(
      child: CurrentLocationLayer(
        positionStream:
            controller.hyperMapController.geolocatorPositionStream(),
        style: LocationMarkerStyle(
          markerDirection: MarkerDirection.heading,
          showHeadingSector: false,
          markerSize: Size(60.r, 60.r),
          marker: Stack(
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 0),
                        blurRadius: 4,
                        spreadRadius: 0,
                        color: AppColors.black.withOpacity(0.4),
                      ),
                    ],
                  ),
                  height: 26.r,
                  width: 26.r,
                  child: DefaultLocationMarker(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 2.r),
                      child: Center(
                        child: Icon(
                          Icons.navigation,
                          color: Colors.white,
                          size: 16.r,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
