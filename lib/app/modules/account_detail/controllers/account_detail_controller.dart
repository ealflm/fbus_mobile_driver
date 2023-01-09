import 'package:dio/dio.dart';
import 'package:fbus_mobile_driver/app/core/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../../core/utils/auth_service.dart';
import '../../../data/models/driver_model.dart';

class AccountDetailController extends BaseController {
  final formKey = GlobalKey<FormState>();
  String? fullName;
  String? address;
  String? imageName;

  final Rx<String?> _imagePath = Rx<String?>(null);
  String? get imagePath => _imagePath.value;
  set imagePath(String? value) {
    _imagePath.value = value;
  }

  final Rx<String?> _messageLabel = Rx<String?>(null);
  String? get messageLabel => _messageLabel.value;
  set messageLabel(String? value) {
    _messageLabel.value = value;
  }

  final Rx<bool> _isLoading = Rx<bool>(false);
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  void getImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    imagePath = image?.path;
    imageName = image?.name;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    isLoading = true;

    Driver? driver;
    if (AuthService.driver != null) {
      driver = AuthService.driver!;
      driver.fullName = fullName;
      driver.address = address;
    }

    if (driver == null) return;

    MultipartFile? image;
    if (imagePath != null) {
      final mimeType = lookupMimeType(imagePath!);
      image = await MultipartFile.fromFile(
        imagePath!,
        filename: imageName ?? imagePath!,
        contentType: MediaType.parse(mimeType!),
      );
    }

    var changePasswordService = repository.updateProfile(driver, image);

    bool result = false;

    await callDataService(
      changePasswordService,
      onSuccess: (response) {
        messageLabel = 'Cập nhật thành công';
        result = true;
      },
    );

    if (result) {
      fetchProfile();
    }

    isLoading = false;
  }

  Future<void> fetchProfile() async {
    String driverId = AuthService.driver?.id ?? '';
    if (driverId.isEmpty) return;

    var fetchProfileService = repository.getProfile(driverId);

    await callDataService(
      fetchProfileService,
      onSuccess: (response) {
        AuthService.setDriver(response);
      },
    );
  }
}
