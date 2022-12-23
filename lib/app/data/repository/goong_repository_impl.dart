import 'package:latlong2/latlong.dart';

import '../../core/base/base_repository.dart';
import '../../core/utils/map_polyline_utils.dart';
import '../models/direction_model.dart';
import 'goong_repository.dart';

class GoongRepositoryImpl extends BaseRepository implements GoongRepository {
  @override
  Future<List<LatLng>> getRoutePoints(List<LatLng> locations) {
    if (locations.length < 2) {
      return Future<List<LatLng>>.value([]);
    }
    var endpoint = 'https://rsapi.goong.io/Direction';

    var origin = '${locations[0].latitude},${locations[0].longitude}';
    var destination = '';
    for (int i = 1; i < locations.length; i++) {
      destination += '${locations[i].latitude},${locations[i].longitude}';
      if (i != locations.length - 1) {
        destination += ';';
      }
    }

    var param = {
      'vehicle': 'car',
      'alternatives': false,
      'origin': origin,
      'destination': destination,
    };
    var dioCall = dioGoong.get(
      endpoint,
      queryParameters: param,
    );

    try {
      return callApi(dioCall).then((response) {
        String overviewPolylineCode =
            response.data['routes'][0]['overview_polyline']['points'];
        return MapPolylineUtils.decode(overviewPolylineCode);
      });
    } catch (e) {
      return Future<List<LatLng>>.value([]);
    }
  }

  @override
  Future<Direction?> getDirection(List<LatLng> locations) {
    if (locations.length < 2) {
      return Future<Direction?>.value(null);
    }
    var endpoint = 'https://rsapi.goong.io/Direction';

    var origin = '${locations[0].latitude},${locations[0].longitude}';
    var destination = '';
    for (int i = 1; i < locations.length; i++) {
      destination += '${locations[i].latitude},${locations[i].longitude}';
      if (i != locations.length - 1) {
        destination += ';';
      }
    }

    var param = {
      'vehicle': 'car',
      'alternatives': false,
      'origin': origin,
      'destination': destination,
    };
    var dioCall = dioGoong.get(
      endpoint,
      queryParameters: param,
    );

    try {
      return callApi(dioCall).then((response) {
        Direction result = Direction();

        String overviewPolylineCode =
            response.data['routes'][0]['overview_polyline']['points'];

        var legs = response.data['routes'][0]['legs'];

        double distance = 0;
        int seconds = 0;

        for (var item in legs) {
          distance += item['distance']['value'];
          seconds += item['duration']['value'] as int;
        }

        result.points = MapPolylineUtils.decode(overviewPolylineCode);
        result.distance = distance;
        result.duration = Duration(seconds: seconds);
        return result;
      });
    } catch (e) {
      return Future<Direction?>.value(null);
    }
  }
}
