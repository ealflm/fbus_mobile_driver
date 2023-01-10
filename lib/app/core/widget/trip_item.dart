import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/trip_model.dart';
import '../values/app_colors.dart';
import '../values/font_weights.dart';
import '../values/text_styles.dart';

class TripItem extends StatelessWidget {
  const TripItem({
    Key? key,
    required this.trip,
    this.backgroundColor = AppColors.green,
    this.textColor = AppColors.white,
    this.expandedBackgroundColor = AppColors.green,
    this.expandedTextColor = AppColors.white,
    this.state = TripItemExpandedState.less,
    this.onPressed,
    this.actionButtonOnPressed,
    this.title,
    this.button,
    this.feedback,
    this.hideButton = false,
    this.stationList = const [],
  }) : super(key: key);

  final Trip trip;
  final Color backgroundColor;
  final Color textColor;
  final Color expandedBackgroundColor;
  final Color expandedTextColor;
  final TripItemExpandedState state;
  final Function()? actionButtonOnPressed;
  final Function()? onPressed;
  final String? title;
  final Widget? button;
  final Feedback? feedback;
  final bool hideButton;
  final List<Widget> stationList;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = this.backgroundColor;
    Color textColor = this.textColor;
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.only(
            left: 15.w,
            right: 15.w,
            bottom: state == TripItemExpandedState.more ? 10.h : 20.h,
            top: 10.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(9.r),
          ),
          boxShadow: kElevationToShadow[1],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$title',
                    style: subtitle2.copyWith(
                      fontWeight: FontWeights.light,
                      color: textColor,
                    ),
                  ),
                  if (trip.rate != null && trip.rate != 0)
                    Row(
                      children: [
                        Text(
                          '${trip.rate ?? 0}',
                          style: subtitle2.copyWith(
                            fontWeight: FontWeights.light,
                            color: textColor,
                          ),
                        ),
                        Icon(
                          Icons.star,
                          size: 18.sp,
                          color: AppColors.yellow,
                        ),
                      ],
                    ),
                  Text(
                    trip.dateStr,
                    style: subtitle2.copyWith(
                      fontWeight: FontWeights.light,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _station(
                        title: trip.route?.startStation?.name ?? '-',
                        time: trip.startTimeStr,
                        iconColor: AppColors.green,
                        textColor: textColor,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 11.r),
                        child: Column(
                          children: [
                            _dot(textColor),
                            SizedBox(height: 3.h),
                            _dot(textColor),
                            SizedBox(height: 3.h),
                            _dot(textColor),
                            SizedBox(height: 3.h),
                          ],
                        ),
                      ),
                      _station(
                        title: trip.route?.endStation?.name ?? '-',
                        time: trip.endTimeStr,
                        iconColor: AppColors.secondary,
                        textColor: textColor,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Khoảng cách',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeights.regular,
                            letterSpacing: 0.0025.sp,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: trip.route?.distanceStr ?? '-',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20.sp,
                              fontWeight: FontWeights.medium,
                              letterSpacing: 0.0025.sp,
                            ),
                            children: [
                              TextSpan(
                                text: 'km',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeights.medium,
                                  letterSpacing: 0.0025.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 1.h),
                        RichText(
                          text: TextSpan(
                            text: 'Thời gian: ',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeights.regular,
                              letterSpacing: 0.0025.sp,
                            ),
                            children: [
                              TextSpan(
                                text: trip.estimatedTimeStr,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeights.medium,
                                  letterSpacing: 0.0025.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            if (state == TripItemExpandedState.more)
              _more(backgroundColor, textColor),
          ],
        ),
      ),
    );
  }

  Widget _more(Color backgroundColor, Color textColor) {
    return Column(
      children: [
        const Divider(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Biển số xe',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeights.regular,
                          letterSpacing: 0.0025.sp,
                        ),
                      ),
                      Text(
                        '${trip.bus?.licensePlates}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeights.medium,
                          letterSpacing: 0.0025.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 10.w,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Màu sắc',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeights.regular,
                          letterSpacing: 0.0025.sp,
                        ),
                      ),
                      Text(
                        '${trip.bus?.color}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeights.medium,
                          letterSpacing: 0.0025.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 10.w,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Số ghế',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeights.regular,
                          letterSpacing: 0.0025.sp,
                        ),
                      ),
                      Text(
                        '${trip.bus?.seat}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeights.medium,
                          letterSpacing: 0.0025.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
        Container(
          height: 0.25.sh,
          color: AppColors.white,
          child: SingleChildScrollView(
            child: Column(
              children: stationList,
            ),
          ),
        ),
        if (trip.startDate != null &&
            DateTime.now().compareTo(trip.startDate!) < 0)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Divider(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                onPressed: actionButtonOnPressed,
                child: Text(
                  'Đổi chuyến',
                  style: subtitle2.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Container _dot(Color color) {
    return Container(
      width: 2.r,
      height: 2.r,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Row _station(
      {required String title,
      required String time,
      Color? iconColor,
      required Color textColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(5.r),
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: kElevationToShadow[1],
          ),
          child: Icon(
            Icons.directions_bus,
            color: iconColor,
            size: 15.r,
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeights.medium,
                  letterSpacing: 0.0015.sp,
                ),
              ),
              Text(
                time,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13.sp,
                  letterSpacing: 0.0015.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum TripItemExpandedState { less, more }

class Feedback {
  num rate;
  String message;

  Feedback({required this.rate, required this.message});
}
