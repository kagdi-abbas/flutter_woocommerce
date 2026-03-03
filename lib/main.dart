import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/pages/dashboard/dashboard_page.dart';
import 'package:woocommerce_app/pages/products/products_page.dart';
import 'package:woocommerce_app/provider/products_provider.dart';

void main() {
  runApp(const MyApp());
}

Widget _defaultHome = DashboardPage();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductsProvider(),
          child: ProductsPage(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder> {
          '/' : (context) => _defaultHome,
          '/products' : (context) => ProductsPage(),
        }
      ),
    ); 
  }
}
