import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:narrativa/services/services.dart';
import 'package:narrativa/static/static.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AddStoryProvider extends ChangeNotifier {
  AddStoryProvider(this._apiService);
  final ApiService _apiService;

  final _maxImageSize = 1000000;

  AddStoryState _state = AddStoryState();
  AddStoryState get state => _state;

  final TextEditingController _descriptionController = TextEditingController();
  TextEditingController get descriptionController => _descriptionController;

  void openGalleryView() async {
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;

    if (isMacOS || isLinux) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _updateState(
        _state.copyWith(image: pickedFile, status: AddStoryStatus.imagePicked),
      );
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
      _updateState(
        _state.copyWith(image: pickedFile, status: AddStoryStatus.imagePicked),
      );
    }
  }

  void clearImage() {
    _updateState(AddStoryState());
  }

  void disposeController() {
    _descriptionController.dispose();
  }

  Future<void> uploadStory({
    required String token,
    required String description,
    double? lat,
    double? lon,
  }) async {
    if (_state.image == null) {
      _updateState(
        _state.copyWith(
          status: AddStoryStatus.error,
          errorMessage: "Please select an image",
        ),
      );
      return;
    }

    _updateState(_state.copyWith(status: AddStoryStatus.uploading));

    try {
      final imageSize = await _state.image!.length();
      Uint8List imageBytesUint = await _state.image!.readAsBytes();

      final isImageLarge = imageSize > _maxImageSize;
      if (isImageLarge) {
        imageBytesUint = await _compressImage(imageBytesUint);
      }

      final response = await _apiService.addStory(
        token: token,
        description: description,
        imageName: _state.image!.path.split('/').last,
        imageBytesInt: imageBytesUint.toList(),
        lat: lat,
        lon: lon,
      );

      if (response.error) {
        _updateState(
          _state.copyWith(
            status: AddStoryStatus.error,
            errorMessage: response.message,
          ),
        );
      }
      _updateState(_state.copyWith(status: AddStoryStatus.uploadSuccess));
    } on DioException catch (de) {
      _updateState(
        _state.copyWith(
          status: AddStoryStatus.error,
          errorMessage: _apiService.parseDioException(de),
        ),
      );
    } catch (e) {
      _updateState(
        _state.copyWith(
          status: AddStoryStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  _updateState(AddStoryState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<Uint8List> _compressImage(Uint8List imageBytesUint) async {
    int quality = 100;
    Uint8List imageBytes = await FlutterImageCompress.compressWithList(
      imageBytesUint,
      quality: quality,
    );

    do {
      quality -= 10;
      imageBytes = await FlutterImageCompress.compressWithList(
        imageBytesUint,
        quality: quality,
      );
    } while (imageBytes.length > _maxImageSize && quality > 0);

    return imageBytes;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
