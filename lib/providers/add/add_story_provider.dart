import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class AddStoryProvider extends ChangeNotifier {
  String? _imagePath;
  String? get imagePath => _imagePath;
  set imagePath(String? value) {
    _imagePath = value;
    notifyListeners();
  }

  XFile? _imageFile;
  XFile? get imageFile => _imageFile;
  set imageFile(XFile? value) {
    _imageFile = value;
    notifyListeners();
  }

  void openGalleryView() async {
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;

    if (isMacOS || isLinux) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imagePath = pickedFile.path;
      imageFile = pickedFile;
    }
  }

  void openCameraView() async {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isMobile = isAndroid || isIOS;
    if (!isMobile) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imagePath = pickedFile.path;
      imageFile = pickedFile;
    }
  }

  void clearImage() {
    imagePath = null;
    imageFile = null;
  }
}
