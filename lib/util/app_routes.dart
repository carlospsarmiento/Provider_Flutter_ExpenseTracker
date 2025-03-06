import 'package:finanzaspersonales/views/pages/home/dashboard/dashboard_page.dart';
import 'package:finanzaspersonales/views/pages/home/home_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/home';
  static const String dashboard = '/dashboard';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => HomePage(),
    dashboard: (context) => DashboardPage(),
  };
}