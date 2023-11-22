import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

var base_url = "http://demo.imageonline.in/keephappifeet/statistics/mobileApi.php";
// var base_url = "http://192.168.4.9:82/keephappifeet/statistics/mobileApi.php";
// var base_url = "https://dev2.imageonline.co.in/keephappifeet/statistics/mobileApi.php";

class NetworkClient implements InterceptorsWrapper {
  NetworkClient._privateConstructor() {
    addInterceptor();
  }

  static final NetworkClient _instance = NetworkClient._privateConstructor();

  factory NetworkClient() {
    return _instance;
  }

  bool added = false;

  final Dio dio = Dio(
    BaseOptions(
        maxRedirects: 2,
        sendTimeout: Duration(seconds: 90000),
        baseUrl: base_url,
        connectTimeout: Duration(seconds: 10000),
        receiveTimeout: Duration(seconds: 10000),
        contentType: "multipart/form-data"
      // headers: <String, dynamic>{"User-agent": Jiffy().dateTime}
    ),
  );

  void addInterceptor() {
    if (!added) dio.interceptors.add(this);

    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    added = true;
  }

  // void addCertificate() {
  //   (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
  //       (HttpClient client) {
  //     client.badCertificateCallback =
  //         (X509Certificate cert, String host, int port) => true;
  //   };
  // }

  Future<void> delay() async {
    await Future.delayed(const Duration(milliseconds: 1));
  }

  bool isAccessDenied(int code) {
    return false;
    if (code == 404) {
      // NavigationService.instance.openAccessDeniedScreen();
    }
    return code == 404;
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log("Interceptor $err");
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      // options.path = options.path + "?test=1";
      log("Api Service Request ${options.baseUrl} ${(options.data as FormData).fields}");
    } catch (e) {
      log("$e");
    }
    return handler.next(options);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    log("data $response");
    return handler.next(response);
  }
}
