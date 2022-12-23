import 'package:dio/dio.dart';
import 'package:hyper_app_settings/hyper_app_settings.dart';

class DioGoong extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters['api_key'] = AppSettings.get('goongAPIKey');
    super.onRequest(options, handler);
  }
}
