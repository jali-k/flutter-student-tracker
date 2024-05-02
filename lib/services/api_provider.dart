import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIProvider {
  static const String _baseUrl = 'http://10.0.2.2:9000/api/v1';
  static const String BASE_URL = 'http://localhost:9000/api/v1';
  static final Dio _dio = Dio();
  static APIProvider? _instance;
  String? _token;

  static get instance {
    if (_instance == null) {
      _instance = APIProvider();
      _instance!._initializeInterceptors();
    }
    return _instance;
  }

  Future<void> _initializeInterceptors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('accessToken')!;

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add Authorization header with Bearer token
        options.headers['Authorization'] = 'Bearer $_token';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        return handler.next(e);
      },
    ));
  }

  Future<Response> get(String path) async {
    try {
      final response = await _dio.get(_baseUrl + path);
      return response;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<Response> post(String path, dynamic data) async {
    try {
      final response = await _dio.post(_baseUrl + path, data: data);
      return response;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

// Add other HTTP methods as needed
}
