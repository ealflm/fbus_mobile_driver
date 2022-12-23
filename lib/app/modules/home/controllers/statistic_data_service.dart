import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/utils/auth_service.dart';
import '../../../data/models/statistic_model.dart';

class StatisticDataService extends BaseController {
  /// Check if data is fetching or not
  final Rx<bool> _isLoading = Rx<bool>(false);
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  /// Store data
  final Rx<Statistic?> _statistic = Rx<Statistic?>(null);
  Statistic? get statistic => _statistic.value;
  set statistic(Statistic? value) {
    _statistic.value = value;
  }

  @override
  void onInit() {
    fetch();
    super.onInit();
  }

  /// Fetching data here
  Future<void> fetch() async {
    isLoading = true;
    String studentId = AuthService.student?.id ?? '';
    var statisticService = repository.getStatistic(studentId);

    await callDataService(
      statisticService,
      onSuccess: (response) {
        statistic = response;
      },
    );
  }
}
