// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, prefer_final_fields
import 'package:arquivo_central/globals/styles.dart';
import 'package:arquivo_central/helpers/loginApi.dart';
import 'package:arquivo_central/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _crtLogin = TextEditingController();
  final _ctrlSenha = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? _validaLogin(String? texto) {
    if (texto!.isEmpty) {
      return "Digite o Login";
    }

    return null;
  }

  String? _validaSenha(String? texto) {
    if (texto!.isEmpty) {
      return "Digite a Senha";
    }

    return null;
  }

  void _btnEntrar_Click() async {
    bool formOk = _formkey.currentState!.validate();

    if (!formOk) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String login = _crtLogin.text.trim();
    String senha = _ctrlSenha.text.trim();

    var strRetornoAutenticacao = await loginApi.login(login, senha);

    if (strRetornoAutenticacao == "OK") {
      setState(() {
        _isLoading = false;
      });
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('login', login);
      prefs.setString('login', senha);
      prefs.setBool('isLoggedIn', true);
      prefs.setString('dtaUltimoLogin', DateTime.now().toString());
      Navigator.push(context, MaterialPageRoute(builder: (context) => home()));

      Navigator.push(context, MaterialPageRoute(builder: (context) => home()));
    } else {
      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('ATENÇAO'),
          content: const Text('Senha ou Login Incorretos'),
          actions: [
            TextButton(
              child: const Text("Tentar Novamente"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Arquivo Central'),
        centerTitle: true,
        backgroundColor: kazulEscuro,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Center(
                    child: Container(
                        width: 200,
                        height: 150,
                        /*decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50.0)),*/
                        child: Image.asset('assets/logo.png')),
                  ),
                ),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Login',
                      hintText: 'Digite o Login',
                    ),
                    controller: _crtLogin,
                    validator: _validaLogin,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Senha',
                        hintText: 'Digite a Senha'),
                    controller: _ctrlSenha,
                    validator: _validaSenha,
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: kazulEscuro,
                        borderRadius: BorderRadius.circular(20)),
                    child: /*TextButton
                (
                  child: Text('Login',style: TextStyle(color: Colors.white, fontSize: 25),),
                  onPressed: _btnEntrar_Click,
                ),*/
                        ElevatedButton.icon(
                      icon: _isLoading
                          ? CircularProgressIndicator()
                          : Icon(Icons.login),
                      label: Text(
                        _isLoading ? 'Processando...' : 'Entrar',
                        style: TextStyle(color: kbranco, fontSize: 25),
                      ),
                      onPressed:
                          _isLoading ? null : _btnEntrar_Click, //_startLoading,
                      style: ElevatedButton.styleFrom(
                          primary: kverde, fixedSize: Size(250, 50)),
                    )),
                SizedBox(
                  height: 130,
                ),
              ],
            )),
      ),
    );
  }
}
