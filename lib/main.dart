import 'dart:async';
import 'dart:convert';

import 'package:autoadventures/io/Api.dart';
import 'package:autoadventures/io/Storage.dart';
import 'package:flutter/material.dart';

Api api = Api();

void main() async {
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
  String name = 'asd', description = 'asd', currentState = 'asd';
  int  id;

  Device(
    this.id,
  );

  Device.fromDict(dict){
    this.id = dict['id'];
    this.name = dict['name'].toString();
    this.description = dict['description'].toString();
    this.currentState = dict['currentState'].toString();
  }

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

  @override
  void initState() {
    devices = List<Device>();

//    _devicesSubscription = _devicesRef.onValue.listen((event){
//      print(event.snapshot.value);
//      parseDevices(event.snapshot.value);
//    });
  }

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      fetchData();
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

  void fetchData() {
    api.getDevices().then((devices){
      print("Devices are $devices");
      var newList = List<Device>();
      var parsed = json.decode(devices);
      parsed.forEach((data){
        newList.add(Device.fromDict(data));
      });
      setState(() {
        this.devices = newList;
      });
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


  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(this.widget.device.name),
      trailing: Switch(
          value: this.widget.device.currentState == '1',
          onChanged: (value) {
            updateDevice();
          }),
    );
  }

  void updateDevice() {
    api.updateDevice(this.widget.device.id).then((data){
      print('Data is $data');
      this.widget.device = Device.fromDict(json.decode(data));
      setState(() {

      });
    });
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
