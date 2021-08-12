import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vetpet/database/dao/vacina_dao.dart';
import 'package:vetpet/helpers/importimagem.dart';
import 'package:vetpet/model/Pet.dart';
import 'package:vetpet/model/vacina.dart';
import 'package:vetpet/screen/vacinascreen.dart';

import 'cadastrovacina.dart';
import 'listavacina.dart';
import '../helpers/globals.dart' as globals;

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
    body: Center(
      child: Center(
        child:  Stack(
          children: <Widget>[
            listVacinas,
          ],
        ),
      ),),

      /*Container(
      child: Center(
        child: ListView(children: <Widget>[ListTile(
          leading: Icon(Icons.map),
          title: Text('Map'),
        ),
          ListTile(
            leading: Icon(Icons.photo_album),
            title: Text('Album'),
          ),]),
      ),


    )*/floatingActionButton: FloatingActionButton(
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
  final listVacinas = FutureBuilder<List<Vacina>>(
      initialData: [],
      future:  Vacina_Dao().findAllVacinas(0),
      builder: (context, snapshot) {
        Widget corp = Row(children:<Widget>[Text("Nenhum Pet Cadastrado")]);
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            corp = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text('Loading')
                ],
              ),
            );
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (snapshot.data != null) {
              final List<Vacina>? vacinas = snapshot.data;
              corp = ListView.builder(
                itemBuilder: (context, index) {
                  final Vacina vacina = vacinas![index];
                  return  SizedBox (
                    // height: height,
                      child:Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: Icon(Icons.medical_services),
                                title: Text("Vacina:" + vacina.nome_vacina.toString()),
                                subtitle: Text( "Data Aplicação:" +vacina.dataaplicacao.toString()+"\nData de Retorno: "
                                    + vacina.dataretorno.toString()),
                                isThreeLine:true,
                                onLongPress: () {Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return CadastroVacina(vacina.id);
                                    })).then(
                                      (value) => {},
                                );} ,
                                onTap:() {},
                              ),
                            ],
                          ))); //ItemPet(pet);
                },
                itemCount: vacinas?.length,
              );

            } else {
              corp = Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Nenhuma Vacina Cadastrada.'),
                  ],
                ),
              );
            }
            break;
        }
        return  corp ;
        //return Text("Nenhum Pet Cadastrado");
      });

  Future<List<Vacina>> listaVacinas( int IdPet){

    if(globals.idpetsel == 0)
    {
      return Vacina_Dao().findAllVacinas(0);
    }
    else{
      return Vacina_Dao().findAllVacinasPet(globals.idpetsel);
    }
  }
}
