import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_reader/Utility/image_list.dart';
import 'package:pdf_reader/Widgets/selected_images.dart';
import 'package:permission_handler/permission_handler.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ImagesList imagesList = ImagesList();

  Future<PermissionStatus> storagePermissionStatus() async {
    // getting the permision of photos or local storage
    // for android version 13+
    if (await Permission.photos.isGranted ||
        await Permission.storage.isGranted) {
      return PermissionStatus.granted;
    }
    //PermissionStatus storagePermissionStatus = await Permission.storage.status;
    // for android version 10 to 12
    if (await Permission.photos.request().isGranted ||
        await Permission.storage.request().isGranted) {
      return PermissionStatus.granted;
    }

    /*if (!storagePermissionStatus.isGranted) {
      await Permission.storage.request();
    }*/
    // updated with new logic
    return PermissionStatus.denied;
    //return storagePermissionStatus;
  }

  Future<PermissionStatus> cameraPermissionStatus() async {
    PermissionStatus cameraPermissionStatus = await Permission.camera.status;

    if (!cameraPermissionStatus.isGranted) {
      await Permission.camera.request();
    }

    cameraPermissionStatus = await Permission.camera.status;

    return cameraPermissionStatus;
  }

  void pickGalleryImage() async {
    // image permission
    // to request images Supports All Cases With A Platform-aware check
    PermissionStatus status = await Permission.photos.request();

    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();

      if (images.isNotEmpty) {
        imagesList.clearImagesList();
        imagesList.imagePaths.addAll(images);

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SelectedImages(),
          ),
        );
      }
    }
  }

  void captureCameraImages() async {
    PermissionStatus status = await cameraPermissionStatus();

    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        imagesList.clearImagesList();
        imagesList.imagePaths.add(image);
      }

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SelectedImages(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Images To Pdf"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialButton(
              color: Colors.teal,
              textColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              onPressed: pickGalleryImage,
              child: const Text("Gallery Images"),
            ),
            const Gap(10),
            MaterialButton(
              color: Colors.teal,
              textColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              onPressed: captureCameraImages,
              child: const Text("Capture Image"),
            ),
          ],
        ),
      ),
    );
  }
}
