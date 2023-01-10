import 'dart:async';

import 'package:fbus_mobile_driver/app/core/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:restart_app/restart_app.dart';

import '../../data/repository/repository.dart';
import '../../modules/map/hyper_map_controller.dart';
import 'auth_service.dart';

class TrackingLocationService extends BaseController {
  static final TrackingLocationService _instance =
      TrackingLocationService._internal();
  static TrackingLocationService get instance => _instance;
  TrackingLocationService._internal();

  static LatLng? currentLocation;

  static HyperMapController mapController = HyperMapController();

  static Timer? timerObjVar;
  static Timer? timerObj;

  static void init() {
    timerObj = Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
      timerObjVar = timer;
      sendLocation();
    });
  }

  static void stop() {
    if (timerObjVar != null) {
      timerObjVar!.cancel();
      timerObjVar = null;
    }
    if (timerObj != null) {
      timerObj!.cancel();
      timerObj = null;
    }
  }

  static Future<void> sendLocation() async {
    Repository repository = Get.find(tag: (Repository).toString());
    final String driverId = AuthService.driver?.id ?? '';

    await refreshCurrentLocation();

    var registerNotificationService = repository.sendLocation(
      driverId,
      currentLocation,
    );

    try {
      await registerNotificationService;
      debugPrint('Tracking Location: Location sent');
    } catch (error) {
      debugPrint('Tracking Location: Can not send location');
    }
  }

  static Future<void> refreshCurrentLocation() async {
    await _checkPermission();
    Position position = await Geolocator.getCurrentPosition();
    currentLocation = LatLng(position.latitude, position.longitude);
  }

  static Future<void> _checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      } else {
        Restart.restartApp();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }
}
