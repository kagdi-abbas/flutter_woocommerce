import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/api/shared_service.dart';
import 'package:woocommerce_app/pages/categories/categories_page.dart';
import 'package:woocommerce_app/pages/dashboard/dashboard_page.dart';
import 'package:woocommerce_app/pages/extras/ninja_card_page.dart';
// import 'package:woocommerce_app/pages/home/home_page.dart';
import 'package:woocommerce_app/pages/login/login_page.dart';
import 'package:woocommerce_app/pages/products/product_details_page.dart';
import 'package:woocommerce_app/pages/products/products_page.dart';
import 'package:woocommerce_app/pages/registration/user_register_page.dart';
import 'package:woocommerce_app/provider/products_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool _result = await SharedService.isLoggedIn();

  if(_result){
    _defaultHome = "/";
  }

  runApp(const MyApp());
}

String _defaultHome = "/Dashboard";

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
        initialRoute: _defaultHome,
        routes: <String, WidgetBuilder> {
          '/' : (context) => DashboardPage(),
          '/categories' : (context) => CategoriesPage(),
          '/register' : (context) => RegisterPage(),
          '/products' : (context) => ProductsPage(),
          '/product-details' : (context) => ProductDetailsPage(),
          '/login' : (context) => LoginPage(),
          '/ninja': (content) => NinjaCard(),
        }
      ),
    ); 
  }
}
