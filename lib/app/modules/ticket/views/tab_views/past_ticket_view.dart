import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../controllers/ticket_controller.dart';

class PastTicketView extends GetView<TicketController> {
  const PastTicketView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            controller.pastTickets(),
          ],
        ),
      ),
    );
  }
}
