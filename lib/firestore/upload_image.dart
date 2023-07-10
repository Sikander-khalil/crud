import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {  
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
   DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');

  Future getImageGallery()async{
  final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
  setState(() {
    if(pickedFile != null){
      _image = File(pickedFile.path);

    }else{
      print("'no Image picked");
    }
  });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Center(
              child: InkWell(
                onTap: (){
                  getImageGallery();

                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black
                    )
                  ),

                  child: _image != null ? Image.file(_image!.absolute) : Center(child: Icon(Icons.image)),

                ),
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(onPressed: () async{

              firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/foldername/'+DateTime.now().millisecondsSinceEpoch.toString());
              firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);

              Future.value(uploadTask).then((value) async{

                var newUrl = await ref.getDownloadURL();

                databaseRef.child('1').set({

                  'id': '1212',
                  'title': newUrl.toString()
                });
              });






            }, child: Text("Upload"))


          ],
        ),
      ),
    );
  }
}
