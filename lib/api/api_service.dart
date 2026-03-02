import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:woocommerce_app/config.dart';
import 'package:woocommerce_app/models/category_model.dart';

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
}