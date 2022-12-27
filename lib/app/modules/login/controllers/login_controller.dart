import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/auth_service.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  String? phoneNumber;
  String? password;

  final Rx<bool> _isLoading = Rx<bool>(false);
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    isLoading = true;

    await AuthService.login(phoneNumber ?? '', password ?? '');

    isLoading = false;
  }
}
