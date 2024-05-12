import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIProvider {
  static const String _baseUrl = 'http://10.0.2.2:9000/api/v1';
  static const String BASE_URL = 'http://10.0.2.2:9000/api/v1';
  static Dio? dio;
  static APIProvider? _apiProvider;
  int _maxRetry = 3;
  int _currentRetry = 0;
  String? _token;

  APIProvider() {
    final baseOptions = BaseOptions(
      baseUrl: _baseUrl,
      contentType: Headers.jsonContentType,
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
    );
    dio = Dio(baseOptions);
  }


  static APIProvider get instance {
    if (_apiProvider == null) {
      _apiProvider = APIProvider();
      _apiProvider!._initializeInterceptors();
    }
    return _apiProvider!;
  }

  reInitializeAPIProvider() {
    _initializeInterceptors();
  }

  Future<void> _initializeInterceptors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('accessToken')) {
      _token = prefs.getString('accessToken');
      dio!.options.headers['Authorization'] = 'Bearer $_token';
    }




    dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add Authorization header with Bearer token
        options.headers['Authorization'] = 'Bearer $_token';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          if(_currentRetry >= _maxRetry) {
            return handler.next(e);
          }
          _currentRetry++;
          String accessToken = await refreshToken();
          e.requestOptions.headers['Authorization'] = 'Bearer $accessToken';
          return handler.resolve(await dio!.fetch(e.requestOptions));
        }
        return handler.next(e);
      }
    ));
  }

  Future<String> refreshToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? refreshToken = prefs.getString('refreshToken');
      final response = await dio!.post('$_baseUrl/auth/refresh', data: {
        "refreshToken": refreshToken
      });
      if (response.statusCode == 200) {
        prefs.setString('accessToken', response.data['accessToken']);
        prefs.setString('refreshToken', response.data['refreshToken']);
        _token = response.data['accessToken'];
        return response.data['accessToken'];
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<Response> get(String path) async {
    try {
      final response = await dio!.get(_baseUrl + path);
      return response;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<Response> post(String path, dynamic data) async {
    try {
      final response = await dio!.post(_baseUrl + path, data: data);
      return response;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<Response> postMultipart(String path, dynamic data) async {
    try {
      FormData formData = FormData.fromMap(data);
      final response = await dio!.post(_baseUrl + path, data: formData,options: Options(
        contentType: 'multipart/form-data',
      ));
      return response;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<Response> put(String path, dynamic data) async {
    try {
      final response = await dio!.put(_baseUrl + path, data: data);
      return response;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  delete(String path, dynamic data) async {
    try {
      final response = await dio!.delete(_baseUrl + path, data: data);
      return response;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

// Add other HTTP methods as needed
}
