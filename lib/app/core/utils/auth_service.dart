import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/driver_model.dart';
import '../../routes/app_pages.dart';
import '../base/base_controller.dart';
import '../widget/shared.dart';
import 'notification_service.dart';

class AuthService extends BaseController {
  static final AuthService _instance = AuthService._internal();
  static AuthService get instance => _instance;
  AuthService._internal();

  String? _token;

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

  /// Get driver model
  static Driver? get driver {
    Map<String, dynamic> payload = Jwt.parseJwt(token.toString());

    if (payload.isNotEmpty) {
      return Driver.fromJson(payload);
    }
    return null;
  }

  static Future<void> init() async {
    var prefs = await SharedPreferences.getInstance();
    _instance._token = prefs.getString('token');
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
      },
      onError: (exception) {
        showToast('Không thể kết nối');
      },
    );

    if (token != null) {
      saveToken(token);
      result = true;
      Get.offAllNamed(Routes.MAIN);
    }

    return result;
  }

  static Future<void> logout() async {
    NotificationService.unregisterNotification();
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
  }
}
