import 'dart:async';
import 'dart:convert';

import 'package:autoadventures/io/Api.dart';
import 'package:autoadventures/io/Storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

final String name = 'project-144772132718';
final FirebaseOptions options = const FirebaseOptions(
  googleAppID: '1:144772132718:android:cc81d53a7cb6c204',
  databaseURL: 'https://autoadventures-f318b.firebaseio.com/',
  apiKey: 'AIzaSyChXbkwOMbf-UjOFgsQiRJzVYLFJvIXM-0',
);

FirebaseApp app;

void main() async {
  await FirebaseApp.configure(name: name, options: options).then((a) {
    print('CONFIGURED FIREBASE!!!!!');
    app = a;
  });
//  final FirebaseApp app;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('AutoAdventures'),
        ),
        body: HomeWidget(),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(child: DevicesWidget()),
//          RouterIpWidget(),
        ],
      ),
    );
  }
}

class Device {
  String name = 'asd', description = 'asd', id, currentState = 'asd';

  Device(
    this.id,
  );

  String nextValue(){
    if (this.name.contains("cozinha"))
      return this.currentState == 'on' ? 'off' : 'on';
    return this.currentState == 'on' ? 'off' : 'on';
  }
}

class DevicesWidget extends StatefulWidget {
  @override
  _DevicesWidgetState createState() => _DevicesWidgetState();
}

class _DevicesWidgetState extends State<DevicesWidget> {
  List<Device> devices;
  DatabaseReference _devicesRef;
  FirebaseDatabase database;

  @override
  void initState() {
    devices = List<Device>();
    database = FirebaseDatabase(app: app);
    _devicesRef = FirebaseDatabase.instance.reference().child('devices/');
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    _devicesRef.onChildAdded.listen((child) {
      print('Child is $child');
      setState(() => this.devices.add(Device(child.snapshot.key)));
    });
//    _devicesSubscription = _devicesRef.onValue.listen((event){
//      print(event.snapshot.value);
//      parseDevices(event.snapshot.value);
//    });
  }

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
//      fetchData();
      return ListTile(
        title: Text(' LOADING.......'),
        trailing: IconButton(
          icon: Icon(Icons.refresh),
//          onPressed: () => fetchData(),
        ),
      );
    }

    return ListView.builder(
        itemCount: devices.length,
        itemBuilder: (BuildContext context, int index) {
          return DeviceWidget(devices[index]);
        });
  }
}

class DeviceWidget extends StatefulWidget {
  Device device;

  DeviceWidget(this.device);

  @override
  _DeviceWidgetState createState() => _DeviceWidgetState();
}

class _DeviceWidgetState extends State<DeviceWidget> {
  Device device = null;
  bool hasLoaded = false;

  DatabaseReference _devicesRef;
  FirebaseDatabase database;

  @override
  void initState() {
    device = null;
    hasLoaded = false;
    print(this.widget.device.id);
    database = FirebaseDatabase(app: app);
    _devicesRef = FirebaseDatabase.instance
        .reference()
        .child('devices/${this.widget.device.id}');
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    _devicesRef.onValue.listen((dataSnap) {
      print('Updating device ${dataSnap.snapshot.value}');
      Map<dynamic, dynamic> data = dataSnap.snapshot.value;
      this.setState(() {
        this.widget.device.name = data['name'];
        this.widget.device.description = data['_type'];
        this.widget.device.currentState = data['state'];
        this.hasLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (device == null) device = widget.device;
    if (!hasLoaded)
      return ListTile(
        title: Text('LOADING...'),
      );

    return ListTile(
      title: Text(this.widget.device.name),
      trailing: Switch(
          value: device.currentState == 'on',
          onChanged: (value) {
            this._devicesRef.child('state').set(device.nextValue());
          }),
    );
  }
}

void showConnetionAlert(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Turn off 4G and connect to your wifi network'),
        );
      });
}
