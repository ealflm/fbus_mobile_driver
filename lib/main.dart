import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hyper_app_settings/hyper_app_settings.dart';
import 'package:intl/intl.dart';
import 'app/app.dart';
import 'app/core/utils/auth_service.dart';
import 'app/core/utils/notification_service.dart';
import 'app/core/values/app_svg_assets.dart';
import 'app/data/repository/goong_repository.dart';
import 'app/data/repository/goong_repository_impl.dart';
import 'app/data/repository/repository.dart';
import 'app/data/repository/repository_impl.dart';
import 'config/build_config.dart';
import 'config/env_config.dart';
import 'config/environment.dart';
import 'config/firebase_options.dart';

void main() async {
  // Allow initialization before calling [runApp].
  WidgetsFlutterBinding.ensureInitialized();

  Get.lazyPut<Repository>(
    () => RepositoryImpl(),
    tag: (Repository).toString(),
  );

  Get.lazyPut<GoongRepository>(
    () => GoongRepositoryImpl(),
    tag: (GoongRepository).toString(),
  );

  // Set vi locale
  Intl.defaultLocale = 'vi';

  await AppSettings.init();

  // Environment config.
  //
  // Set base url.
  EnvConfig envConfig = EnvConfig(
    baseUrl: AppSettings.get('baseUrl'),
  );

  // Build config.
  //
  // Select environment type.
  BuildConfig.instantiate(
    envType: Environment.DEVELOPMENT,
    envConfig: envConfig,
  );

  // Prevent screen rotation.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load token from storage
  await AuthService.init();

  // Init notification service
  NotificationService.init();

  await _loadAssets();

  runApp(const App());
}

Future<void> _loadAssets() async {
  await Future.wait([
    precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, AppSvgAssets.fbusIsometric),
      null,
    ),
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder, AppSvgAssets.busIcon),
      null,
    ),
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder, AppSvgAssets.busIconTo),
      null,
    ),
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder, AppSvgAssets.busIconFrom),
      null,
    ),
  ]);
}
