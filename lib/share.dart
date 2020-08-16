
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter/cupertino.dart';
import 'package:printing/printing.dart';
import 'package:visitingcard/details.dart';

class share extends StatefulWidget {
  final img;
  share({this.img});
  @override
  _shareState createState() => _shareState();
}

class _shareState extends State<share> {
  @override
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);

    // flutterLocalNotificationsPlugin.initialize(initSettings,
    //     onSelectNotification: onSelectNotification);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share'),
        actions: <Widget>[
          GestureDetector(
              onTap: () async {
                var sh = widget.img
                    .readAsBytesSync();
                await Printing.sharePdf(
                    bytes: sh, filename: 'vc.png');
              },
              child: Icon(
                Icons.share,
                size: 30,
              )),
          IconButton(
            icon: Icon(Icons.home, size: 30,),
            onPressed: () async {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                    return detail();
                  }), ModalRoute.withName('/'));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          child: Image.file(widget.img),
        ),
      ),
    );
  }
}
