import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import 'dart:io';

import 'dart:developer' as developer;



class TestePet extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return TestePetState();
  }
}

class TestePetState extends State<TestePet> {

   late File _image = File('your initial file');

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xffFDCF09),
                child: _image.existsSync()
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    _image
                  ),
                )
                    : Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50)),
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                       // Navigator.of(context).pop(_image);
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
    developer.log("IMAGEEEEMMM");
  }
  _imgFromCamera() async {
    final pickedImage = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    File image = new File(pickedImage!.path);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    final pickedImage = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    final pickedImageFile = File(pickedImage!.path);
   // _image =  File(pickedImage.path);
    developer.log("IMAGEEEEMMM $pickedImage!.path");
    setState(() {
      _image = pickedImageFile;
    });
    //Navigator.of(context).pop(_image);

  }

}
