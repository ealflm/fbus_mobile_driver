import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/utils/auth_service.dart';
import '../../../data/models/student_trip_model.dart';

class HomeTicketDataService extends BaseController {
  final Rx<bool> _isLoading = Rx<bool>(false);
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  final Rx<Ticket?> _ticket = Rx<Ticket?>(null);
  Ticket? get ticket => _ticket.value;
  set ticket(Ticket? value) {
    _ticket.value = value;
  }

  @override
  void onInit() {
    fetchTicket();
    super.onInit();
  }

  Future<void> fetchTicket() async {
    isLoading = true;
    String studentId = AuthService.student?.id ?? '';
    var fetchTicketService = repository.getCurrentTicket(studentId);

    await callDataService(
      fetchTicketService,
      onSuccess: (Ticket? response) {
        ticket = response;
      },
      onError: (exception) {},
    );
    isLoading = false;
  }
}
