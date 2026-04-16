import 'dart:convert';

LoginResponseModel loginResponseJson(String str) => 
  LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  final String token;
  final String userEmail;
  final String userNicename;
  final String userDisplayName;
  final String id;

  LoginResponseModel({
    required this.token,
    required this.userEmail,
    required this.userNicename,
    required this.userDisplayName,
    required this.id,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json){
    return LoginResponseModel(
      token: json['token'] ?? "", 
      userEmail: json['user_email'] ?? "", 
      userNicename: json['user_nicename'] ?? "", 
      userDisplayName: json['user_display_name'] ?? "", 
      id: json['id'] ?? "", 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user_email': userEmail,
      'user_nicename': userNicename,
      'user_display_name': userDisplayName,
      'id': id,
    };
  }
}