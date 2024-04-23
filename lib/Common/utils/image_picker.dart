import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void showSnackBar({required BuildContext context, required String text}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
  //Try changing to showDialog instead of showSnackBar for better UI
}

Future<File?> pickOrCaptureImage(
    BuildContext context, ImageSource source) async {
  File? image;
  try {
    final imageFile = await ImagePicker().pickImage(source: source);
    if (imageFile != null) {
      image = File(imageFile.path);
    }
  } catch (e) {
    showSnackBar(context: context, text: e.toString());
  }
  return image;
}

Future<File?> showImagePickerOptions(BuildContext context) async {
  TextStyle commonStyle = TextStyle(fontSize: 14, color: Colors.grey.shade800);
  File? pickedImage;

  return showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Text("Pick image from gallery", style: commonStyle),
                  onTap: () async {
                    //Navigator.of(context).pop();
                    pickedImage =
                        await pickOrCaptureImage(context, ImageSource.gallery);
                    Navigator.of(context).pop(pickedImage);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Divider(),
                ),
                GestureDetector(
                  child: Text("Capture image with camera", style: commonStyle),
                  onTap: () async {
                    //Navigator.of(context).pop();
                    pickedImage =
                        await pickOrCaptureImage(context, ImageSource.camera);
                    Navigator.of(context).pop(pickedImage);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Divider(),
                ),
                GestureDetector(
                  child: Text("Cancel", style: commonStyle),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      });
}


//Codes without using ChatGPT
// Future<File?> pickImageFromGallery(BuildContext context) async {
//   File? image;
//   try {
//     //Need to change to pick multiple image
//     final pickedImage =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       image = File(pickedImage.path);
//     }
//   } catch (e) {
//     showSnackBar(context: context, text: e.toString());
//   }
//   return image;
// }