import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visitingcard/vc_view.dart';

class detail extends StatefulWidget {
  @override
  _detailState createState() => _detailState();
}

class _detailState extends State<detail> {
  TextEditingController name = TextEditingController();
  TextEditingController job = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController message = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController add1 = TextEditingController();
  TextEditingController add2 = TextEditingController();
  File pickedImage1;
  bool yes1 = false;
  _imagePickfront() async {
    pickedImage1 = await ImagePicker.pickImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: pickedImage1.path,
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop/Rotate',
          toolbarColor: Color(0xFF007f5f),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );
    setState(() {
      pickedImage1 = croppedFile;
      yes1 = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details'),
        actions: <Widget>[

          IconButton(icon: Icon(Icons.done),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VCview(name: name.text,mail: mail.text,message: message.text,company: company.text,
                      phone: phone.text,add1: add1.text,add2: add2.text,job: job.text,image: pickedImage1,)));
            },)
        ],),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: <Widget>[
            Center(child: Text('Enter your details',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
            SizedBox(height: MediaQuery.of(context).size.height/20,),
            yes1
                ?  CircleAvatar(radius:MediaQuery.of(context).size.height / 10,backgroundColor: Colors.transparent,
              child: Image(image: FileImage(pickedImage1),),
            )
            /*Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                height: MediaQuery.of(context).size.height / 8,
                width: MediaQuery.of(context).size.width/5,
                decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(image: FileImage(pickedImage1))),
              ),
            )*/
                : GestureDetector(
                onTap: () {
                  _imagePickfront();
                },
                child: CircleAvatar(radius:MediaQuery.of(context).size.height / 10,backgroundColor: Colors.black,
                  child: Text(
                    "Your Photo",
                    style: TextStyle(fontSize: 20,color: Colors.white),
                  )),
                ),
            SizedBox(height: MediaQuery.of(context).size.height/20,),
            TextField(
              controller: name,
              decoration: InputDecoration(
                  hintText: 'Name'),
            ),SizedBox(height: MediaQuery.of(context).size.height/20,),
            TextField(
              controller: job,
              style: TextStyle(fontSize: 15),
              decoration: InputDecoration(
                  hintText: 'Job Title'),
            ),SizedBox(height: MediaQuery.of(context).size.height/20,),
            TextField(
              controller: company,
              decoration: InputDecoration(
                  hintText: 'Company Name'),
            ),SizedBox(height: MediaQuery.of(context).size.height/20,),
            TextField(
              controller: message,
              decoration: InputDecoration(
                  hintText: 'Company Message'),
            ),SizedBox(height: MediaQuery.of(context).size.height/20,),
            TextField(
              controller: phone,
              decoration: InputDecoration(
                  hintText: 'Phone'),
            ),SizedBox(height: MediaQuery.of(context).size.height/20,),
            TextField(
              controller: mail,
              decoration: InputDecoration(
                  hintText: 'Email'),
            ),SizedBox(height: MediaQuery.of(context).size.height/20,),
            TextField(
              controller: add1,
              decoration: InputDecoration(
                  hintText: 'Address Line 1'),
            ),SizedBox(height: MediaQuery.of(context).size.height/20,),
            TextField(
              controller: add2,
              decoration: InputDecoration(
                  hintText: 'Address Line 2'),
            ),
          ],
        ),
      ),
    );
  }
}