import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dart_date/dart_date.dart';

import 'package:vetpet/components/editordate.dart';
import 'package:vetpet/components/editortexto.dart';
import 'package:vetpet/components/msgalerta.dart';
import 'package:vetpet/components/petselecionado.dart';
import 'package:vetpet/database/dao/notificacao_dao.dart';

import 'package:vetpet/database/dao/pet_dao.dart';
import 'package:vetpet/database/dao/vacina_dao.dart';
import 'package:intl/intl.dart';
import 'package:vetpet/helpers/alertmsgutil.dart';

//import 'dart:developer' as developer;

import 'package:vetpet/model/vacina.dart';
import 'package:vetpet/screen/petscreen.dart';
import '../../helpers/globals.dart' as globals;

const _textoBotaoConfirmar = 'Salvar';
enum TipoSexoSel { M, F }
class CadastroVacina extends StatefulWidget {
  final int idvacina;

  const CadastroVacina(this.idvacina);

  @override
  State<StatefulWidget> createState() {
    return CadastroVacinaState();
  }
}

class CadastroVacinaState extends State<CadastroVacina> {
  final TextEditingController _controladorNomeVacina =   TextEditingController();
  late TextEditingController _controladordataaplicacao = TextEditingController();
  late TextEditingController _controladordataretorno =   TextEditingController();
  final TextEditingController _controladorveterinario =  TextEditingController();
  final  _formKey = GlobalKey<FormState>();
  late String imgString = "";
  final Vacina_Dao _daovacina = Vacina_Dao();
  late Vacina vacina = Vacina(0, globals.idpetsel, "", "", "", "");
  late bool buscavacina = true;
  static const pattern = 'dd/MM/yyyy';
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_BR';
    //_initialValue = DateTime.now().toString();
    _controladordataaplicacao =
        TextEditingController(text: DateTime.now().format(pattern, 'pt_BR'));
    _controladordataretorno = TextEditingController(
        text: DateTime(DateTime.now().year + 1, DateTime.now().month,
                DateTime.now().day)
            .format(pattern, 'pt_BR'));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.idvacina > 0 && buscavacina) {
      _selectvacina(widget.idvacina);
      buscavacina = false;
    }

    return Scaffold(
        appBar: AppBar(
          title: widget.idvacina == 0
              ? Text("Cadastrar Vacina")
              : Text("Editar Vacina"),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          GestureDetector(
            onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PetScreen();
                })).then(
                  (value) => setState(() {}),
                );
            },
            child: PetSelecionado(),
          ),
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  EditorTexto(_controladorNomeVacina,
                      rotulo: "Nome Vacina",
                      dica: "Vacina Aplicada",
                      icone: Icons.medical_services,
                      obrigatorio: true),
                  EditorDate(_controladordataaplicacao,
                      rotulo: "Data da Aplica????o",
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
                    rotulo: "Veterin??rio",
                  ),
                  CheckboxListTile(title:Text("Inativar noticica????es"),
                    checkColor: Colors.white,
                    value: isChecked,
                      selected:false,
                    onChanged: widget.idvacina == 0 ? null :(bool? newValue) => {
                      setState(() {
                        isChecked = newValue!;
                      })
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      widget.idvacina > 0 ? ElevatedButton(
                              child: Text("Excluir"),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red)),
                              onPressed: () => _deleteVacina(context),
                            )

                          : Text(""),

                      Text(widget.idvacina > 0 ? "    " : ""),
                      ElevatedButton(
                        child: Text(_textoBotaoConfirmar),
                        onPressed: () => _cadastrarVacina(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ])));
  }

  Future<void> _cadastrarVacina(BuildContext context) async {
    final String nomevacina = _controladorNomeVacina.text;
    final String dataretorno = _controladordataretorno.text;
    final String dataaplicacao = _controladordataaplicacao.text;
    final String veterinario = _controladorveterinario.text;
    final int idpet = globals.idpetsel;
    if (_formKey.currentState!.validate() && idpet != 0) {
      if (widget.idvacina > 0) {
        final vacina = Vacina(widget.idvacina, idpet, nomevacina, dataaplicacao,
            dataretorno, veterinario);
        //Inativar Notifica????o
        String statusNotificacaoVacina = "A";
        if(isChecked){
          statusNotificacaoVacina = "S";
        }
        _daovacina.updateVacina(vacina, widget.idvacina,statusNotificacaoVacina);
        //Provider.of<PetDao>(context, listen: true).updatePet(pet,widget.idpet);
      } else {
        final vacina = Vacina(widget.idvacina, idpet, nomevacina, dataaplicacao,
            dataretorno, veterinario);
        _daovacina.save(vacina);
      }

      Navigator.pop(context, vacina);
    } else {
      if (idpet == 0) {
        AlertMsgUtil.showMsg(context, () {
          Navigator.of(context).pop();
        }, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PetScreen();
          })).then(
            (value) => setState(() {Navigator.of(context).pop();}),
          );

        },titulo:"Selecione o Pet",
        texto: 'Selecione o Pet que deseja cadastrar a Vacina');
      }
    }
  }

  _deleteVacina(BuildContext context) {
    if (widget.idvacina > 0) {
      Widget cancelaButton = ElevatedButton(
        child: Text("Cancelar"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      Widget continuaButton = ElevatedButton(
        child: Text("Continar"),
        style:ButtonStyle( backgroundColor:  MaterialStateProperty.all<Color>(Colors.red) ),
        onPressed: () {
          _daovacina.deleteVacina(widget.idvacina);
          Navigator.of(context).pop();
          Navigator.pop(context, vacina);
        },
      );

      //exibe o di??logo
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MsgAlerta(cancelaButton, continuaButton, "Confirma a Opera????o",
              "Deseja Apagar A Vacina Selecionada?");
        },
      );
    }
  }

  _selectvacina(int id) async {
    //developer.log("Seleciona Vacina " +id.toString());
    NotificacaoDao _daonotificacao = new NotificacaoDao();
    _daonotificacao.findNotificacaoVacina(id).then((value) => {
      setState(() {
        if(value.status != "A"){
          isChecked = true;
         }
      })
    });
    _daovacina.findVacina(id).then((value) => {
          setState(() {
            vacina = value;
            if (globals.idpetsel == 0) {
              globals.idpetsel = vacina.id_pet;
              PetDao().findPet(vacina.id_pet).then((value) => {
                    setState(() {
                      globals.nomepetsel = value.nome;
                      globals.datanascimentopet = value.datanascimento;
                      globals.fotopetsel = value.foto;
                    })
                  });
            }

            _controladorNomeVacina.text = vacina.nome_vacina;
            _controladordataretorno.text = vacina.dataretorno;
            _controladordataaplicacao.text = vacina.dataaplicacao;
            _controladorveterinario.text = vacina.veterinario;
            imgString = "";
          })
        });
  }
}
