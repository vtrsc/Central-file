import 'package:flutter/material.dart';

class AlertPersonalizado extends StatelessWidget {
  const AlertPersonalizado(
      {required this.msg, required this.tipo, required this.statusCode});
  final String msg;
  final String tipo;
  final String statusCode;

  void tratamendoLogin() {}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(tipo),
      content: Text(msg),
    );
  }
}
