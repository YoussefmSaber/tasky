// image_picker_service.dart
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

typedef ErrorCallback = void Function(String message);
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  // Callback type for error handling

  // Pick image from desktop
  Future<File?> pickDesktopImage({ErrorCallback? onError}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      if (onError != null) {
        onError('Error picking image: $e');
      }
    }
    return null;
  }

  // Pick image from gallery or camera
  Future<File?> pickImage(ImageSource source, {ErrorCallback? onError}) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      if (onError != null) {
        onError('Error selecting image: $e');
      }
    }
    return null;
  }

  // Show image picker dialog
  Future<File?> showImagePickerDialog(BuildContext context, {ErrorCallback? onError}) async {
    File? selectedImage;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (Platform.isWindows)
                ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('Choose from Computer'),
                  onTap: () async {
                    Navigator.pop(context);
                    selectedImage = await pickDesktopImage(onError: onError);
                  },
                ),
              if (!Platform.isWindows) ...[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    selectedImage = await pickImage(ImageSource.gallery, onError: onError);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a Photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    selectedImage = await pickImage(ImageSource.camera, onError: onError);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );

    return selectedImage;
  }
}