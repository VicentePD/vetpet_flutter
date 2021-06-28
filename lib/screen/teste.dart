import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vetpet/model/Pet.dart';

class NewPageScreen extends StatelessWidget {
  final String texto;
  final List<Pet> _pets = [];
  NewPageScreen(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ListView(children: <Widget>[ListTile(
          leading: Icon(Icons.map),
          title: Text('Map'),
        ),
          ListTile(
            leading: Icon(Icons.photo_album),
            title: Text('Album'),
          ),],),
      ),
    );
  }
}