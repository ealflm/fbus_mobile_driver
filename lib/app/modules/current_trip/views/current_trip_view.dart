import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_app_settings/hyper_app_settings.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/font_weights.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/shared.dart';
import '../../../core/widget/status_bar.dart';
import '../../../routes/app_pages.dart';
import '../controllers/current_trip_controller.dart';

class CurrentTripView extends GetView<CurrentTripController> {
  const CurrentTripView({Key? key}) : super(key: key);
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
                _currentLocationMarker(),
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
        padding: EdgeInsets.only(
          top: 15.h,
          left: 15.w,
          right: 15.w,
        ),
        alignment: Alignment.topCenter,
        child: PhysicalModel(
          borderRadius: BorderRadius.circular(50.r),
          color: Colors.white,
          elevation: 2,
          child: InkWell(
            onTap: () {
              Get.toNamed(Routes.SEARCH);
            },
            child: Ink(
              height: 42.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
                color: AppColors.surface,
              ),
              child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  errorStyle: caption,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  hintText: 'Tìm kiếm',
                  prefixIcon: SizedBox(
                    height: 22.w,
                    width: 22.w,
                    child: Icon(
                      Icons.search,
                      size: 22.r,
                      color: AppColors.lightBlack,
                    ),
                  ),
                  hintStyle: subtitle1.copyWith(
                    color: AppColors.description,
                  ),
                ),
              ),
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
                  onPressed:
                      controller.hyperMapController.moveToCurrentLocation,
                  child: const Icon(
                    Icons.my_location,
                    color: AppColors.lightBlack,
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              bottom: 15.h,
              left: 15.w,
              right: 15.w,
            ),
            padding: EdgeInsets.only(
              top: 15.h,
              bottom: 15.h,
              left: 18.w,
              right: 18.w,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(9.r),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Khoảng cách',
                          style: body2.copyWith(color: AppColors.lightBlack),
                        ),
                        RichText(
                          text: TextSpan(
                            text: '20',
                            style: h4.copyWith(fontWeight: FontWeights.medium),
                            children: [
                              TextSpan(
                                text: 'km',
                                style: h6.copyWith(
                                    fontWeight: FontWeights.regular),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 3.h),
                        RichText(
                          text: TextSpan(
                            text: 'Thời gian: ',
                            style: body2.copyWith(color: AppColors.lightBlack),
                            children: [
                              TextSpan(
                                text: '15 phút',
                                style: subtitle2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder()),
                      onPressed: () {
                        Get.toNamed(Routes.SCAN);
                      },
                      child: Row(
                        children: [
                          Text(
                            'Quét QR',
                            style: subtitle2,
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.qr_code,
                            color: AppColors.softBlack,
                            size: 20.r,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    station(
                      title: 'Vinhomes grand park',
                      time: '07:00',
                      iconColor: AppColors.green,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 11.r),
                      child: Column(
                        children: [
                          dot(),
                          SizedBox(height: 5.h),
                          dot(),
                          SizedBox(height: 5.h),
                          dot(),
                          SizedBox(height: 9.h),
                        ],
                      ),
                    ),
                    station(
                      title: 'FPT University',
                      time: '07:35',
                      iconColor: AppColors.secondary,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  CurrentLocationLayer _currentLocationMarker() {
    return CurrentLocationLayer(
      positionStream: controller.hyperMapController.geolocatorPositionStream(),
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
    );
  }
}
