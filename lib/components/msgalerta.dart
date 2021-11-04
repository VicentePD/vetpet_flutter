import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MsgAlerta extends StatelessWidget {


  late  AlertDialog alert;

  MsgAlerta(Widget cancel,Widget continua, String titulo, String msg ){
    this.alert = AlertDialog(
      title: Text(titulo),
      content: Text(msg),
      semanticLabel: titulo + ' ' + msg,
      actions: [
        cancel,
        continua,
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return alert;
  }




}