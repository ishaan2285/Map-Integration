import 'dart:io';

import 'package:animation/Views/screens/Login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   Platform.isAndroid? await Firebase.initializeApp(options: FirebaseOptions(apiKey: 'AIzaSyCVNW-0zbjZsXthPP390WJS9MyhN-XXALk', appId: '1:131175613220:android:96d319ce52dc60975f29b1', messagingSenderId: '131175613220', projectId: 'store-ce7bf',storageBucket: 'gs://store-ce7bf.appspot.com')):await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
          useMaterial3: true,
        ),
        home: login()
    );
  }
}