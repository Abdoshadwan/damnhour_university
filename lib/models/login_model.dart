import 'package:damnhour_university/models/user_model.dart';

class LoginModel {
  String? token;
  String? message;
  String? error;
  UserModel? user;

  LoginModel();

  // Factory method to create a LoginModel from JSON (success response)
  LoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    message = json['message'];
    user = UserModel.fromJson(json['user']);
  }

  // Factory method to handle error responses
  LoginModel.handleError(Map<String, dynamic> json) {
    if (json['non_field_errors'] != null && json['non_field_errors'] is List) {
      error = json['non_field_errors'][0];
    } else if (json['detail'] != null) {
      error = json['detail'];
    } else {
      error = 'حدث خطأ غير متوقع';
    }
  }
}
