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
    return RegisterResponse.fromJson(response.data);
  }

  Future<LoginResponse> login(LoginPayload payload) async {
    final response = await _dio.post(
      AppPaths.login.path,
      data: payload.toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }
}
