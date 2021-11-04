//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vetpet/database/dao/aviso_dao.dart';
//import 'package:provider/provider.dart';
import 'package:vetpet/database/dao/pet_dao.dart';
import 'package:vetpet/database/dao/vacina_dao.dart';
import 'package:vetpet/helpers/estilos.dart';
import 'package:vetpet/helpers/imagemutil.dart';
import 'package:vetpet/model/pet.dart';
//import 'dart:developer' as developer;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetpet/rotas/rotas.dart';
import 'cadastros/cadastropet.dart';
import '../helpers/globals.dart' as globals;

class PetScreen extends StatefulWidget {
  //final List<Pet> _pets = [];
  PetScreen();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PetScreenState();
  }
//return PetScreenState;
}

class PetScreenState extends State<PetScreen> {
  final PetDao _daopet = PetDao();
  late String msgVacina = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        title: Text("Pets"),
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("asset/images/bgpata.png"),
            fit: BoxFit.cover,
          )),
          child: Column(children: [
            Expanded(flex: 3, child: _petList(_atualiza)),
            Expanded(
              flex: 0,
              child: _vacinaVencendo(),
            ),
            Expanded(
              child: _avisoVencendo(),
            ),SizedBox(height: 15.h),
          ])),
      floatingActionButton: FloatingActionButton(mini: false,
        child: Icon(Icons.add,semanticLabel: "Incluir Pet"),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CadastroPet(0);
          })).then(
            (value) => _atualiza(),
          );
        },
      ),
    );
  }

  void _atualiza() {
    setState(() {
    //  developer.log("   ddd _atualiza");
    });
  }
  Widget _vacinaVencendo() {
    return SingleChildScrollView(child:FutureBuilder<String>(
      future: Vacina_Dao().findPetsComVacinasVencendo(),
      builder: (context, snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          children = <Widget>[
            Center(
              child: Card(
                child: InkWell(
                  splashColor: Colors.orange.withAlpha(30),
                  onTap: () {
                    Navigator.of(context).push(createRouteVacina());
                  },
                  child: Column(children: [ Row(mainAxisAlignment: MainAxisAlignment.center ,
                    children: [Icon(Icons.medical_services),Text('Alerta Vacinas.')],) ,SizedBox(
                     width: 300,
                  //  height: 100,
                    child: Text('${snapshot.data} \n'),
                  )],) ,
                ),
              ),
            )
          ];
        } else {
          children = <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Esperando a consulta...',
                style: Estilos.EstiloTextoBranco_1(),
              ),
            )
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
    ));
  }

  Widget _avisoVencendo() {
    return SingleChildScrollView(child: FutureBuilder<String>(
      future: AvisoDao().findPetsComAvisosVencendo(),
      builder: (context, snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          children = <Widget>[const SizedBox(width: 8),
            Center(
              child: Card(
                child: InkWell(
                  splashColor: Colors.orange.withAlpha(90),
                  onTap: () {
                    Navigator.of(context).push(createRouteAlerta());
                  },
                  child: Column(children: [ Row(mainAxisAlignment: MainAxisAlignment.center ,
                    children: [Icon(Icons.timer),Text(' Alerta Avisos.',semanticsLabel: "Alerta de Avisos Vecendo",)],) ,SizedBox(
                     width: 300,
                    //height: 100,
                    child: Text('${snapshot.data} \n',semanticsLabel:snapshot.data ),
                  )],) ,
                ),
              ),
            )
          ];
        } else {
          children = <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Esperando a consulta...',
                style: Estilos.EstiloTextoNegritoBranco_1(),
              ),
            )
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
    ));
  }

  FutureBuilder<List<Pet>> _petList(void Function() atualiza) {
    return FutureBuilder<List<Pet>>(
        initialData: [],
        future: _daopet.findAllPets(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text('Loading',style: Estilos.EstiloTextoNegritoBranco_1(),)
                  ],
                ),
              );
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (snapshot.data != null && snapshot.data!.length > 0) {
                final List<Pet>? pets = snapshot.data;
                if (snapshot.data!.length == 1) {
                  globals.idpetsel = pets!.first.id;
                  globals.nomepetsel = pets.first.nome;
                  globals.fotopetsel = pets.first.foto;
                  globals.datanascimentopet = pets.first.datanascimento;
                }
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final Pet pet = pets![index];
                    return Card(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: Color(0xffFDCF09),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: ImageUtility.imageFromBase64String(
                                    pet.foto)),
                          ),
                          title: Text("Nome:" + pet.nome.toString()),
                          subtitle: Text("Data Nascimento:" +
                              pet.datanascimento.toString() +
                              "\nTipo: " +
                              pet.tipo.toString()),
                          isThreeLine: true,

                          tileColor: globals.idpetsel == pet.id
                              ? Colors.orange[100]
                              : null,
                          // selected: selecionado,

                          onLongPress: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CadastroPet(pet.id);
                            })).then(
                              (value) => _atualiza(),
                            );
                          },
                          onTap: () {
                            if (globals.idpetsel == pet.id) {
                              globals.idpetsel = 0;
                              globals.nomepetsel = "";
                              globals.fotopetsel = "";
                              globals.datanascimentopet = "";
                            } else {
                              globals.idpetsel = pet.id;
                              globals.nomepetsel = pet.nome;
                              globals.fotopetsel = pet.foto;
                              globals.datanascimentopet = pet.datanascimento;
                            }
                            _atualiza();
                          },
                        ),
                      ],
                    ));
                  },
                  itemCount: pets?.length,
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Nenum Pet Cadastrado.',
                        style: Estilos.EstiloTextoNegritoBranco_1(),
                      ),
                    ],
                  ),
                );
              }
          }
          return Text("Nenhum Pet Cadastrado", style: Estilos.EstiloTexto_1());
        });
  }
}
