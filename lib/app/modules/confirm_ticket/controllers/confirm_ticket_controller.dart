import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ConfirmTicketController extends GetxController {
  CalendarController calendarController = CalendarController();

  List<String> selectedTripIds = [];

  @override
  void onInit() {
    var arg = Get.arguments as Map;
    if (arg.containsKey('selectedTripIds')) {
      selectedTripIds = arg['selectedTripIds'];
    }
    super.onInit();
  }
}
