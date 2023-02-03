// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, prefer_final_fields
import 'package:arquivo_central/globals/styles.dart';
import 'package:arquivo_central/login.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import "LocalizarProcesso.dart";
import 'GuardarProcesso.dart';
import 'package:get_storage/get_storage.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  get qrcode => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: 
        [
          //ICONE DE LOGOUT

          IconButton
          (
            icon: Icon(Icons.logout),
            onPressed: () async
            {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('login');
              prefs.remove('login');
              prefs.remove('isLoggedIn');
              prefs.remove('dtaUltimoLogin');
              Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => Login()),(_) => false,);
            },
          ),
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Arquivo Central"),
        backgroundColor: kazulEscuro,
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //BOTAO LOCALIZAR PROCESSO

                ElevatedButton(
                  child: const FittedBox(
                    child: Text("Localizar Processo"),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocalizarProcesso()));
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(130, 130),
                    primary: kazulEscuro,
                  ),
                ),

                //BOTAO GUARDAR PROCESSO

                ElevatedButton(
                  child: const FittedBox(
                    child: Text("Guardar Processo"),
                  ),
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment(0, 0),
                    fixedSize: Size(130, 130),
                    primary: kazulEscuro,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GuardarProcesso()),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
