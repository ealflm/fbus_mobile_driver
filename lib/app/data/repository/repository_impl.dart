import 'package:fbus_mobile_driver/app/data/models/trip_model.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../core/base/base_repository.dart';
import '../../network/dio_provider.dart';
import '../models/direction_model.dart';
import '../models/notification_model.dart';
import '../models/route_model.dart';
import '../models/selected_trip_model.dart';
import '../models/station_model.dart';
import '../models/statistic_model.dart';
import '../models/student_trip_model.dart';
import '../models/tripx_model.dart';
import 'goong_repository.dart';
import 'repository.dart';

class RepositoryImpl extends BaseRepository implements Repository {
  @override
  Future<String> login(String phoneNumber, String password) async {
    var endpoint = '${DioProvider.baseUrl}/authorization/login';
    var data = {
      'userName': phoneNumber,
      'password': password,
    };
    var dioCall = dioClient.post(endpoint, data: data);

    try {
      return callApi(dioCall).then((response) => response.data['body']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Route>> getRoute() {
    var endpoint = '${DioProvider.baseUrl}/route';
    var dioCall = dioTokenClient.get(endpoint);

    try {
      return callApi(dioCall).then(
        (response) async {
          List<Route> routes = [];
          if (response.data['body'] != null) {
            response.data['body'].forEach((value) {
              routes.add(Route.fromJson(value));
            });
          }

          // Fetch route points for all route
          GoongRepository goongRepository =
              Get.find(tag: (GoongRepository).toString());
          for (Route route in routes) {
            route.points =
                await goongRepository.getRoutePoints(route.stationLocations);
            await Future.delayed(const Duration(milliseconds: 200));
          }

          return routes;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Tripx>> getTrip(
      String routeId, DateTime date, SelectedTrip selectedTrip) {
    var endPoint = '${DioProvider.baseUrl}/trip';
    var data = {
      'id': routeId,
      'date': date,
    };
    var dioCall = dioTokenClient.get(endPoint, queryParameters: data);

    try {
      return callApi(dioCall).then(((response) {
        List<Tripx> trips = [];
        response.data['body'].forEach((value) {
          trips.add(Tripx.fromJson(value)..mapSelectedTrip(selectedTrip));
        });
        return trips;
      }));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> bookTrip(
      String driverId, String tripId, String selectedStationId, bool type) {
    var endPoint = '${DioProvider.baseUrl}/student-trip';
    var data = {
      'driverId': driverId,
      'tripId': tripId,
      'stationId': selectedStationId,
      'type': type,
    };

    var dioCall = dioTokenClient.post(endPoint, data: data);

    try {
      return callApi(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> registerNotification(String driverId, String code) {
    var endpoint = "${DioProvider.baseUrl}/noti-token";

    var data = {
      "id": driverId,
      "notificationToken": code,
    };
    var dioCall = dioTokenClient.post(endpoint, data: data);

    try {
      return callApi(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Notification>> getNotifications(String driverId) {
    var endPoint = '${DioProvider.baseUrl}/notification/$driverId';

    var dioCall = dioTokenClient.get(endPoint);

    try {
      return callApi(dioCall).then(
        (response) {
          List<Notification> notifications = [];
          response.data['body'].forEach((value) {
            notifications.add(Notification.fromJson(value));
          });
          return notifications;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Ticket>> getTickets(String driverId) {
    var endPoint = '${DioProvider.baseUrl}/student-trip';

    var data = {'id': driverId};
    var dioCall = dioTokenClient.get(endPoint, queryParameters: data);

    try {
      return callApi(dioCall).then(
        (response) async {
          List<Ticket> studentTrips = [];

          for (var value in response.data['body']) {
            Ticket ticket = Ticket.fromJson(value);

            ticket.trip?.route = ticket.route;

            // Fetch points
            List<LatLng> locations = [];
            List<Station> stationList = ticket.trip?.route?.stations ?? [];

            if (ticket.type == false) {
              int n = 0;
              while (n < stationList.length) {
                if (ticket.selectedStation?.id == stationList[n++].id) {
                  break;
                }
              }

              for (int i = 0; i < n; i++) {
                locations.add(stationList[i].location!);
              }
            } else if (ticket.type == true) {
              int i = 0;
              while (i < stationList.length) {
                if (ticket.selectedStation?.id == stationList[i].id) {
                  break;
                }
                i++;
              }

              for (; i < stationList.length; i++) {
                locations.add(stationList[i].location!);
              }
            }

            // Fetch route points for all route
            GoongRepository goongRepository =
                Get.find(tag: (GoongRepository).toString());
            Direction? direction =
                await goongRepository.getDirection(locations);
            await Future.delayed(const Duration(milliseconds: 100));

            ticket.direction = direction;
            //////////////

            studentTrips.add(ticket);
          }

          return studentTrips;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Ticket?> getCurrentTicket(String driverId) {
    var endPoint = '${DioProvider.baseUrl}/student-trip/current/$driverId';
    var dioCall = dioTokenClient.get(endPoint);

    try {
      return callApi(dioCall).then(
        (response) async {
          if (response.data['body'] == null) return null;
          Ticket ticket = Ticket.fromJson(response.data['body']);

          ticket.trip?.route = ticket.route;

          // Fetch points
          List<LatLng> locations = [];
          List<Station> stationList = ticket.trip?.route?.stations ?? [];

          if (ticket.type == false) {
            int n = 0;
            while (n < stationList.length) {
              if (ticket.selectedStation?.id == stationList[n++].id) {
                break;
              }
            }

            for (int i = 0; i < n; i++) {
              locations.add(stationList[i].location!);
            }
          } else if (ticket.type == true) {
            int i = 0;
            while (i < stationList.length) {
              if (ticket.selectedStation?.id == stationList[i].id) {
                break;
              }
              i++;
            }

            for (; i < stationList.length; i++) {
              locations.add(stationList[i].location!);
            }
          }

          // Fetch route points for all route
          GoongRepository goongRepository =
              Get.find(tag: (GoongRepository).toString());
          Direction? direction = await goongRepository.getDirection(locations);

          ticket.direction = direction;

          return ticket;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Statistic> getStatistic(String driverId) {
    var endPoint = '${DioProvider.baseUrl}/statistics/$driverId';

    var dioCall = dioTokenClient.get(endPoint);

    return callApi(dioCall).then(
      (response) {
        return Statistic.fromJson(response.data['body']);
      },
    );
  }

  @override
  Future<void> checkin(String driverId, String code) {
    var endPoint = '${DioProvider.baseUrl}/student-trip/checkin';

    var data = {
      'qrCode': code,
      'studentID': driverId,
    };

    var dioCall = dioTokenClient.patch(endPoint, data: data);

    try {
      return callApi(dioCall).then(
        (response) {},
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> feedback(String studentTripId, double rate, String message) {
    var endPoint =
        '${DioProvider.baseUrl}/student-trip/feedback/$studentTripId';

    var data = {'rate': rate, 'feedback': message};

    var dioCall = dioTokenClient.patch(endPoint, data: data);

    return callApi(dioCall);
  }

  @override
  Future<void> removeTrip(String studentTripId) {
    var endPoint = '${DioProvider.baseUrl}/student-trip/$studentTripId';

    var dioCall = dioTokenClient.delete(endPoint);

    return callApi(dioCall);
  }

  @override
  Future<List<Trip>> getFutureTrips(String driverId) {
    var endPoint = '${DioProvider.baseUrl}/trip/schedule/$driverId';

    var dioCall = dioTokenClient.get(endPoint);

    return callApi(dioCall).then((response) {
      var result = <Trip>[];
      if (response.data['body'] != null) {
        response.data['body'].forEach((value) {
          result.add(Trip.fromJson(value));
          result.last.title = 'Sắp tới';
        });
      }
      return result;
    });
  }

  @override
  Future<List<Trip>> getPastTrips(String driverId) {
    var endPoint = '${DioProvider.baseUrl}/trip/history/$driverId';

    var dioCall = dioTokenClient.get(endPoint);

    return callApi(dioCall).then((response) {
      var result = <Trip>[];
      if (response.data['body'] != null) {
        response.data['body'].forEach((value) {
          result.add(Trip.fromJson(value));
          result.last.title = 'Đã qua';
        });
      }
      return result;
    });
  }
}
