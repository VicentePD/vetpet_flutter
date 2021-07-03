import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vetpet/database/dao/pet_dao.dart';
import 'package:vetpet/helpers/imagemutil.dart';
import 'package:vetpet/model/Pet.dart';
import 'dart:developer' as developer;
import 'cadastropet.dart';

class PetScreen extends StatefulWidget {
  final List<Pet> _pets = [];
  final String texto;

  PetScreen(this.texto);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PetScreenState();
  }
}

class PetScreenState extends State<PetScreen> {
  final PetDao _daopet = PetDao();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pets"),
      ),
      body: FutureBuilder<List<Pet>>(
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
                      Text('Loading')
                    ],
                  ),
                );
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:

                if (snapshot.data != null) {
                  final List<Pet>? pets = snapshot.data;
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final Pet pet = pets![index];
                      return ItemPet(pet);
                    },
                    itemCount: pets?.length,
                  );
                }
                else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('snapshot.data é nulo'),
                      ],
                    ),
                  );
                }
                break;
            }
            return Text("teste");
          }),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
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
      });

  }
}

class ItemPet extends StatelessWidget {
  final Pet _pet;

  ItemPet(this._pet);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: <Widget>[ ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xffFDCF09),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child:ImageUtility.imageFromBase64String(_pet.foto)
            ),
          ),
          title: Text(_pet.nome.toString()),
          subtitle: Text(_pet.nome.toString()),
        ),Row(mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[TextButton(
              child: const Text('BUY TICKETS'),
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CadastroPet(_pet.id);
    }));
    },
            )])]),

     );
  }
}
