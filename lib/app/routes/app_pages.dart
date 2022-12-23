import 'package:get/get.dart';

import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/booking/bindings/booking_binding.dart';
import '../modules/booking/views/booking_view.dart';
import '../modules/confirm_ticket/bindings/confirm_ticket_binding.dart';
import '../modules/confirm_ticket/views/confirm_ticket_view.dart';
import '../modules/current_trip/bindings/current_trip_binding.dart';
import '../modules/current_trip/views/current_trip_view.dart';
import '../modules/feed_back/bindings/feed_back_binding.dart';
import '../modules/feed_back/views/feed_back_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/scan/bindings/scan_binding.dart';
import '../modules/scan/views/scan_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/select_route/bindings/select_route_binding.dart';
import '../modules/select_route/views/select_route_view.dart';
import '../modules/select_trip/bindings/select_trip_binding.dart';
import '../modules/select_trip/views/select_trip_view.dart';
import '../modules/ticket/bindings/ticket_binding.dart';
import '../modules/ticket/views/ticket_view.dart';
import '../modules/ticket_detail/bindings/ticket_detail_binding.dart';
import '../modules/ticket_detail/views/ticket_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.TICKET,
      page: () => const TicketView(),
      binding: TicketBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.BOOKING,
      page: () => const BookingView(),
      binding: BookingBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => const AccountView(),
      binding: AccountBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.SCAN,
      page: () => const ScanView(),
      binding: ScanBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.SELECT_ROUTE,
      page: () => const SelectRouteView(),
      binding: SelectRouteBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.CONFIRM_TICKET,
      page: () => const ConfirmTicketView(),
      binding: ConfirmTicketBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.CURRENT_TRIP,
      page: () => const CurrentTripView(),
      binding: CurrentTripBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.FEED_BACK,
      page: () => const FeedBackView(),
      binding: FeedBackBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.SELECT_TRIP,
      page: () => const SelectTripView(),
      binding: SelectTripBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.TICKET_DETAIL,
      page: () => const TicketDetailView(),
      binding: TicketDetailBinding(),
      transition: Transition.noTransition,
    ),
  ];
}
