import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:portalempleado/loginYregister/LoginPage.dart';
import 'package:portalempleado/MyHomePage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State createState() {
    return _MyAppState();
  }

}
class _MyAppState extends State<MyApp>{

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Portal del Empleado",
      home: LoginPage(),
    );

  }
}
