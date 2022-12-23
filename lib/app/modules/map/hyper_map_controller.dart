import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:restart_app/restart_app.dart';

import '../../core/values/app_values.dart';

class HyperMapController extends GetxController
    with GetTickerProviderStateMixin {
  MapController mapController = MapController();
  LatLng? currentLocation;

  HyperMapController() {
    _checkPermission();
  }

  /// Refresh current location.
  ///
  /// Using for first run.
  Future<void> refreshCurrentLocation() async {
    await _checkPermission();
    Position position = await Geolocator.getCurrentPosition();
    currentLocation = LatLng(position.latitude, position.longitude);
  }

  /// Moving to current location.
  void moveToCurrentLocation() async {
    if (currentLocation != null) {
      _animatedMapMove(currentLocation!, zoom: AppValues.focusZoomLevel);
    } else {
      debugPrint('Current location is invalid');
    }
  }

  /// Zoom fit bounds
  void centerZoomFitBounds(LatLngBounds bounds, {double? zoom}) {
    var centerZoom = mapController.centerZoomFitBounds(bounds);
    _animatedMapMove(centerZoom.center, zoom: zoom ?? centerZoom.zoom);
  }

  /// Move to location
  void moveToLocation(LatLng location) {
    _animatedMapMove(location);
  }

  /// Moving to current location.
  void moveToCurrentLocationWithoutAnimation() async {
    if (currentLocation != null) {
      mapController.move(currentLocation!, AppValues.focusZoomLevel);
    } else {
      debugPrint('Current location is invalid');
    }
  }

  Stream<LocationMarkerPosition> geolocatorPositionStream() {
    return (Geolocator.getPositionStream()).map((Position position) {
      currentLocation = LatLng(position.latitude, position.longitude);
      return LocationMarkerPosition(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
      );
    });
  }

  Future<void> _checkPermission() async {
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

  /// Moving to [location] with animation.
  void _animatedMapMove(LatLng location, {double? zoom}) {
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: location.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: location.longitude);
    final zoomTween = Tween<double>(
        begin: mapController.zoom, end: zoom ?? mapController.zoom);

    var animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    Animation<double> animation = CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);

    animationController.addListener(() {
      try {
        mapController.move(
            LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
            zoomTween.evaluate(animation));
      } catch (e) {
        animationController.dispose();
        return;
      }
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.dispose();
      } else if (status == AnimationStatus.dismissed) {
        animationController.dispose();
      }
    });

    animationController.forward();
  }
}
