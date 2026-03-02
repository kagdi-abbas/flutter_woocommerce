import 'package:flutter/material.dart';
import 'package:woocommerce_app/pages/dashboard/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

Widget _defaultHome = DashboardPage();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder> {
        '/' : (context) => _defaultHome
      }
    );
  }
}
