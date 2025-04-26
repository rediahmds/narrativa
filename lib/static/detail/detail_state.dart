import 'package:narrativa/models/models.dart';
import 'package:narrativa/static/static.dart';

class DetailState {
  const DetailState({
    this.status = DetailStatus.none,
    this.story,
    this.errorMessage,
  });

  final DetailStatus status;
  final Story? story;
  final String? errorMessage;

  DetailState copyWith({
    DetailStatus? status,
    Story? story,
    String? errorMessage,
  }) {
    return DetailState(
      status: status ?? this.status,
      story: story ?? this.story,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return "DetailState{status: $status, story: ${story?.toString()}, errorMessage: $errorMessage}";
  }
}
