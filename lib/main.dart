import "package:package_info_plus/package_info_plus.dart";
import "package:window_manager/window_manager.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter/material.dart";

import "package:bakkugi/usecase/index.dart" as usecase;
import "package:bakkugi/nav/index.dart" as nav;
import "package:bakkugi/ui/index.dart" as ui;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  final packageInfo = await PackageInfo.fromPlatform();

  await windowManager.waitUntilReadyToShow(
    WindowOptions(
      title: "${packageInfo.appName.toUpperCase()} v${packageInfo.version}",
      center: true,
    ),
    () {
      windowManager.focus();
      windowManager.show();
    },
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => usecase.Import(),
        ),
        BlocProvider(
          create: (context) => usecase.Export(),
        ),
      ],
      child: MaterialApp(
        onGenerateRoute: nav.PageRouter.onGenerateRoute,
        debugShowCheckedModeBanner: false,
        initialRoute: ui.Home.pageName,
        theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: "Cascadia Code",
        ),
      ),
    ),
  );
}
