import 'package:latlong2/latlong.dart';

import '../../models/station_model.dart';

Map<String, Station> getStations() {
  Map<String, Station> result = {};

  result['0'] = Station(
    id: '0',
    name: 'FPT University',
    address:
        'Lô E2a-7, Đường D1, Đ. D1, Long Thạnh Mỹ, Thành Phố Thủ Đức, Thành phố Hồ Chí Minh',
    location: LatLng(10.841567123475343, 106.80898942710063),
  );
  result['1'] = Station(
    id: '1',
    name: 'Vinhomes Grand Park',
    address: 'Nguyễn Xiển, Long Thạnh Mỹ, Quận 9, Thành phố Hồ Chí Minh',
    location: LatLng(10.845082, 106.812956),
  );
  result['2'] = Station(
    id: '2',
    name: '354 Nguyễn Văn Tăng',
    address: 'Long Thạnh Mỹ, District 9, Ho Chi Minh City, Vietnam',
    location: LatLng(10.849830, 106.812727),
  );
  result['3'] = Station(
    id: '3',
    name: 'Trường ĐH Nguyễn Tất Thành',
    address: 'Long Thạnh Mỹ, District 9, Ho Chi Minh City, Vietnam',
    location: LatLng(10.843534, 106.818625),
  );
  result['4'] = Station(
    id: '4',
    name: 'Công Ty Mekophar',
    address: 'Long Thạnh Mỹ, District 9, Ho Chi Minh City, Vietnam',
    location: LatLng(10.842686, 106.828594),
  );

  // Another
  result['5'] = Station(
    id: '5',
    name: 'Công Ty Filied Lê Văn Việt',
    address: 'Long Thạnh Mỹ, District 9, Ho Chi Minh City, Vietnam',
    location: LatLng(10.849322192020587, 106.80087176970181),
  );
  result['6'] = Station(
    id: '6',
    name: 'Intel Products Vietnam',
    address:
        'Hi-Tech Park, Lô I2, Đ. D1, Phường Tân Phú, Quận 9, Thành phố Hồ Chí Minh, Vietnam',
    location: LatLng(10.851058, 106.799028),
  );
  result['7'] = Station(
    id: '7',
    name: 'Khu Công nghệ cao TP.HCM',
    address:
        'Phường Tân Phú, Thành phố Thủ Đức, Thành phố Hồ Chí Minh, Vietnam',
    location: LatLng(10.857539, 106.786016),
  );

  return result;
}
