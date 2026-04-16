import 'package:flutter/material.dart';
import 'package:woocommerce_app/pages/categories/categories_page.dart';
import 'package:woocommerce_app/pages/extras/ninja_card_page.dart';
import 'package:woocommerce_app/pages/home/home_page.dart';

class NavigatorItem {
  final String label, iconPath;
  final int index;
  final Widget screen;

  NavigatorItem(this.label, this.iconPath, this.index, this.screen);
}

List<NavigatorItem> navigatorItems = [
  NavigatorItem('Shop', 'assets/icons/shop_icon.svg', 0, const HomePage()),
  NavigatorItem('Categories', 'assets/icons/categories_icon.svg', 0, const CategoriesPage()),
  NavigatorItem('Cart', 'assets/icons/cart_icon.svg', 0, const SizedBox()),
  NavigatorItem('Ninja', 'assets/icons/account_icon.svg', 0, const NinjaCard()),
];