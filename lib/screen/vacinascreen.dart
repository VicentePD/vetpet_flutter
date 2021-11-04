
import 'package:flutter/material.dart';
import 'package:vetpet/components/petselecionado.dart';

import 'package:vetpet/database/dao/vacina_dao.dart';
import 'package:vetpet/helpers/estilos.dart';
//import 'package:vetpet/helpers/imagemutil.dart';
import 'package:vetpet/model/vacina.dart';

import 'cadastros/cadastrovacina.dart';
import '../helpers/globals.dart' as globals;
//import 'dart:developer' as developer;

class VacinaScreen extends StatefulWidget {
  final String operacao;
  VacinaScreen({this.operacao=""});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VacinaScreenState();
  }
}

class VacinaScreenState extends State<VacinaScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        title: widget.operacao == ""? Text("Vacinas"): Text("Alerta Vacinas "),
      ),
      body: Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("asset/images/bgpata.png"),
    fit: BoxFit.cover,)),
    child: globals.idpetsel == 0 || widget.operacao != ""? _vacinaList(_atualiza)  :Column(
          children: <Widget>[Expanded(
            child: PetSelecionado(),
            flex: 0,
          ),Expanded(
        child: _vacinaList(_atualiza  ),
      )] )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,semanticLabel: "Incluir Vacina",),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CadastroVacina(0);
          })).then(
            (value) => _atualiza(),
          );
        },
      ),
    );
  }

  void _atualiza() {
    setState(() {});
  }

  FutureBuilder<List<Vacina>> _vacinaList(void Function() atualiza){

    return FutureBuilder<List<Vacina>>(
        initialData: [],
        future: widget.operacao == ""? Vacina_Dao().findAllVacinas(globals.idpetsel): Vacina_Dao().findVacinasVencendo() ,
        builder: (context, snapshot) {
          Widget corp = Row(children:<Widget>[Text("Nenhuma Vacina Cadastrada")]);
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
              if (snapshot.data != null &&  snapshot.data!.length >0 ) {
                final List<Vacina>? vacinas = snapshot.data;
               // developer.log("LISTA Vacina " +widget.operacao);
                corp = ListView.builder(
                  itemBuilder: (context, index) {
                    final Vacina vacina = vacinas![index];
                    final String nomePet = globals.idpetsel == 0 || widget.operacao != "" ? "Nome:"+ vacina.nomepet +"\n":"";
                    return  SizedBox (
                      // height: height,
                        child:Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.medical_services),
                                  title: Text("Vacina:" + vacina.nome_vacina.toString()),
                                  subtitle: Text( nomePet+"Data Aplicação:" +vacina.dataaplicacao.toString()+"\nData de Retorno: "
                                      + vacina.dataretorno.toString()),
                                  isThreeLine:true,
                                  onLongPress: () {Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return CadastroVacina(vacina.id);
                                      })).then(
                                        (value) => { atualiza()},
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
                      Text('Nenhuma Vacina Cadastrada.', style:  Estilos.EstiloTexto_1(),),
                    ],
                  ),
                );
              }
              break;
          }
          return  corp ;
        });
  }
}
