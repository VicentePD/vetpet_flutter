
import 'package:flutter/material.dart';
import 'package:vetpet/components/petselecionado.dart';
import 'package:vetpet/database/dao/aviso_dao.dart';

import 'package:vetpet/helpers/imagemutil.dart';
import 'package:vetpet/model/aviso.dart';

import 'cadastros/cadastroaviso.dart';
import 'cadastros/cadastrovacina.dart';
import '../helpers/globals.dart' as globals;
class AvisoScreen extends StatefulWidget {
 // final List<Vacina> _vacinas = [];
  final String texto;
  AvisoScreen(this.texto);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AvisoScreenState();
  }
}

class AvisoScreenState extends State<AvisoScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alertas"),
      ),
      body: Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("asset/images/_MG_9521.jpg"),
    fit: BoxFit.cover,)),
    child:globals.idpetsel == 0? _avisoList(_atualiza) :Column(
          children: <Widget>[Expanded(
            child: PetSelecionado(),
            flex: 0,
          ),Expanded(
            child: _avisoList(_atualiza  ),
          )] )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CadastroAviso(0);
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

  FutureBuilder<List<Aviso>> _avisoList(void Function() atualiza){

    return FutureBuilder<List<Aviso>>(
        initialData: [],
        future: AvisoDao().findAllAvisos(globals.idpetsel),
        builder: (context, snapshot) {
          Widget corp = Row(children:<Widget>[Text("Nenhum Aviso Cadastrado!")]);
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
              if (snapshot.data != null && snapshot.data!.isNotEmpty  ) {
                final List<Aviso>? avisos = snapshot.data;
                corp = ListView.builder(
                  itemBuilder: (context, index) {
                    final Aviso aviso = avisos![index];
                    final String NomePet = globals.idpetsel == 0? "Nome:"+ aviso.nomepet +"\n":"";
                    return  SizedBox (
                      // height: height,
                        child:Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.timer),
                                  title: Text("Aviso:" + aviso.nomeaviso.toString()),
                                  subtitle: Text(NomePet + "Data Do Cadastro:" +aviso.datacadastro.toString()+"\nData de Expiração: "
                                      + aviso.datavencimento.toString()),
                                  isThreeLine:true,
                                  onLongPress: () {Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return CadastroAviso(aviso.id);
                                      })).then(
                                        (value) => { atualiza()},
                                  );} ,
                                  onTap:() {},
                                ),
                              ],
                            ))); //ItemPet(pet);
                  },
                  itemCount: avisos?.length,
                );
              } else {
                corp = Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Nenhum Aviso Cadastrado.'),
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
