import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:woocommerce_app/config.dart';
import 'package:woocommerce_app/models/category_model.dart';
import 'package:woocommerce_app/models/products_item.dart';

class APIService {
  static var client = http.Client();

  static Future<List<CategoryModel>?> getCategories() async {
    Map<String, String> requestHeaders = {
      'Content-Type' : 'application/json', 
    };
    Map<String, dynamic> queryString = {
      'consumer_key' : Config.key,
      'consumer_secret' : Config.secret,
      'parent' : '0',
      '_fields[]' : ['id', 'name', 'image.src'],
      'per_page' : '20',
      'page' : '1',
    };

    var url = Uri.https(
      Config.apiURL,
      Config.apiEndPoint + Config.categoriesURL,
      queryString,
    );


    var response = await client.get(url, headers: requestHeaders);

    if(response.statusCode == 200){
      var data = jsonDecode(response.body);

      return categoriesFromJson(data);
    }
    else {
      return null;
    }
  }

  static Future<List<ProductModel>?> getProducts({
    int? pageNumber,
    int? pageSize,
    String? strSearch,
    String? categoryId,
    String? sortBy,
    String sortOrder = "asc",
  }) async {
    Map<String, String> requestHeaders = {
      'Content-Type' : 'application/json', 
    };
    Map<String, dynamic> queryString = {
      'consumer_key' : Config.key,
      'consumer_secret' : Config.secret,
      '_fields[]' : ['id', 'name', 'price', 'regular_price', 'sales_price', 'short_description', 'images'],
    };

    if(strSearch != null){
      queryString["search"] = strSearch;
    }

    if(pageSize != null){
      queryString["per_page"] = pageSize;
    }

    if(pageNumber != null){
      queryString["page"] = pageNumber;
    }

    if(categoryId != null){
      if(strSearch == "" || strSearch == null){
        queryString["category"] = categoryId;
      }
    }

    if(sortBy != null){
      queryString["orderBy"] = sortBy;
    }

    queryString["order"] = sortOrder;

    var url = Uri.https(
      Config.apiURL,
      Config.apiEndPoint + Config.productsURL,
      queryString,
    );


    var response = await client.get(url, headers: requestHeaders);

    if(response.statusCode == 200){
      var data = jsonDecode(response.body);

      return productsFromJson(data);
    }
    else {
      return null;
    }
  }
}