import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:vetpet/components/editor.dart';
import 'package:vetpet/components/editordate.dart';
import 'package:vetpet/components/editortexto.dart';
import 'package:vetpet/dao/pet_dao.dart';
import 'package:vetpet/model/Pet.dart';
import 'dart:developer' as developer;

const _textoBotaoConfirmar = 'Confirmar';
enum TipoSexoSel { M, F }

class CadastroPet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CadastroPetState();
  }
}

class CadastroPetState extends State<CadastroPet> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorRaca = TextEditingController();
  final TextEditingController _controladordatanascimento =
      TextEditingController();
  final TextEditingController _controladorpelagem = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  TipoSexoSel? _sexoSel = TipoSexoSel.M;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cadastrar Pet"),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[Padding(
            padding: const EdgeInsets.only(left:00.0,top:8.0,right: 0,bottom: 0.0),
              child:CircleAvatar(
                  backgroundImage: NetworkImage("https://flic.kr/p/2iPfdFK"),
                  radius:60.0
                ))]),
                EditorTexto(_controladorNome,
                    rotulo: "Nome",
                    dica: "Nome do seu Pet",
                    icone: Icons.account_circle,obrigatorio: true),
                EditorDate(_controladordatanascimento,
                    rotulo: "Data de Nascimento",
                    dica: "DD/MM/YYYY",
                    icone: Icons.calendar_today,
                    teclado: TextInputType.datetime,
                    obrigatorio: true),
                EditorTexto(
                  _controladorpelagem,
                  rotulo: "Tipo de Pelagem",
                ),
                EditorTexto(_controladorRaca,
                    rotulo: "Raça", dica: "Raça", icone: Icons.account_circle),
                EditorTexto(_controladorNome,
                    rotulo: "Tipo",
                    dica: "Tipo do Pet",
                    icone: Icons.account_circle),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[Padding(
                        padding: const EdgeInsets.only(left:50.0,top:10.0,right: 0,bottom: 0.0),
                        child:
                      Text(
                        "Sexo",
                        style: TextStyle(fontSize: 16.0),
                      )
                    )]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: TipoSexoSel.M,
                        groupValue: _sexoSel,
                        onChanged: (TipoSexoSel? value) {
                          setState(() {
                            _sexoSel = value;
                          });
                        },
                      ),
                      Text(
                        "Macho",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Radio(
                        value: TipoSexoSel.F,
                        groupValue: _sexoSel,
                        onChanged: (TipoSexoSel? value) {
                          setState(() {
                            _sexoSel = value;
                          });
                        },
                      ),
                      Text(
                        "Fêmea",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ]),

                ElevatedButton(
                  child: Text(_textoBotaoConfirmar),
                  onPressed: () => _cadastrarPet(context),
                ),
              ],
            ),
          ),
        ));
  }

  void _cadastrarPet(BuildContext context) {
    final String nome = _controladorNome.text;
    final String datanascimento = _controladordatanascimento.text;
    final String pelagem = _controladorpelagem.text;
    final String raca = _controladorRaca.text;
    final String sexo = (_sexoSel!.index == 0) ? "M" : "F";
    final String tipo = "C";

    if ( _formKey.currentState!.validate()) {
      final pet = Pet(0, nome, datanascimento, pelagem, raca, sexo, tipo);
      final PetDao _daopet = PetDao();
      developer.log("teteeee $sexo");
      //_daopet.save(pet);
      Navigator.pop(context, pet);
    }
  }
}
