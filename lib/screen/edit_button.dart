import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:icon_picker/icon_picker.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_otp/helper/helper.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_otp/model/button_edit_response.dart';
import 'package:firebase_otp/model/get_config_list.dart';
import 'package:firebase_otp/screen/config_screen.dart';
//import 'package:firebase_otp/screen/drawer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditButtonScreen extends StatefulWidget {
  final GetConfigList item;
  final int index;
  const EditButtonScreen(this.item, this.index, {Key key}) : super(key: key);
  @override
  _EditButtonScreenState createState() => new _EditButtonScreenState();
}

class _EditButtonScreenState extends State<EditButtonScreen> {
  List<GetConfigList> configList = [];
  bool _isLoading = true;
  String _selectedColor, codePoint;
  Map<String, dynamic> _selectedIcon;
  GetIconData _checkedIcon;
  bool isAdaptive = true;
  bool showTooltips = false;
  bool showSearch = true;
  var checkedIcon;
  List<ResultModel> resultModel = [];

  TextEditingController _idf1Controller;
  TextEditingController _idf2Controller;
  TextEditingController _idf3Controller;
  TextEditingController _idf4Controller;

  void alert(String alert){
    Fluttertoast.showToast(
      msg: alert,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.indigo,);
  }

  Future editButton() async {
    final updatedItem = GetConfigList(
      color: _selectedColor,
      name: widget.item.name,
      idk: widget.item.idk,
      ref: widget.item.ref,
      icon: codePoint,
      idf1: _idf1Controller.text,
      idf2: _idf2Controller.text,
      idf3: _idf3Controller.text,
      idf4: _idf4Controller.text,
    );

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var body = jsonEncode(<String, String>{
      'color': _selectedColor,
      'ref': widget.item.ref,
      'icon': codePoint,
      'idf1': _idf1Controller.text,
      'idf2': _idf2Controller.text,
      'idf3': _idf3Controller.text,
      'idf4': _idf4Controller.text,
    });
    final response = await http.post(Uri.encodeFull(baseUrl+'sedt.php'), headers: headers, body: body);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      resultModel = jsonResponse.map<ResultModel>((json) => ResultModel.fromJson(json)).toList();
      if(resultModel[0].result == true) {
        if(mainConfigList.length > 0) {
          for(int i = 0; i < mainConfigList.length; i++) {
            if(mainConfigList[i].idk == widget.item.idk && mainConfigList[i].ref == widget.item.ref) {
              mainConfigList[i] = updatedItem;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("savedConfigData", json.encode(mainConfigList));
            }
          }
        }
        setState(() {
          alert("${widget.item.name} has been updated successfully!");
          Navigator.push(context, MaterialPageRoute(builder: (context) => ConfigScreen()),);
        });
      } else {
        _editErrorDialog(context);
      }

    } else {
      throw Exception('Failed to edit button.');
    }


  }

  _changeColorDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, setState2) {
                return AlertDialog(
                  title: Text('Which color would you select?'),
                  content: Container(
                    width: double.maxFinite,
                    height: 280,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: colorNames.length,
                      itemBuilder: (BuildContext context, int index) {
                        return RadioListTile(
                          title: Text(colorNames[index].toUpperCase()),
                          value: colorNames[index],
                          groupValue: _selectedColor,
                          onChanged: (value) {
                            setState2(() {
                              _selectedColor = value;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('YES'),
                      onPressed: () {
                        setState(() {
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
    );
    setState(() {

    });
  }

  _editErrorDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, setState2) {
                return AlertDialog(
                  title: Text('Button editing is failed'),
                  content: Container(),
                );
              }
          );
        }
    );
  }

  _pickIcon() async {
    IconData icon = await FlutterIconPicker.showIconPicker(
      context,
      adaptiveDialog: false,
      showTooltips: showTooltips,
      showSearchBar: showSearch,
      iconPickerShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      iconPackMode: IconPack.lineAwesomeIcons,
    );

    if (icon != null) {
      setState(() {});
      _selectedIcon = iconDataToMap(icon);
      codePoint = _selectedIcon['codePoint'].toString();
    }
  }

  @override
  void initState() {
    _selectedColor = widget.item.color;
    codePoint = widget.item.icon;
    _idf1Controller = new TextEditingController(text: widget.item.idf1);
    _idf2Controller = new TextEditingController(text: widget.item.idf2);
    _idf3Controller = new TextEditingController(text: widget.item.idf3);
    _idf4Controller = new TextEditingController(text: widget.item.idf4);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()),);
        return false;
      },
      child: Scaffold(
        // resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Edit Button'),
          actions: <Widget>[
            IconButton(
              icon: Image.asset('assets/icon/close.png'),
              iconSize: 30,
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ConfigScreen()),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/icon/checkbox.png'),
              iconSize: 30,
              color: Colors.white,
              onPressed: () {
                setState(() {
                  editButton();
                });
              },
            ),
          ],
        ),
        drawer: Drawer(
         // child: DrawerScreen(),
        ),
        body: Container(
          width: width,
          height: height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: height*0.02,),
                Container(
                  child: Text(
                    widget.item.name,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: height*0.02,),
                Container(
                  width: width*0.9,
                  height: height*0.75,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            color: demoColors[_selectedColor],
                            child: codePoint != null ? Icon(
                              IconData(
                                int.parse(codePoint),
                                fontFamily: fontFamily,
                                fontPackage: fontPackage,
                                matchTextDirection: matchTextDirection,
                              ), size: 60, color: Colors.white,
                            ) : Container(),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 200,
                                height: 40,
                                child: RaisedButton(
                                  child: Text("Change Color", style: TextStyle(fontSize: 18, color: Colors.black),),
                                  onPressed: () {
                                    setState(() {
                                      _changeColorDialog(context);
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: BorderSide(color: Colors.lightBlue)
                                  ),
                                  color: Colors.white,
                                  padding: EdgeInsets.all(8.0),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                width: 200,
                                height: 40,
                                child: RaisedButton(
                                  child: Text("Change Icon", style: TextStyle(fontSize: 18, color: Colors.black),),
                                  onPressed: () {
                                    setState(() {
                                      _pickIcon();
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: BorderSide(color: Colors.lightBlue)
                                  ),
                                  color: Colors.white,
                                  padding: EdgeInsets.all(8.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 50,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: _idf1Controller,
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.color_lens),
                              labelText: 'idf1',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter idf1';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _idf2Controller,
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.drive_file_rename_outline),
                              labelText: 'idf2',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter idf2';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _idf3Controller,
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.drive_file_rename_outline),
                              labelText: 'idf3',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter valid idf3';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _idf4Controller,
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.drive_file_rename_outline),
                              labelText: 'idf4',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter valid idf4';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}