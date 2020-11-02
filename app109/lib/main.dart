import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:app109/dataCenter.dart';
import 'package:app109/menu.dart';

void main() {
  runApp(MaterialApp(
    title: '돌봄로봇 백구',
    home: Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text('돌봄로봇 백구')),
      body: login(),
    ),
  ));
}

class login extends StatefulWidget {
  login({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {

  String _protName = 'name';
  String _protContact = 'contact';
  String _protId = 'id';
  String _delay = ' ';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('보호자 로그인', style: TextStyle(fontSize: 25)),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('이름'),
            Container(
              child: TextField(
                controller: TextEditingController(),
                style: TextStyle(fontSize: 21, color: Colors.black),
                textAlign: TextAlign.center,
                onChanged: (String str){
                  _protName = str;
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
            Text('연락처'),
            Container(
              child: TextField(
                controller: TextEditingController(),
                style: TextStyle(fontSize: 21, color: Colors.black),
                textAlign: TextAlign.center,
                onChanged: (String str){
                  _protContact = str;
                },
                decoration: InputDecoration(
                  //border: InputBorder.,
                  hintText: '숫자만 입력하세요',
                  hintStyle: TextStyle(fontSize: 15.0),
                ),
              ),
              width: 170,
              padding: EdgeInsets.only(left: 16),
            )
          ],
        ),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('로그인'),
              onPressed: () async {
                // fetch corresponding name to contact
                await fetchData(http.Client(), "prot_info/name", "contact", _protContact).then((fetchName) async {
                  String nowProtName = StrToList(fetchName)[0];
                  print(fetchName + " " + _protContact);
                  if(nowProtName == _protName){
                    print("--login success");
                    await fetchData(http.Client(), "prot_info/id", "contact", _protContact).then((fetchId) async {
                      print(fetchId);
                      String nowProtId = StrToList(fetchId)[0];
                      _protId = nowProtId;
                      setProtName(_protName);
                      setProtContact(_protContact);
                      setProtId(_protId);
                      await fetchData(http.Client(), "user_info/id", "prot_id", getProtId()).then((fetchUserId) async {
                        print(fetchUserId);
                        //setUserId(fetchUserId);
                        userIdList = StrToList(fetchUserId);
                        await fetchData(http.Client(), "user_info/name", "prot_id", getProtId()).then((fetchUserName) async {
                          //print(fetchName);
                          //setUserName(fetchUserName);
                          userNameList = StrToList(fetchUserName);
                          print(userIdList);
                          print(userNameList);
                          //print(getProtId() + " " + getProtName() + " " + getProtContact());
                          //print(getUserId() + " " + getUserName() + " " + getUserContact());
                          print("--fetch user info success");
                          Navigator.push( context, MaterialPageRoute(builder: (context) => menu()), );
                      });
                    });
                  });
                  } else {
                    setState(() { _delay = "prot info not found"; });
                  }
                });
              },
            ),
            SizedBox(width: 10),
            RaisedButton(
              child: Text('등록'),
              onPressed: () async {
                setState(() {});
                Map<String, dynamic> jsonBody = {'name': "'"+_protName+"'", 'contact': "'"+_protContact+"'",};
                await postData('prot_info',jsonBody).then((val) async {
                  await fetchData(http.Client(), "prot_info/id", "contact", _protContact).then((fetchId) {
                    print(fetchId);
                    _protId = fetchId;
                    setProtName(_protName);
                    setProtContact(_protContact);
                    setProtId(_protId);
                    Navigator.push( context, MaterialPageRoute(builder: (context) => menu()), );
                  });
                });
              },
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(_delay)
      ],
    );
  }
}