import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_otp/helper/helper.dart';
import 'package:firebase_otp/model/get_config_list.dart';
//import 'package:firebase_otp/screen/drawer_screen.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_otp/screen/edit_button.dart';
import 'package:firebase_otp/screen/loader_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigScreen extends StatefulWidget {
  @override
  _ConfigScreenState createState() => new _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  bool _isLoading = true;
  List<GetConfigList> configListFromServer = [];

  final icons = [Icons.local_post_office_outlined, Icons.outlined_flag_rounded,
    Icons.library_books];

  getDataFromServer() async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.get(Uri.encodeFull(baseUrl+'apill.php'), headers: headers);
    if(response.statusCode == 200) {
      configListFromServer.clear();
      buttonStatus.clear();
      List<dynamic> jsonResponse = new List<dynamic>();
      jsonResponse = json.decode(response.body);
      // configListFromServer = jsonResponse.map<GetConfigList>((json) => GetConfigList.fromJson(json)).toList();
      for(int i=0; i<jsonResponse.length; i++) {
        Map<String, dynamic> map = jsonResponse[i];
        configListFromServer.add(GetConfigList.fromJson(map));
        buttonStatus.add("false");

        if(mainConfigList.length > 0) {
          for(int j=0; j<mainConfigList.length; j++) {
            if(configListFromServer[i].idk == mainConfigList[j].idk) {
              buttonStatus[i] = 'true';
            }
          }
        }
      }
    } else {
      throw Exception('Failed to fetch data');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future uploadToMain(int index, String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mainConfigList.add(configListFromServer[index]);
      prefs.setString("savedConfigData", json.encode(mainConfigList));
      buttonStatus[index] = status;
    });
  }

  Future _deleteConfirmDialog(BuildContext context, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure to delete?'),
            actions: <Widget>[
              FlatButton(
                child: const Text('YES'),
                onPressed: () {
                  setState(() {
                    buttonStatus[index] = 'false';
                    for(int i = 0; i < mainConfigList.length; i++) {
                      if(mainConfigList[i].idk == configListFromServer[index].idk && mainConfigList[i].ref == configListFromServer[index].ref) {
                        mainConfigList.removeAt(i);
                      }
                    }
                    prefs.setString("savedConfigData", json.encode(mainConfigList));
                    alert("BUTON DELETED");
                    Navigator.of(context).pop();
                  });
                },
              ),
              FlatButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }


  void alert(String alert){
    Fluttertoast.showToast(
      msg: alert,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.indigo,);
  }

  @override
  void initState() {
    getDataFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
       // Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()),);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xff6fc560),
          title: Text('Config Page'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.home),
                iconSize: 30,
                onPressed: () => {
                  setState(() {
                    pageNumber = 1;
                  }),
                 // Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()),)
                }),
          ],
        ),
        drawer: Drawer(
          //child: DrawerScreen(),
        ),
        body: _isLoading ? LoaderScreen()
            : Container(
          width: width,
          height: height,
          child: Column(
            children: <Widget>[
              SizedBox(height: height*0.02,),
              Container(
                child: Text(
                  'Available Buttons',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: height*0.02,),
              Container(
                width: width*0.9,
                height: height*0.75,
                child: ListView.builder(
                    itemCount: configListFromServer.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white70,
                        elevation: 10,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(2.0),
                              width: width*0.26,
                              height: width*0.26,
                              color: demoColors[configListFromServer[index].color],
                              child: configListFromServer[index].icon != null ? Icon(
                                 IconData(
                                  int.parse(configListFromServer[index].icon),
                                  fontFamily: fontFamily,
                                  fontPackage: fontPackage,
                                  matchTextDirection: matchTextDirection,
                                ), size: 60, color: Colors.white,
                              ) : Container(),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: width * 0.35,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text(
                                      configListFromServer[index].name,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width * 0.35,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: configListFromServer[index].ref != null ? Text(
                                      configListFromServer[index].ref,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ) : Container(),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 30.0, right: 15.0),
                              width: 50,
                              child: GestureDetector(
                                child: Image(
                                  image: AssetImage('assets/icon/edit.png'),
                                  color: Colors.black,
                                  fit: BoxFit.fill,
                                ),
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => EditButtonScreen(configListFromServer[index], index)),
                                    );
                                  });
                                },
                              ),
                            ),
                            buttonStatus[index] == 'false' ? Container(
                              padding: EdgeInsets.only(top: 30.0),
                              child: GestureDetector(
                                child: Icon(Icons.cloud_download, size: 40, color: Colors.black,),
                                onTap: () {
                                  setState(() {
                                    uploadToMain(index, "true");
                                    alert("Button added");
                                  });
                                },
                              ),
                            ) : Container(
                              padding: EdgeInsets.only(top: 30.0),
                              child: GestureDetector(
                                child: Icon(Icons.delete, size: 40, color: Colors.black,),
                                onTap: () {
                                  setState(() {
                                    _deleteConfirmDialog(context, index);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}