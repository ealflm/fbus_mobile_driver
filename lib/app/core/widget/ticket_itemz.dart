import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/ticket_modelz.dart';
import '../values/app_colors.dart';
import '../values/font_weights.dart';
import '../values/text_styles.dart';

class TicketItemZ extends StatelessWidget {
  const TicketItemZ({
    Key? key,
    required this.model,
    this.backgroundColor = AppColors.green,
    this.textColor = AppColors.white,
    this.title,
  }) : super(key: key);

  final TicketModel model;
  final Color backgroundColor;
  final Color textColor;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      alignment: Alignment.bottomCenter,
      child: Wrap(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: 15.w, right: 15.w, bottom: 20.h, top: 10.h),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.all(
                Radius.circular(9.r),
              ),
              boxShadow: kElevationToShadow[1],
            ),
            child: Column(
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
                      Text(
                        model.date,
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
                          station(
                            title: model.startStation,
                            time: model.startTimeStr,
                            iconColor: AppColors.green,
                            textColor: textColor,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 11.r),
                            child: Column(
                              children: [
                                dot(textColor),
                                SizedBox(height: 3.h),
                                dot(textColor),
                                SizedBox(height: 3.h),
                                dot(textColor),
                                SizedBox(height: 3.h),
                              ],
                            ),
                          ),
                          station(
                            title: model.endStation,
                            time: model.endTimeStr,
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
                                text: '${model.distance.toInt()}',
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
                                    text: model.estimatedTimeStr,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container dot(Color color) {
    return Container(
      width: 2.r,
      height: 2.r,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Row station(
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
