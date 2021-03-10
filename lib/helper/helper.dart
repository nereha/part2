
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_otp/model/get_config_list.dart';

String baseUrl = 'https://39372753.servicio-online.net/';

List<GetConfigList> mainConfigList = [];
List<String> buttonStatus = [];
final demoColors = {
  'red': Colors.red,
  'blue': Colors.blue,
  'green': Colors.green,
  'orange': Colors.orange,
  'yellow': Colors.yellow
};
List<String> colorNames = ['red', 'blue', 'green', 'orange', 'yellow'];
int pageNumber;
String fontFamily = 'LineAwesomeIcons', fontPackage = 'line_awesome_flutter';
bool matchTextDirection = false;