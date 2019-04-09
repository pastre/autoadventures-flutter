import 'dart:async';
import 'dart:convert';

import 'package:autoadventures/io/Storage.dart';
import 'package:http/http.dart';
import 'package:connectivity/connectivity.dart';
//String domain = 'http://192.168.25.14:5000/';
//String domain = 'https://horariopucpr.herokuapp.com/';
String domain = '';

class Api {
  Storage s = new Storage();
  String username = '',
      password = '';

//  String notas = '', username = 'bruno.pastre', password = 'asdqwe123!@#';
  bool couldLogin = false;
  static final Api _singleton = new Api._internal();

  factory Api() {
    return _singleton;
  }

  Api._internal();

  _doGet(String url) async {
    var conn = await Connectivity().checkConnectivity();
    if(conn != ConnectivityResult.wifi) return null;
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(' Making request...');
    Response r = await get('$domain$url',
//      headers: {'authorization': basicAuth},).timeout(Duration(minutes: 5)
    );
    print(' Response is $r');
    return r.body;
  }

  _doPost(String url, var body) async {
    print('Basic post with $username, $password');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    Response r = await post('$domain$url',
        headers: {'authorization': basicAuth}, body: body);

    return r.body;
  }

  _doPut(String url, var body) async {
    print('Basic put with $username, $password');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    Response r = await put('$domain$url',
        headers: {'authorization': basicAuth}, body: body);

    return r.body;
  }

  _doDelete(String url) async {
    print('Basic put with $username, $password');
    url = Uri.encodeFull(url);
    print('URL IS $url');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

//    Response r = await delete('https://horariopucpr.herokuapp.com/$url',
//        headers: {'authorization': basicAuth}, );
    Response r = await delete('$domain$url',
      headers: {'authorization': basicAuth},);

    return r.body;
  }

  Future<String> getDevices() async{
    String routerIp = await Storage().getRouterIp();
    String url = 'http://' + routerIp + ':5000/devices/';
    return await _doGet( url);
  }

  Future<String> updateDevice(int deviceId) async{
    String routerIp = await Storage().getRouterIp();
    String url = 'http://' + routerIp + ':5000/devices/' + deviceId.toString() + '/update/';
    return  await _doGet( url);
  }
}

