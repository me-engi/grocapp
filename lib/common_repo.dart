import 'package:dio/dio.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/global.dart';

class API {
  final Dio _dio = Dio();

  API() {
    _dio.options.baseUrl = Global.hostUrl;
    _dio.interceptors.add(PrettyDioLogger());
    _dio.options.headers["Content-Type"] = "application/json";
    _dio.options.headers["Accept"] = "application/json";
    // _dio.options.headers["Authorization"] =
    //     "Bearer ";
  }

  Dio get sendRequest => _dio;
}
