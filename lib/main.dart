import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'screen/config_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tittle',
      theme: ThemeData(
        primarySwatch: Colors.red, // si no tengo color en el item etonces sale este, pero me doy cuenta que el color del icono de la appbar de los 3 rayas cambia segun el colro qeu haya aqi por ejemplo green muestra en negro las 3 rayas
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<Object>(
        //stream: Stream.fromFuture(LoginService().readFromSP()),
        builder: (context, snapshot) {
          // User user = snapshot.data;
          if(snapshot.data == null){
            return ConfigScreen();
          }else{
            return ConfigScreen();
          }
        }
      ),
    );
  }
}
