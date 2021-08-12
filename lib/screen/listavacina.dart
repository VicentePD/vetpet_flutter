import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vetpet/database/dao/pet_dao.dart';
import 'package:vetpet/database/dao/vacina_dao.dart';
import 'package:vetpet/helpers/imagemutil.dart';
import 'package:vetpet/model/Pet.dart';
import 'package:vetpet/model/vacina.dart';
import 'dart:developer' as developer;
import 'cadastropet.dart';
import 'cadastrovacina.dart';
import '../helpers/globals.dart' as globals;
class ListaVacinaScreen extends StatelessWidget {
  final List<Vacina> _vacinas = [];
  final String texto;

  ListaVacinaScreen(this.texto);
  final Vacina_Dao _daovacina = Vacina_Dao();

  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder<List<Vacina>>(
          initialData: [],
          future: listaVacinas(globals.idpetsel),
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
  }


  Future<List<Vacina>> listaVacinas( int IdPet){
    if(globals.idpetsel == 0)
    {
      return _daovacina.findAllVacinas(IdPet);
    }
    else{
      return _daovacina.findAllVacinasPet(globals.idpetsel);
    }
  }
}

class ItemPet extends StatelessWidget {
  final Pet _pet;

  ItemPet(this._pet);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xffFDCF09),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: ImageUtility.imageFromBase64String(_pet.foto)),
          ),
          title: Text(_pet.nome.toString()),
          subtitle: Text(_pet.nome.toString()),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          TextButton(
            child: const Text('BUY TICKETS'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CadastroPet(_pet.id);
              }));
            },
          )
        ])
      ]),
    );
  }
}
