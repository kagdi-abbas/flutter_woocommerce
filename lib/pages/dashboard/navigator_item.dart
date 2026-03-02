import 'package:flutter/material.dart';
import 'package:woocommerce_app/pages/categories/categories_page.dart';

class NavigatorItem {
  final String label, iconPath;
  final int index;
  final Widget screen;

  NavigatorItem(this.label, this.iconPath, this.index, this.screen);
}

List<NavigatorItem> navigatorItems = [
  NavigatorItem('Shop', 'assets/icons/shop_icon.svg', 0, const SizedBox()),
  NavigatorItem('Categories', 'assets/icons/categories_icon.svg', 0, const CategoriesPage()),
  NavigatorItem('Cart', 'assets/icons/cart_icon.svg', 0, const SizedBox()),
  NavigatorItem('Account', 'assets/icons/account_icon.svg', 0, const SizedBox()),
];