// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, prefer_final_fields
import 'package:arquivo_central/home.dart';
import 'package:arquivo_central/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //var login      = prefs.getString('login');
    //var senha      = prefs.getString('senha');
    var isLoggedIn = prefs.getBool('isLoggedIn');
    String dtaUltimoLogin = prefs.getString('dtaUltimoLogin').toString();

    //se estiver isLoggedIn verifica se dtaultUltimoLogin tem mais de 15 dias
    //logou dia 14/05 ao entrar dia 28/05 (15 dias) renovar login
    if ((isLoggedIn != null && isLoggedIn == true) &&
        DateTime.now().difference(DateTime.parse(dtaUltimoLogin)).inDays < 15) {
      runApp(MaterialApp(
        home: home(),
      ));
    } else {
      runApp(MaterialApp(
       debugShowCheckedModeBanner: false,
        home: Login(),
      ));
    }

    //runApp(MaterialApp(debugShowCheckedModeBanner: false,home: Login(),));
  }

