import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../provider/userDataProvider.dart';

class Imagepicker {
  late dynamic prodata;
  _imgFromCamera() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      prodata.image(pickedFile.path);
    }
  }

  _imgFromGallery() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      prodata.image(pickedFile.path);
    }
  }

  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          prodata = Provider.of<UserDataProvider>(context, listen: false);
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
