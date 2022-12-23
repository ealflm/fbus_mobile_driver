import 'dart:math';

import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '../../../data/models/notification_model.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    Key? key,
    required this.model,
  }) : super(key: key);

  final Notification? model;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _default(),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${model?.title}',
                            style: subtitle2.copyWith(
                              color: AppColors.softBlack,
                              fontSize: 14.r,
                            ),
                          ),
                          Text(
                            model?.content ?? '',
                            style: body2.copyWith(
                              color: AppColors.softBlack,
                              fontSize: 14.r,
                            ),
                          ),
                          Text(
                            dateTimeToString(model?.createdDate),
                            style: body2.copyWith(
                              color: AppColors.gray,
                              fontSize: 14.r,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _default() {
    List<Color> colors = [
      AppColors.primary400,
      AppColors.blue,
      AppColors.green,
      AppColors.orange,
      AppColors.purple,
    ];
    List<IconData> icons = [
      Icons.directions_bus,
      Icons.favorite,
      Icons.paid,
      Icons.favorite,
      Icons.wb_sunny,
    ];
    var random = Random();
    var colorIndex = random.nextInt(colors.length);
    var iconIndex = random.nextInt(icons.length);

    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // color: AppColors.primary400,
        color: colors[colorIndex],
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              icons[iconIndex],
              size: 26.r,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  String dateTimeToString(DateTime? dateTime) {
    initializeDateFormatting();
    return dateTime == null
        ? '-'
        : DateFormat('HH:mm - dd/MM/yyyy').format(dateTime);
  }
}
