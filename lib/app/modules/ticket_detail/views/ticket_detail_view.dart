import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_app_settings/hyper_app_settings.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/widget/status_bar.dart';
import '../controllers/ticket_detail_controller.dart';

class TicketDetailView extends GetView<TicketDetailController> {
  const TicketDetailView({Key? key}) : super(key: key);
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
                    // controller.routesPolyline(),
                    controller.ticketPolyline(),
                    _currentLocationMarker(),
                    controller.stationMarkers(),
                    controller.untouchableStation(),
                    controller.selectedStationMarker(),
                  ],
                ),
              ],
            ),
            _top(),
            controller.ticketDetail(),
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
          onPressed: () {
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
