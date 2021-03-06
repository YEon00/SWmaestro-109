import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:ssh/ssh.dart';
import 'package:app109/dataCenter.dart';

class ssh extends StatefulWidget {
  ssh({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _sshState createState() => _sshState();
}

class _sshState extends State<ssh> {
  String _result = '';
  List _array;
  String _ip = '';
  String _ssid = '';
  String _psk = '';
  String _userId = '';

  @override
  initState(){
    _userId = StrToList(getUserId())[0];
    super.initState();
  }

  Future<void> onClickCmd() async {
    var client = new SSHClient(
      host: _ip,
      //host: "172.16.101.11",
      port: 22,
      username: "pi",
      passwordOrKey: "raspberry",
    );
    //print("ssh ip " + _ip);
    String result;
    //try {
    result = await client.connect();
    if (result == "session_connected") {
      await client.execute("echo 'network={' | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf");
      await client.execute("echo '\tssid=\"" + _ssid + "\"' | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf");
      await client.execute("echo '\tpsk=\"" + _psk + "\"' | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf");
      await client.execute("echo '\tkey_mgmt=WPA-PSK' | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf");
      await client.execute("echo '\tscan_ssid=1' | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf");
      await client.execute("echo '}' | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf");
      await client.execute("echo '" + _ssid + "' | sudo tee -a /etc/ssid_list.txt");
      await client.execute("echo '" + _userId + "' | sudo tee -a ~/robot109/data/user_info.txt");
      await client.execute("sudo reboot");
    }
    client.disconnect();
    print("register");
    //}
    //} on PlatformException catch (e) {
    //print('Error: ${e.code}\nError Message: ${e.message}');
    //}

    setState(() {
      _result = result;
      _array = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('???????????? ??????'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget> [
          Text('???????????? ??????', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
          SizedBox(height: 40),
          Text('???????????? ????????? ??????'),
          SizedBox(height: 10),
          Text('\'RPi WiFi\'??? ??????????????????'),
          SizedBox(height: 10),
          Text('????????? IP ????????? ??????????????????'),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('IP ??????'),
              Container(
                child: TextField(
                  controller: TextEditingController(),
                  style: TextStyle(fontSize: 21, color: Colors.black),
                  textAlign: TextAlign.center,
                  onChanged: (String str){
                    _ip = str;
                  },
                ),
                width: 170,
                padding: EdgeInsets.only(left: 16),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('SSID'),
              Container(
                child: TextField(
                  controller: TextEditingController(),
                  style: TextStyle(fontSize: 21, color: Colors.black),
                  textAlign: TextAlign.center,
                  onChanged: (String str){
                    _ssid = str;
                  },
                ),
                width: 170,
                padding: EdgeInsets.only(left: 16),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('????????????'),
              Container(
                child: TextField(
                  controller: TextEditingController(),
                  style: TextStyle(fontSize: 21, color: Colors.black),
                  textAlign: TextAlign.center,
                  onChanged: (String str){
                    _psk = str;
                  },
                ),
                width: 170,
                padding: EdgeInsets.only(left: 16),
              )
            ],
          ),
          SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("??????", style: TextStyle(fontSize: 20, color: Colors.white)),
                onPressed: onClickCmd,
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(50.0)
                ),
                color: Colors.blue,
              ),
              SizedBox(width: 40),
              RaisedButton(
                child: Text("????????????", style: TextStyle(fontSize: 20, color: Colors.white)),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(50.0)
                ),
                color: Colors.blue,
              )
            ]
          ),
          //SizedBox(height: 50),
          //Text(_result),
          ]
      )
    );
  }
}