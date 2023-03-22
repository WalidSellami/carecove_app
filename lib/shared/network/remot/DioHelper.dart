import 'package:dio/dio.dart';

class DioHelper {

  static Dio? dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2',
        receiveDataWhenStatusError: true,
      ),
    );
  }


  Future<Response?> getData({
    required String url,
    Map<String , dynamic>? query,
    String? token,
}) async {

    dio?.options.headers = {
      'Content-Type': 'application/json',
      'Authorization' : token,
    };


    return await dio?.get(url , queryParameters: query);

  }


  Future<Response?> postData({
    required String url,
    required Map<String , dynamic> data,
    Map<String , dynamic>? query,
    String? token,
  }) async {

    dio?.options.headers = {
      'Content-Type': 'application/json',
      'Authorization' : token,
    };


    return await dio?.post(url , data: data , queryParameters: query);

  }


  Future<Response?> putData({
    required String url,
    required Map<String , dynamic> data,
    Map<String , dynamic>? query,
    String? token,
  }) async {

    dio?.options.headers = {
       'Content-Type': 'application/json',
       'Authorization' : token,
    };

    return await dio?.put(url , data: data , queryParameters: query);

  }


  Future<Response?> deleteData({
    required String url,
    required Map<String , dynamic> data,
    Map<String , dynamic>? query,
    String? token,
  }) async {

    dio?.options.headers = {
      'Content-Type': 'application/json',
      'Authorization' : token,
    };


    return await dio?.delete(url , data: data , queryParameters: query);

  }


}