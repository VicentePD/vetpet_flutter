import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vetpet/helpers/importimagem.dart';
import 'package:vetpet/model/Pet.dart';

class NewPageScreen extends StatefulWidget {
  final String texto;
  final List<Pet> _pets = [];

  NewPageScreen(this.texto);
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewPageScreenState();
  }
}
 class NewPageScreenState extends State<NewPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Pets"),
    ),
    body:Container(
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


    ),floatingActionButton: FloatingActionButton(
    child: Icon(Icons.add),
    onPressed: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
    return TestePet();
    })).then(
    (value) => _atualiza(),
    );
    },
    ),);
  }
  void _atualiza() {
    setState(() {
    });

  }
}
