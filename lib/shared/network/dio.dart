import 'package:dio/dio.dart';

class Dio_Helper {
  static var dio = Dio(
    BaseOptions(
      baseUrl: 'https://damanhourappproject-production.up.railway.app/api/',
      receiveDataWhenStatusError: true,
    ),
  );

  static Future<Response> getfromDB({
    required String url,
    dynamic query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    return await dio.get(url, queryParameters: query);
  }

  static Future<Response> PostinDB({
    required String url,
    Map<String, dynamic>? query,
    required dynamic data,
    String lang = 'en',
    String? token,
    String? contenttype = 'application/json',
  }) async {
    dio.options.headers = {
      'lang': lang,
      'Content-Type': contenttype,
      'Authorization': token,
    };
    return dio.post(url, queryParameters: query, data: data);
  }

  static Future<Response> updateDB({
    required dynamic data,
    Map<String, dynamic>? query,
    required String url,
    String? token,
    String? contenttype = 'application/json',
  }) async {
    dio.options.headers = {'Content-Type': contenttype, 'Authorization': token};
    return dio.put(url, queryParameters: query, data: data);
  }

  static Future<Response> delete({required String url, String? token,   Map<String, dynamic>? query,
  }) async {
    dio.options.headers = {'Authorization': token};
    return dio.delete(url ,queryParameters: query);
  }
}
