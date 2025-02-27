import 'package:finanzaspersonales/pages/home/dashboard/dashboard_page.dart';
import 'package:finanzaspersonales/pages/home/home_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/home';
  static const String dashboard = '/dashboard';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => HomePage(),
    dashboard: (context) => DashboardPage(),
    // Agregar más rutas si es necesario
  };
}