import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:narrativa/models/models.dart';
import 'package:narrativa/services/services.dart';
import 'package:narrativa/static/static.dart';

class StoriesProvider extends ChangeNotifier {
  StoriesProvider(this.apiService);
  final ApiService apiService;

  StoriesState _state = StoriesState();
  StoriesState get state => _state;

  final List<Story> _stories = [];
  void clearStories() {
    _stories.clear();
    page = 1;
    notifyListeners();
  }

  int? _page = 1;
  set page(int? value) {
    _page = value;
    notifyListeners();
  }

  int? get page => _page;

  int size = 10;

  Future<void> fetchStories(String token) async {
    if (page == 1) {
      _updateState(state.copyWith(status: StoriesStatus.loading));
    }

    try {
      final storiesResult = await apiService.getStories(
        token: token,
        page: page!,
        size: size,
      );

      if (storiesResult.error) {
        _updateState(
          state.copyWith(
            status: StoriesStatus.error,
            errorMessage: storiesResult.message,
          ),
        );
        return;
      }

      _stories.addAll(storiesResult.listStory);
      _updateState(
        state.copyWith(status: StoriesStatus.loaded, stories: _stories),
      );

      page = storiesResult.listStory.length < size ? null : page! + 1;
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
