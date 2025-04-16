import 'package:dio/dio.dart';
import 'package:narrativa/models/models.dart';
import 'package:narrativa/routes/app_paths.dart';

class ApiService {
  final _dio = Dio(BaseOptions(baseUrl: "https://story-api.dicoding.dev/v1"));

  Future<RegisterResponse> register(RegisterPayload payload) async {
    final response = await _dio.post(
      AppPaths.register.path,
      data: payload.toJson(),
    );
    return RegisterResponse.fromJson(response.toString());
  }

  Future<LoginResponse> login(LoginPayload payload) async {
    final response = await _dio.post(
      AppPaths.login.path,
      data: payload.toJson(),
    );
    return LoginResponse.fromJson(response.toString());
  }

  String parseDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return "Connection timeout. Please try again.";

      case DioExceptionType.badResponse:
        final statusCode = dioException.response?.statusCode;
        if (statusCode != null) {
          final errorMessage =
              dioException.response?.data['message'] ??
              "Check your input and try again.";
          return "Server error ($statusCode). $errorMessage";
        }

        return "Received invalid response from the server.";

      case DioExceptionType.cancel:
        return "Request cancelled.";

      case DioExceptionType.connectionError:
        return "No internet connection. Please check your network.";

      default:
        return "Unexpected HTTP error occurred. Please try again later.";
    }
  }
}
