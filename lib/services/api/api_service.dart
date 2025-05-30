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

  Future<StoriesResponse> getStories({
    required String token,
    int? page,
    int? size,
  }) async {
    final response = await _dio.get(
      AppPaths.stories.path,
      queryParameters: {
        if (page != null) "page": page,
        if (size != null) "size": size,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return StoriesResponse.fromJson(response.data);
  }

  Future<StoryDetailResponse> getStoryDetail({
    required String token,
    required String id,
  }) async {
    final response = await _dio.get(
      "${AppPaths.stories.path}/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return StoryDetailResponse.fromJson(response.data);
  }

  Future<AddStoryResponse> addStory({
    required String token,
    required String description,
    required String imageName,
    required List<int> imageBytesInt,
    double? lat,
    double? lon,
  }) async {
    final formData = FormData.fromMap({
      "photo": MultipartFile.fromBytes(imageBytesInt, filename: imageName),
      "description": description,
      if (lat != null) "lat": lat,
      if (lon != null) "lon": lon,
    });

    final response = await _dio.post(
      AppPaths.stories.path,
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    return AddStoryResponse.fromJson(response.data);
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
