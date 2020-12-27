import 'package:dtmgtt/wrapper.dart';
import 'package:dtmgtt/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Do the mahi, get the treats',
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('ERROR');
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return AuthStream();
            }

            return Loading();
          }),
    );
  }
}
