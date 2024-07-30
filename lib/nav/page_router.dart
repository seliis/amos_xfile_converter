import "package:flutter/material.dart";

import "package:bakkugi/ui/index.dart" as ui;

class PageRouter {
  static MaterialPageRoute<void> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ui.Home.pageName:
        return _getRoute(const ui.Home());
      case ui.Settings.pageName:
        return _getRoute(const ui.Settings());
      default:
        return _getRoute(
          const Scaffold(
            body: Center(
              child: Text("No Route"),
            ),
          ),
        );
    }
  }

  static MaterialPageRoute<void> _getRoute(Widget widget) {
    return MaterialPageRoute<void>(builder: (_) => widget);
  }
}
