import 'package:image_picker/image_picker.dart';
import 'package:narrativa/static/static.dart';

class AddStoryState {
  AddStoryState({
    this.status = AddStoryStatus.none,
    this.image,
    this.errorMessage,
  });
  final AddStoryStatus status;
  XFile? image;
  final String? errorMessage;

  AddStoryState copyWith({
    AddStoryStatus? status,
    XFile? image,
    String? errorMessage,
  }) {
    return AddStoryState(
      status: status ?? this.status,
      image: image ?? this.image,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return "AddStoryState{status: $status, image: ${image?.path}, errorMessage: $errorMessage}";
  }
}
