import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/student_model.dart';
import '../../routes/app_pages.dart';
import '../base/base_controller.dart';
import '../widget/shared.dart';
import 'google_auth_service.dart';
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

  /// Get student model
  static Student? get student {
    Map<String, dynamic> payload = Jwt.parseJwt(token.toString());

    if (payload.isNotEmpty) {
      return Student.fromJson(payload);
    }
    return null;
  }

  static Future<void> init() async {
    var prefs = await SharedPreferences.getInstance();
    _instance._token = prefs.getString('token');
  }

  static Future<bool> login() async {
    bool result = false;
    User? user;

    try {
      // In some cases logging out is not correct
      // need to call logout here to fix that.
      await GoogleAuthService.logout();

      user = await GoogleAuthService.login();

      if (user != null) {
        String? idToken = await user.getIdToken();

        // Call data service to get token from server
        String? token;
        var loginService = _instance.repository.login(idToken);
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

        // Login successfully.
      } else {
        // Login failed.
      }
    } catch (e) {
      debugPrint('Unable to connect');
      // Unable to connect.
    }

    return result;
  }

  static Future<void> logout() async {
    NotificationService.unregisterNotification();
    await GoogleAuthService.logout();
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
