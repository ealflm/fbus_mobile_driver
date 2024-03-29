import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:latlong2/latlong.dart';

import '../../core/base/base_repository.dart';
import '../../network/dio_provider.dart';
import '../models/direction_model.dart';
import '../models/driver_model.dart';
import '../models/notification_model.dart';
import '../models/route_model.dart';
import '../models/selected_trip_model.dart';
import '../models/station_model.dart';
import '../models/statistic_model.dart';
import '../models/student_count_model.dart';
import '../models/student_trip_model.dart';
import '../models/trip_model.dart';
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
  Future<Trip?> getCurrentTrip(String driverId) {
    var endPoint = '${DioProvider.baseUrl}/trip/current/$driverId';
    var dioCall = dioTokenClient.get(endPoint);

    try {
      return callApi(dioCall).then(
        (response) async {
          Trip result = Trip.fromJson(response.data['body']);
          result.isCurrent = true;
          return result;
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
          result.last.title = 'Chuyến đi sắp tới';
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
          result.last.title = 'Chuyến đi đã qua';
        });
      }
      return result;
    });
  }

  @override
  Future<List<StudentCount>> getStudentCounts(String tripId) {
    var endPoint = '${DioProvider.baseUrl}/trip/studentTrip/$tripId';

    var dioCall = dioTokenClient.get(endPoint);

    return callApi(dioCall).then((response) {
      var result = <StudentCount>[];
      if (response.data['body'] != null) {
        response.data['body'].forEach((value) {
          result.add(StudentCount.fromJson(value));
        });
      }
      return result;
    });
  }

  @override
  Future<void> changePassword(
      String phoneNumber, String oldPassword, String newPassword) {
    var endpoint = '${DioProvider.baseUrl}/change-password';
    var data = {
      'username': phoneNumber,
      'oldPassowrd': oldPassword,
      'newPassword': newPassword,
    };
    var dioCall = dioTokenClient.put(endpoint, data: data);

    return callApi(dioCall);
  }

  @override
  Future<Driver> getProfile(String driverId) {
    var endPoint = '${DioProvider.baseUrl}/profile/$driverId';

    var dioCall = dioTokenClient.get(endPoint);

    return callApi(dioCall).then((response) {
      return Driver.fromJson(response.data['body']['driver']);
    });
  }

  @override
  Future<void> updateProfile(Driver driver, MultipartFile? image) {
    var endpoint = '${DioProvider.baseUrl}/profile/${driver.id}';

    Map<String, dynamic> data = {
      'FullName': driver.fullName,
      'Address': driver.address,
    };

    if (image != null) {
      data['UploadFile'] = image;
    }

    var formData = FormData.fromMap(data);

    var dioCall = dioTokenClient.put(endpoint, data: formData);

    return callApi(dioCall);
  }

  @override
  Future<void> checkIn(String qrCode, String driverId) {
    var endpoint = '${DioProvider.baseUrl}/trip/checkin';
    var data = {
      'qrCode': qrCode,
      'driverId': driverId,
    };
    var dioCall = dioTokenClient.patch(endpoint, data: data);

    return callApi(dioCall);
  }

  @override
  Future<String> encodeQR(String content) {
    var endPoint = '${DioProvider.baseUrl}/encryptString/$content';

    var dioCall = dioTokenClient.get(endPoint);

    return callApi(dioCall).then(
      (response) {
        return response.data['body'];
      },
    );
  }

  @override
  Future<void> requestSwap(String driverId, String tripId, String? content) {
    var endPoint = '${DioProvider.baseUrl}/send-swap-request';

    var data = {
      'driverId': driverId,
      'tripId': tripId,
    };

    if (content != null) {
      data['content'] = content;
    }

    var dioCall = dioTokenClient.post(endPoint, data: data);

    return callApi(dioCall);
  }

  @override
  Future<void> sendLocation(String driverId, LatLng? location) {
    var endPoint = '${DioProvider.baseUrl}/tracking-location';

    if (location == null) {
      return Future.error('Not found location');
    }

    var data = {
      'driverId': driverId,
      'latitude': location.latitude,
      'longitude': location.longitude,
    };

    var dioCall = dioTokenClient.post(endPoint, data: data);

    return callApi(dioCall);
  }
}
