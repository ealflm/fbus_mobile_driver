import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'bindings/initial_binding.dart';
import 'core/utils/auth_service.dart';
import 'core/utils/notification_service.dart';
import 'core/values/app_colors.dart';
import 'routes/app_pages.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    String initialRoute = AppPages.INITIAL;
    if (AuthService.token != null) {
      initialRoute = Routes.MAIN;
      NotificationService.registerNotification();
    }

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            SfGlobalLocalizations.delegate
          ],
          supportedLocales: const [
            Locale('vi'),
          ],
          locale: const Locale('vi'),
          title: "FBus",
          initialBinding: InitialBinding(),
          initialRoute: initialRoute,
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
          scrollBehavior: NoneScrollBehavior(),
          theme: ThemeData(
            colorScheme: const ColorScheme(
              primary: AppColors.primary400,
              secondary: AppColors.secondary,
              surface: AppColors.surface,
              background: AppColors.background,
              error: AppColors.error,
              onPrimary: AppColors.white,
              onSecondary: AppColors.onSecondary,
              onSurface: AppColors.onSurface,
              onBackground: AppColors.onBackground,
              onError: AppColors.onError,
              brightness: Brightness.light,
            ),
            focusColor: AppColors.orange,
          ),
        );
      },
    );
  }
}

class NoneScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
