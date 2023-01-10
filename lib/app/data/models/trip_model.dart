import 'package:flutter/material.dart' hide Route;
import 'package:intl/intl.dart';

import '../../core/utils/auth_service.dart';
import '../../core/utils/utils.dart';
import '../../core/values/app_colors.dart';
import 'bus_model.dart';
import 'driver_model.dart';
import 'route_model.dart';

class Trip {
  String? id;
  Bus? bus;
  Driver? driver;
  Route? route;
  DateTime? date;
  Duration? timeStart;
  Duration? timeEnd;
  int? status;
  num? rate;
  String? _title;
  bool isCurrent = false;
  int? currentTicket;

  set title(String? value) {
    _title = value;
  }

  String get title {
    if (isCurrent == false) return _title ?? '';
    DateTime now = DateTime.now();
    if (startDate != null && endDate != null) {
      if (now.compareTo(startDate!) < 0) {
        return 'Chuyến đi sắp tới';
      } else if (now.compareTo(endDate!) > 0) {
        return 'Chuyến đi đã qua';
      } else {
        if (AuthService.driver?.status == 3) {
          return 'Đang diễn ra';
        } else {
          return 'Chưa điểm danh';
        }
      }
    } else {
      return '';
    }
  }

  Color get backgroundColor {
    switch (title) {
      case 'Chuyến đi sắp tới':
        if (isCurrent) {
          return AppColors.yellow800;
        } else {
          return AppColors.white;
        }
      case 'Chuyến đi đã qua':
        return AppColors.caption;
      case 'Đang diễn ra':
        return AppColors.green;
      case 'Chưa điểm danh':
        return AppColors.purple600;
      default:
        return AppColors.white;
    }
  }

  Color get textColor {
    switch (title) {
      case 'Chuyến đi sắp tới':
        if (isCurrent) {
          return AppColors.white;
        } else {
          return AppColors.softBlack;
        }
      case 'Chuyến đi đã qua':
        return AppColors.white;
      case 'Đang diễn ra':
        return AppColors.white;
      case 'Chưa điểm danh':
        return AppColors.white;
      default:
        return AppColors.softBlack;
    }
  }

  DateTime? get startDate {
    if (date == null || timeStart == null) return null;
    return DateTime(date!.year, date!.month, date!.day).add(timeStart!);
  }

  DateTime? get endDate {
    if (date == null || timeEnd == null) return null;
    return DateTime(date!.year, date!.month, date!.day).add(timeEnd!);
  }

  String get dateStr {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date!);
  }

  String get startTimeStr {
    if (timeStart == null) return '-';
    return DateFormat('HH:mm').format(DateTime(1, 1, 1).add(timeStart!));
  }

  String get endTimeStr {
    if (timeEnd == null) return '-';
    return DateFormat('HH:mm').format(DateTime(1, 1, 1).add(timeEnd!));
  }

  String get estimatedTimeStr {
    if (timeEnd == null || timeStart == null) return '-';
    return formatDurationOnlyHourMinite(timeEnd! - timeStart!);
  }

  Trip.fromJson(Map<String, dynamic> json) {
    id = json['tripId'];
    bus = Bus.fromJson(json['bus']);
    driver = Driver.fromJson(json['driver']);
    route = Route.fromJson(json['route']);
    date = DateTime.parse(json['date']);
    timeStart = parseDuration(json['timeStart']);
    timeEnd = parseDuration(json['timeEnd']);
    status = json['status'];
    rate = json['rate'];
    currentTicket = json['currentTicket'];
  }
}
