import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';
import 'package:relief_sphere/app/const/app_constant.dart';

import 'app/config/size_config.dart';
import 'app/enum/enum.dart';
import 'app/providers/app_providers.dart';
import 'app/routes/app_routes.dart';
import 'core/notifiers/theme/theme_notifiers.dart';
import 'init.dart';

void main() async {
  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final routerDelegate = router.routerDelegate;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MultiProvider(
      providers: AppProvider.providers,
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return KhaltiScope(
              publicKey: "13c20d96630940dc917847e3cb6a33b4",
              navigatorKey: routerDelegate.navigatorKey,
              builder: (context, _) {
                return MaterialApp.router(
                  supportedLocales: const [
                    Locale('en', 'US'),
                    Locale('ne', 'NP'),
                  ],
                  localizationsDelegates: const [
                    KhaltiLocalizations.delegate,
                  ],
                  debugShowCheckedModeBanner: false,
                  title: AppConstant.appName,
                  routerConfig: router,
                  theme: FlexThemeData.light(scheme: FlexScheme.green),
                  darkTheme: FlexThemeData.dark(scheme: FlexScheme.green),
                  themeMode: switch (themeNotifier.themeMode) {
                    AppThemeMode.light => ThemeMode.light,
                    AppThemeMode.dark => ThemeMode.dark,
                    AppThemeMode.system => ThemeMode.system,
                  },
                );
              });
        },
      ),
    );
  }
}
