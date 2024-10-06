import 'package:dio/dio.dart';

Dio dio = Dio(BaseOptions(
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 5),
  followRedirects: true,
  validateStatus: (status) => status! < 500,
));