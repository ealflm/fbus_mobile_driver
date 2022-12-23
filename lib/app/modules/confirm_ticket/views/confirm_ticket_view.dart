import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/font_weights.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/hyper_dialog.dart';
import '../../../core/widget/shared.dart' hide dot, station;
import '../../../core/widget/status_bar.dart';
import '../../../data/local/db/trip_data.dart';
import '../../../data/models/tripz_model.dart';
import '../../../routes/app_pages.dart';
import '../../booking/views/booking_view.dart';
import '../controllers/confirm_ticket_controller.dart';

class ConfirmTicketView extends GetView<ConfirmTicketController> {
  const ConfirmTicketView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SfCalendar(
                  selectionDecoration: const BoxDecoration(),
                  timeSlotViewSettings:
                      TimeSlotViewSettings(timeIntervalHeight: 80.h),
                  controller: controller.calendarController,
                  showDatePickerButton: true,
                  view: CalendarView.schedule,
                  scheduleViewMonthHeaderBuilder:
                      scheduleViewMonthHeaderBuilder,
                  firstDayOfWeek: 1,
                  scheduleViewSettings: const ScheduleViewSettings(
                    appointmentItemHeight: 111,
                    hideEmptyScheduleWeek: true,
                    weekHeaderSettings: WeekHeaderSettings(
                      startDateFormat: 'dd/MM',
                      endDateFormat: 'dd/MM',
                    ),
                  ),
                  dataSource: getCalendarDataSource(controller.selectedTripIds),
                  appointmentBuilder: (BuildContext context,
                      CalendarAppointmentDetails details) {
                    final Appointment appointment = details.appointments.first;
                    if (controller.calendarController.view ==
                        CalendarView.schedule) {
                      return Material(
                        child: InkWell(
                          onTap: () {
                            debugPrint('Hello');
                          },
                          child: Ink(
                            padding: EdgeInsets.all(10.r),
                            color: AppColors.green,
                            height: details.bounds.height,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            station(
                                              title: 'Vinhomes grand park',
                                              time: '07:00',
                                              iconColor: AppColors.green,
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 11.r),
                                              child: Column(
                                                children: [
                                                  dot(),
                                                  SizedBox(height: 3.h),
                                                  dot(),
                                                  SizedBox(height: 3.h),
                                                  dot(),
                                                  SizedBox(height: 3.h),
                                                ],
                                              ),
                                            ),
                                            station(
                                              title: 'FPT University',
                                              time: '07:35',
                                              iconColor: AppColors.secondary,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Khoảng cách',
                                                style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 12.sp,
                                                  fontWeight:
                                                      FontWeights.regular,
                                                  letterSpacing: 0.0025.sp,
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: '20',
                                                  style: TextStyle(
                                                    color: AppColors.white,
                                                    fontSize: 20.sp,
                                                    fontWeight:
                                                        FontWeights.medium,
                                                    letterSpacing: 0.0025.sp,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'km',
                                                      style: TextStyle(
                                                        color: AppColors.white,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeights.medium,
                                                        letterSpacing:
                                                            0.0025.sp,
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
                                                    color: AppColors.white,
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeights.regular,
                                                    letterSpacing: 0.0025.sp,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: '15 phút',
                                                      style: TextStyle(
                                                        color: AppColors.white,
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeights.medium,
                                                        letterSpacing:
                                                            0.0025.sp,
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
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Text(appointment.subject);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: kElevationToShadow[1],
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    lightBub('Vui lòng xác nhận đặt vé'),
                    SizedBox(
                      height: 40.h,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder()),
                        onPressed: () {
                          HyperDialog.showSuccess(
                            title: 'Thành công',
                            content: 'Đặt vé thành công!',
                            barrierDismissible: false,
                            primaryButtonText: 'OK',
                            primaryOnPressed: () {
                              Get.offAllNamed(Routes.MAIN);
                            },
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Xác nhận',
                              style: subtitle2,
                            ),
                            Icon(
                              Icons.navigate_next,
                              color: AppColors.softBlack,
                              size: 20.r,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

AppointmentDataSource getCalendarDataSource(List<String> selectedTripIds) {
  Map<String, Tripz> trips = getTrips();

  List<Appointment> appointments = [];

  for (var trip in trips.values) {
    if (selectedTripIds.contains(trip.id)) {
      appointments.add(Appointment(
        id: trip.id,
        startTime: trip.startTime,
        endTime: trip.endTime,
        notes: trip.seatState,
      ));
    }
  }

  return AppointmentDataSource(appointments);
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
