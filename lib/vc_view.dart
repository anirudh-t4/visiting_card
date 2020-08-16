import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:visitingcard/share.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class VCview extends StatefulWidget {
  String name;
  String mail;
  String phone;
  String add1;
  String add2;
  String company;
  String message;
  String job;
  File image;
  VCview({Key key, @required this.name,@required this.mail,@required this.phone,@required this.add1,
    @required this.add2,@required this.company,@required this.message,@required this.job,@required this.image}) : super(key: key);

  @override
  _VCviewState createState() => _VCviewState();
}

class _VCviewState extends State<VCview> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);

     flutterLocalNotificationsPlugin.initialize(initSettings,
     onSelectNotification: onSelectNotification);
  }

  Future _showNotificationWithDefaultSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Success',
      'File has been downloaded successfully!',
      platformChannelSpecifics,
    );
  }
  File _imageFile;
  Future onSelectNotification(String payload) async {
    OpenFile.open(_imageFile.path);
  }
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Card'),
        actions: <Widget>[
          FlatButton(
              child: new Text("Save"),
              textColor: Colors.white,
              onPressed: () {
                _showNotificationWithDefaultSound();

                _imageFile = null;
                screenshotController
                    .capture(
                    delay: Duration(milliseconds: 500), pixelRatio: 1.5)
                    .then((File image) async {
                  //print("Capture Done");
                  setState(() {
                    _imageFile = image;
                  });
                  final paths = await getExternalStorageDirectory();
                  image.copy(paths.path +
                      '/' +
                      DateTime.now().millisecondsSinceEpoch.toString() +
                      '.png');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => share(img: image,)));
                }).catchError((onError) {
                  print(onError);
                });

              }),
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Container(height: MediaQuery.of(context).size.height ,
          width:MediaQuery.of(context).size.height ,
          child: Center(
              child: Container(height: MediaQuery.of(context).size.height/3 ,
                width:MediaQuery.of(context).size.width/1.1 ,
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/background.png'),fit: BoxFit.fill)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(widget.name,
                                style: TextStyle(fontSize: 25),
                              ),
                              Text(widget.job,
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          Container(height: MediaQuery.of(context).size.height/10 ,
                            width:MediaQuery.of(context).size.width/6 ,
                            decoration: BoxDecoration(
                                image: DecorationImage(image: FileImage(widget.image),fit: BoxFit.fill)
                            ),)

                        ],
                      ),
                      Divider(thickness: 2,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(widget.company,),
                            Text(widget.message,),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(widget.mail),
                                Text(widget.phone),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(widget.add1),
                                Text(widget.add2),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              )
          ),
        ),
      ));


  }
}
