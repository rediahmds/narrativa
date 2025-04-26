import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:narrativa/services/services.dart';
import 'package:narrativa/static/static.dart';

class DetailProvider extends ChangeNotifier {
  DetailProvider(this.apiService);
  final ApiService apiService;

  DetailState _state = DetailState();
  DetailState get state => _state;

  Future<void> fetchDetail({required String token, required String id}) async {
    _updateState(state.copyWith(status: DetailStatus.loading));

    try {
      final response = await apiService.getStoryDetail(token: token, id: id);

      if (response.error) {
        _updateState(
          state.copyWith(
            status: DetailStatus.error,
            errorMessage: response.message,
          ),
        );

        return;
      }

      _updateState(
        state.copyWith(status: DetailStatus.loaded, story: response.story),
      );
    } on DioException catch (de) {
      _updateState(
        state.copyWith(
          status: DetailStatus.error,
          errorMessage: apiService.parseDioException(de),
        ),
      );
    } catch (e) {
      _updateState(
        state.copyWith(status: DetailStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void _updateState(DetailState newState) {
    _state = newState;
    notifyListeners();
  }
}
