import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:woocommerce_app/api/shared_service.dart';
import 'package:woocommerce_app/config.dart';
import 'package:woocommerce_app/models/category_model.dart';
import 'package:woocommerce_app/models/customer_model.dart';
import 'package:woocommerce_app/models/login_response_model.dart';
import 'package:woocommerce_app/models/products_item.dart';

class APIService {
  static var client = http.Client();

  static Future<List<CategoryModel>?> getCategories() async {
    Map<String, String> requestHeaders = {
      'Content-Type' : 'application/json', 
      'Authorization' : 'Basic ${base64Encode(
        utf8.encode( 
            '${Config.key}:${Config.secret}', 
        ),
      )}',
    };
    Map<String, dynamic> queryString = {
      // 'consumer_key' : Config.key,
      // 'consumer_secret' : Config.secret,
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
    List<int>? productIds,
    String sortOrder = "asc",
  }) async {
    Map<String, String> requestHeaders = {
      'Content-Type' : 'application/json', 
      'Authorization' : 'Basic ${base64Encode(
        utf8.encode( 
            '${Config.key}:${Config.secret}', 
        ),
      )}',
    };
    Map<String, dynamic> queryString = {
      // 'consumer_key' : Config.key,
      // 'consumer_secret' : Config.secret,
      '_fields[]' : ['id', 'name', 'price', 'regular_price', 'sales_price', 'short_description', 'images'],
    };

    if(strSearch != null){
      queryString["search"] = strSearch;
    }

    if(pageSize != null){
      queryString["per_page"] = pageSize.toString();
    }

    if(pageNumber != null){
      queryString["page"] = pageNumber.toString();
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

    if(productIds != null){
      queryString['include'] = productIds.join(", ").toString(); // related products
    }

    var url = Uri.https(
      Config.apiURL,
      Config.apiEndPoint + Config.productsURL,
      queryString,
    );
    print(url);

    var response = await client.get(url, headers: requestHeaders);

    if(response.statusCode == 200){
      var data = jsonDecode(response.body);

      return productsFromJson(data);
    }
    else {
      return null;
    }
  }


  static Future<ProductModel?> getProductDetails(productId) async {
    Map<String, String> requestHeaders = {
      'Content-Type' : 'application/json', 
      'Authorization' : 'Basic ${base64Encode(
        utf8.encode( 
            '${Config.key}:${Config.secret}', 
        ),
      )}',
    };
    Map<String, dynamic> queryString = {
      // 'consumer_key' : Config.key,
      // 'consumer_secret' : Config.secret,
      '_fields[]' : ['id', 'name', 'price', 'regular_price', 'sales_price', 'short_description', 'images', 'cross_sell_ids'],
    };

    var url = Uri.https(
      Config.apiURL,
      "${Config.apiEndPoint}${Config.productsURL}/$productId",
      queryString,
    );


    var response = await client.get(url, headers: requestHeaders);

    if(response.statusCode == 200){
      var data = jsonDecode(response.body);

      return ProductModel.fromJson(data);
    }
    else {
      return null;
    }
  }

  static Future<bool> registerUser(CustomerModel model) async {
    var authToken = base64.encode(
      utf8.encode("${Config.key}:${Config.secret}",),
    );

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Basic $authToken',
    };

    var url = Uri.https(
      Config.apiURL,
      Config.apiEndPoint + Config.customersURL,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson(),),
    );

    if(response.statusCode == 201){
      return true;
    }
    else{
      return false;
    }
  }

  static Future<bool> loginCustomer(String username, String password) async {

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var url = Uri.https(
      Config.apiURL,
      Config.customerLoginURL,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: {
        "username": username,
        "password": password,
      },
    );

    if(response.statusCode == 200){
      var jsonString = json.decode(response.body);
      var decodedData = parseJwt(jsonString['token']);

      var id = decodedData['data']['user']['id'].toString();
      jsonString['id'] = id;

      SharedService.setLoginDetails(loginResponseJson(json.encode(jsonString)));

      return true;
    }
    else{
      return false;
    }
  }

  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if(parts.length != 3){
      throw Exception("Invalid token");
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if(payloadMap is! Map<String, dynamic>){
      throw Exception("Invalid payload");
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch(output.length % 4){
      case 0: break;
      case 2: output += '=='; break;
      case 3: output += '='; break;
      default: throw Exception("Illegal base64url string!");
    }
    return utf8.decode(base64Url.decode(output));
  }

}