import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/driver_model.dart';
import '../../routes/app_pages.dart';
import '../base/base_controller.dart';
import '../widget/hyper_dialog.dart';
import 'notification_service.dart';
import 'tracking_location_service.dart';

class AuthService extends BaseController {
  static final AuthService _instance = AuthService._internal();
  static AuthService get instance => _instance;
  AuthService._internal();

  String? _token;

  static final Rx<Driver?> _driver = Rx<Driver?>(null);
  static Driver? get driver => _driver.value;
  static set driver(Driver? value) {
    _driver.value = value;
  }

  /// Get token.
  ///
  /// Return null if token expired.
  static String? get token {
    if (_instance._token != null) {
      Map<String, dynamic> payload = Jwt.parseJwt(_instance._token.toString());

      DateTime? exp =
          DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);

      if (exp.compareTo(DateTime.now()) <= 0) {
        _instance._token = null;
      }
    }
    debugPrint('Bearer token: ${_instance._token}');
    return _instance._token;
  }

  static Future<void> loadDriver() async {
    var prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('driver');
    if (jsonString != null) {
      Map<String, dynamic> driverJson = jsonDecode(jsonString);
      driver = Driver.fromJson(driverJson);
    }
  }

  static Future<void> loadDriverFromToken() async {
    Map<String, dynamic> payload = Jwt.parseJwt(token.toString());

    if (payload.isNotEmpty) {
      driver = Driver.fromJsonCapitalizeFirstLetter(payload);
      setDriver(driver);
    }
  }

  static Future<void> setDriver(Driver? driver) async {
    _driver.value = driver;
    var prefs = await SharedPreferences.getInstance();

    var driverJson = driver?.toJson();
    String jsonString = jsonEncode(driverJson);

    await prefs.setString('driver', jsonString);
  }

  static Future<void> clearDriver() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('driver');
  }

  static Future<void> init() async {
    var prefs = await SharedPreferences.getInstance();
    _instance._token = prefs.getString('token');
    loadDriver();
  }

  static Future<bool> login(String phoneNumber, String password) async {
    bool result = false;

    String? token;
    var loginService = _instance.repository.login(phoneNumber, password);
    await _instance.callDataService(
      loginService,
      onSuccess: (String response) {
        token = response;
        debugPrint('Logged in with token: $token');
        NotificationService.registerNotification();
        TrackingLocationService.init();
      },
      onError: (exception) {
        HyperDialog.show(
          title: 'Đăng nhập thất bại',
          content:
              'Số điện thoại hoặc mã PIN bạn vừa nhập chưa chính xác. Vui lòng thử lại',
          primaryButtonText: 'OK',
        );
      },
    );

    if (token != null) {
      await saveToken(token);
      await loadDriverFromToken();
      result = true;
      Get.offAllNamed(Routes.MAIN);
    }

    return result;
  }

  static Future<void> logout() async {
    NotificationService.unregisterNotification();
    TrackingLocationService.stop();
    clearToken();
    Get.offAllNamed(Routes.LOGIN);
  }

  static Future<void> saveToken(String? token) async {
    var prefs = await SharedPreferences.getInstance();

    if (_instance._token != token && token != null) {
      _instance._token = token;
      await prefs.setString('token', token);
    }
  }

  static Future<void> clearToken() async {
    var prefs = await SharedPreferences.getInstance();
    _instance._token = null;
    await prefs.remove('token');
    clearDriver();
  }
}
