import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/models/trip_model.dart';
import '../values/app_colors.dart';
import '../values/app_svg_assets.dart';
import '../values/font_weights.dart';
import '../values/text_styles.dart';

class TicketItemExpanded extends StatelessWidget {
  const TicketItemExpanded({
    Key? key,
    required this.trip,
    this.backgroundColor = AppColors.green,
    this.textColor = AppColors.white,
    this.expandedBackgroundColor = AppColors.green,
    this.expandedTextColor = AppColors.white,
    this.state = TicketItemExpandedState.less,
    this.onPressed,
    this.actionButtonOnPressed,
  }) : super(key: key);

  final Trip trip;
  final Color backgroundColor;
  final Color textColor;
  final Color expandedBackgroundColor;
  final Color expandedTextColor;
  final TicketItemExpandedState state;
  final Function()? actionButtonOnPressed;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = this.backgroundColor;
    Color textColor = this.textColor;
    if (state == TicketItemExpandedState.more) {
      backgroundColor = expandedBackgroundColor;
      textColor = expandedTextColor;
    }
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Wrap(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: 15.w,
                  right: 15.w,
                  bottom: state == TicketItemExpandedState.more ? 10.h : 20.h,
                  top: 10.h),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(9.r),
                ),
                boxShadow: kElevationToShadow[1],
              ),
              child: Column(
                children: [
                  // if (title != null)
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         '$title',
                  //         style: subtitle2.copyWith(
                  //           fontWeight: FontWeights.light,
                  //           color: textColor,
                  //         ),
                  //       ),
                  //       Text(
                  //         model.date,
                  //         style: subtitle2.copyWith(
                  //           fontWeight: FontWeights.light,
                  //           color: textColor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
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
                              title: '${trip.fromStation?.name}',
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
                              title: '${trip.toStation?.name}',
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
                                  text: trip.distanceStr,
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
                  if (state == TicketItemExpandedState.more)
                    _more(backgroundColor, textColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _more(Color backgroundColor, Color textColor) {
    return Column(
      children: [
        const Divider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(14.r), // Image radius
                child: CachedNetworkImage(
                  fadeInDuration: const Duration(),
                  fadeOutDuration: const Duration(),
                  placeholder: (context, url) {
                    return SvgPicture.asset(AppSvgAssets.male);
                  },
                  imageUrl: '${trip.driver?.photoUrl}',
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return SvgPicture.asset(AppSvgAssets.male);
                  },
                ),
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tài xế',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeights.regular,
                                  letterSpacing: 0.0025.sp,
                                ),
                              ),
                              Text(
                                '${trip.driver?.fullName}',
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
                        width: 20.w,
                      ),
                      Column(
                        children: [
                          Text(
                            'Số điện thoại',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeights.regular,
                              letterSpacing: 0.0025.sp,
                            ),
                          ),
                          Text(
                            '${trip.driver?.phone}',
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
                    height: 10.h,
                  ),
                  Row(
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
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
            onPressed: actionButtonOnPressed,
            child: Text(
              'Đặt ngay',
              style: subtitle2.copyWith(color: AppColors.white),
            ),
          ),
        )
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

enum TicketItemExpandedState { less, more }
