
import 'package:flutter/material.dart';
import 'package:vetpet/components/petselecionado.dart';
import 'package:vetpet/database/dao/vacina_dao.dart';
import 'package:vetpet/helpers/imagemutil.dart';
import 'package:vetpet/model/vacina.dart';
import 'dart:developer' as developer;
import 'cadastropet.dart';
import 'cadastrovacina.dart';
import '../helpers/globals.dart' as globals;
class VacinaScreen extends StatefulWidget {
  final List<Vacina> _vacinas = [];
  final String texto;
  VacinaScreen(this.texto);
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
      appBar: AppBar(
        title: Text("Vacinas"),
      ),
      body:globals.idpetsel == 0? _vacinaList(_atualiza) :Column(
          children: <Widget>[Expanded(
            child: PetSelecionado(),
            flex: 0,
          ),Expanded(
        child: _vacinaList(_atualiza  ),
      )] ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
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
        future: Vacina_Dao().findAllVacinas(globals.idpetsel),
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
                      Text('Nenhuma Vacina Cadastrada.'),
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

class ItemPet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(globals.idpetsel == 0)
    {
      return Text("")   ;
    }
    return Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xffFDCF09) ,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: ImageUtility.imageFromBase64String(
                        globals.fotopetsel)),
              ),
              title: Text("Nome:" + globals.nomepetsel),
              subtitle: Text( "Data Nascimento:" + globals.datanascimentopet),
              isThreeLine:true,
              tileColor:  Colors.orange[100],
              // selected: selecionado,
            ),
          ],
        ));
  }
}
