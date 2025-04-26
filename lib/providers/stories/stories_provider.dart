import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:narrativa/services/services.dart';
import 'package:narrativa/static/static.dart';

class StoriesProvider extends ChangeNotifier {
  StoriesProvider(this.apiService);
  final ApiService apiService;

  StoriesState _state = StoriesState();
  StoriesState get state => _state;

  Future<void> fetchStories(String token) async {
    _updateState(state.copyWith(status: StoriesStatus.loading));

    try {
      final storiesResult = await apiService.getStories(token: token);

      if (storiesResult.error) {
        _updateState(
          state.copyWith(
            status: StoriesStatus.error,
            errorMessage: storiesResult.message,
          ),
        );
        return;
      }

      _updateState(
        state.copyWith(
          status: StoriesStatus.loaded,
          stories: storiesResult.listStory,
        ),
      );
    } on DioException catch (de) {
      _updateState(
        state.copyWith(
          status: StoriesStatus.error,
          errorMessage: apiService.parseDioException(de),
        ),
      );
    } catch (e) {
      _updateState(
        state.copyWith(status: StoriesStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void _updateState(StoriesState newState) {
    _state = newState;
    notifyListeners();
  }
}
