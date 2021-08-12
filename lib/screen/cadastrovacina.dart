
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dart_date/dart_date.dart';
import 'package:vetpet/components/editordate.dart';
import 'package:vetpet/components/editortexto.dart';
import 'package:vetpet/components/msgalerta.dart';
import 'package:vetpet/components/petselecionado.dart';
import 'dart:io';
import 'package:vetpet/database/dao/pet_dao.dart';
import 'package:vetpet/database/dao/vacina_dao.dart';
import 'package:intl/intl.dart';

import 'dart:developer' as developer;

import 'package:vetpet/model/vacina.dart';
import 'package:vetpet/screen/petscreen.dart';
import '../helpers/globals.dart' as globals;


const _textoBotaoConfirmar = 'Salvar';

class CadastroVacina extends StatefulWidget {
final int idvacina;

  const CadastroVacina(this.idvacina) ;

  @override
  State<StatefulWidget> createState() {
    return CadastroVacinaState();
  }
}

class CadastroVacinaState extends State<CadastroVacina> {
  final TextEditingController _controladorNomeVacina = TextEditingController();
  late  TextEditingController _controladordataaplicacao = TextEditingController( );
  final TextEditingController _controladordataretorno =  TextEditingController();
  final TextEditingController _controladorveterinario = TextEditingController();
  final TextEditingController _controladortipo = TextEditingController();
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late  String imgString = "";
  final Vacina_Dao _daovacina = Vacina_Dao();
  late Vacina  vacina = Vacina(0,globals.idpetsel,"", "", "", "");
  late bool buscavacina = true;
  static const pattern = 'dd/MM/yyyy';
  final n = DateTime.now();
  final de_String = DateTime.now().format(pattern, 'pt_BR');
  late DateTime _dateTime;
  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_BR';
    //_initialValue = DateTime.now().toString();
    _controladordataaplicacao = TextEditingController( text:de_String);
    final de_Date = Date.parse(de_String, pattern: pattern, locale: 'pt_BR');
  }


  @override
  Widget build(BuildContext context) {

    if(widget.idvacina >0 && buscavacina )
      {_selectvacina(widget.idvacina);
      buscavacina = false;}
    return Scaffold(
        appBar: AppBar(
          title: widget.idvacina ==0 ?Text("Cadastrar Vacina"):Text("Editar Vacina"),
        ),
        body: SingleChildScrollView( child: Column(children: <Widget>[GestureDetector(
            onTap: () {
               if(globals.idpetsel == 0)
               {
                 Navigator.push(context, MaterialPageRoute(builder: (context) {
                   return PetScreen();
                 })).then(
                       (value) => setState(() {}),
                 );
               }
             },
        child: PetSelecionado(),
         ),   Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                EditorTexto(_controladorNomeVacina,
                    rotulo: "Nome Vacina",
                    dica: "Vacina Aplicada",
                    icone: Icons.medical_services,obrigatorio: true),
                EditorDate(_controladordataaplicacao,
                    rotulo: "Data da Aplicação",
                    dica: "DD/MM/YYYY",
                    icone: Icons.calendar_today,
                    teclado: TextInputType.datetime,
                    obrigatorio: true),
                EditorDate(_controladordataretorno,
                    rotulo: "Data de Retorno",
                    dica: "DD/MM/YYYY",
                    icone: Icons.calendar_today,
                    teclado: TextInputType.datetime,
                    obrigatorio: true),
                EditorTexto(
                  _controladorveterinario,
                  rotulo: "Veterinário",
                ),
                RaisedButton(
                  child: Text('Pick a date'),
                  onPressed:() { _selectDate(context);},
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [ElevatedButton(
                  child: Text(_textoBotaoConfirmar),
                  onPressed: () => _cadastrarVacina(context),
                ),Text(widget.idvacina > 0?"    ":""),widget.idvacina > 0? ElevatedButton(
          child: Text("Excluir"),
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red))  ,
          onPressed: () => _deleteVacina(context),
        ): Text(""),
                    ],),

              ],
            ),
          ),
        )] )));
  }
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        _controladordataretorno.text = DateFormat.yMd().format(picked);
      });
  }
  Future<void> _cadastrarVacina(BuildContext context) async {
    final String nome_vacina = _controladorNomeVacina.text;
    final String dataretorno = _controladordataretorno.text;
    final String dataaplicacao = _controladordataaplicacao.text;
    final String veterinario = _controladorveterinario.text;
    final int idpet = globals.idpetsel;

    if ( _formKey.currentState!.validate()) {

      if(widget.idvacina >0  )
        {
          final vacina = Vacina(widget.idvacina, idpet,nome_vacina, dataaplicacao, dataretorno, veterinario);

          _daovacina.updatePet(vacina,widget.idvacina) ;
          //Provider.of<PetDao>(context, listen: true).updatePet(pet,widget.idpet);
        }
      else
        {
          final vacina = Vacina(widget.idvacina, idpet,nome_vacina, dataaplicacao, dataretorno, veterinario);
          _daovacina.save(vacina) ;
        }
        if(idpet == 0){

        }

      Navigator.pop(context, vacina);
    }
  }
  _deleteVacina(BuildContext context){
    if(widget.idvacina >0  ){
      Widget cancelaButton = ElevatedButton(
        child: Text("Cancelar"),
        onPressed:  () {Navigator.of(context).pop(); },
      );
      Widget continuaButton = ElevatedButton(
        child: Text("Continar"),
        onPressed:  () {
          _daovacina.deletePet(widget.idvacina);
          Navigator.of(context).pop();
          Navigator.pop(context, vacina);},
      );


      //exibe o diálogo
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MsgAlerta(cancelaButton,continuaButton,"Confirma a Operação","Deseja Apagar A Vacina Selecionada?");
        },
      );
    }
  }

  _selectvacina(int id) async {

    _daovacina.findVacina(id).then((value) =>
    {
      setState(() {
        vacina = value;
        if(globals.idpetsel == 0){
          globals.idpetsel = vacina.id_pet;
          PetDao().findPet(vacina.id_pet).then((value) => {
            setState(() {
              globals.nomepetsel = value.nome;
              globals.datanascimentopet = value.datanascimento;
              globals.fotopetsel = value.foto;
            })
          });
        }

        _controladorNomeVacina.text = vacina.nome_vacina ;
        _controladordataretorno.text = vacina.dataretorno ;
        _controladordataaplicacao.text = vacina.dataaplicacao ;
        _controladorveterinario.text = vacina.veterinario ;
        imgString=  "";
      })
    });


  }

}
