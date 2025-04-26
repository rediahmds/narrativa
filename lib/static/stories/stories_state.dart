import 'package:narrativa/models/models.dart';
import 'package:narrativa/static/static.dart';

class StoriesState {
  const StoriesState({
    this.status = StoriesStatus.none,
    this.stories,
    this.errorMessage,
  });

  StoriesState copyWith({
    StoriesStatus? status,
    List<Story>? stories,
    String? errorMessage,
  }) {
    return StoriesState(
      status: status ?? this.status,
      stories: stories ?? this.stories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return "StoriesState{status: $status, stories: ${stories?.toString()}, errorMessage: $errorMessage}";
  }

  final StoriesStatus status;
  final List<Story>? stories;
  final String? errorMessage;
}
