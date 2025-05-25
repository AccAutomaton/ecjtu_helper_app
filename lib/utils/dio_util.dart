import 'package:dio/dio.dart';

Dio dio = Dio(BaseOptions(
  connectTimeout: const Duration(seconds: 20),
  receiveTimeout: const Duration(seconds: 20),
  followRedirects: true,
  validateStatus: (status) => status! < 500,
));