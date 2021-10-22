import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dart_date/dart_date.dart';
import 'package:vetpet/components/editordate.dart';
import 'package:vetpet/components/editortexto.dart';
import 'package:vetpet/components/msgalerta.dart';
import 'package:vetpet/components/petselecionado.dart';
import 'package:vetpet/database/dao/aviso_dao.dart';
import 'package:vetpet/database/dao/notificacao_dao.dart';
import 'package:vetpet/database/dao/pet_dao.dart';
import 'package:intl/intl.dart';
import 'package:vetpet/helpers/alertmsgutil.dart';
import 'package:vetpet/model/aviso.dart';
import 'package:vetpet/model/notificacao.dart';
import 'package:vetpet/screen/petscreen.dart';
import '../../helpers/globals.dart' as globals;
import 'dart:developer' as developer;
const _textoBotaoConfirmar = 'Salvar';

class CadastroAviso extends StatefulWidget {
  final int idaviso;

  const CadastroAviso(this.idaviso);

  @override
  State<StatefulWidget> createState() {
    return CadastroAvisoState();
  }
}

class CadastroAvisoState extends State<CadastroAviso> {
  final TextEditingController _controladorNomeAviso = TextEditingController();
  late TextEditingController _controladordatacadastro = TextEditingController();
  late TextEditingController _controladordatavencimento =
      TextEditingController();
  final TextEditingController _controladorDescricao = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String imgString = "";
  final AvisoDao _daoaviso = AvisoDao();
  late Aviso aviso = Aviso(0, globals.idpetsel, "", "", "", "");
  late bool buscaaviso = true;
  static const pattern = 'dd/MM/yyyy';
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_BR';
    //_initialValue = DateTime.now().toString();
    _controladordatacadastro =
        TextEditingController(text: DateTime.now().format(pattern, 'pt_BR'));
    _controladordatavencimento = TextEditingController(
        text: DateTime(DateTime.now().year, DateTime.now().month + 1,
                DateTime.now().day)
            .format(pattern, 'pt_BR'));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.idaviso > 0 && buscaaviso) {
      _selectaviso(widget.idaviso);
      buscaaviso = false;
    }
    return Scaffold(
        appBar: AppBar(
          title: widget.idaviso == 0
              ? Text("Cadastrar Aviso")
              : Text("Editar Aviso"),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          GestureDetector(
            onTap: () {
              if (globals.idpetsel == 0) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PetScreen();
                })).then(
                  (value) => setState(() {}),
                );
              }
            },
            child: PetSelecionado(),
          ),
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  EditorTexto(_controladorNomeAviso,
                      rotulo: "Aviso",
                      dica: "Nome do Aviso",
                      icone: Icons.alarm_on,
                      obrigatorio: true),
                  EditorDate(_controladordatacadastro,
                      rotulo: "Data do Cadastro",
                      dica: "DD/MM/YYYY",
                      icone: Icons.calendar_today,
                      teclado: TextInputType.datetime,
                      obrigatorio: true),
                  EditorDate(_controladordatavencimento,
                      rotulo: "Data de Expiração",
                      dica: "DD/MM/YYYY",
                      icone: Icons.calendar_today,
                      teclado: TextInputType.datetime,
                      obrigatorio: true),
                  EditorTexto(
                    _controladorDescricao,
                    rotulo: "Descrição",
                  ),
                  CheckboxListTile(title:Text("Inativar noticicações"),
                    checkColor: Colors.white,
                    value: isChecked,
                    selected:false,
                    onChanged: widget.idaviso == 0 ? null :(bool? newValue) => {
                      setState(() {
                        isChecked = newValue!;
                      })
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.idaviso > 0
                          ? ElevatedButton(
                        child: Text("Excluir"),
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(
                                Colors.red)),
                        onPressed: () => _deleteVacina(context),
                      )
                          : Text(""),
                      Text(widget.idaviso > 0 ? "    " : ""),
                      ElevatedButton(
                        child: Text(_textoBotaoConfirmar),
                        onPressed: () => _cadastrarAviso(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ])));
  }

  /* Future<Null> _selectDate(BuildContext context) async {
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
  }*/
  Future<void> _cadastrarAviso(BuildContext context) async {
    final String nomeaviso = _controladorNomeAviso.text;
    final String datavencimento = _controladordatavencimento.text;
    final String datacadastro = _controladordatacadastro.text;
    final String descricao = _controladorDescricao.text;
    final int idpet = globals.idpetsel;
    final NotificacaoDao notificacaoDao = new NotificacaoDao();

    if (_formKey.currentState!.validate() && idpet != 0) {
      if (widget.idaviso > 0) {
        final aviso = Aviso(widget.idaviso, idpet, nomeaviso, datacadastro,
            datavencimento, descricao);
        String statusNotificacaoVacina = "A";
        if(isChecked){
          statusNotificacaoVacina = "S";
        }
        _daoaviso.updateAviso(aviso, widget.idaviso,statusNotificacaoVacina);
      } else {
        final aviso = Aviso(widget.idaviso, idpet, nomeaviso, datacadastro,
            datavencimento, descricao);

         _daoaviso.save(aviso).then((value) => (){

           final Notificacao notificacao = new Notificacao(0,0,value,idpet,datacadastro,"",datavencimento,'A');
           notificacaoDao.save(notificacao);
         });
      }

      Navigator.pop(context, aviso);
    } else {
      if (idpet == 0) {
        AlertMsgUtil.showMsg(context, () {
          Navigator.of(context).pop();
        }, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PetScreen();
          })).then(
            (value) => setState(() {
              Navigator.of(context).pop();
            }),
          );
        },
            titulo: "Selecione o Pet",
            texto: 'Selecione o Pet que deseja cadastrar o Aviso');
      }
    }
  }

  _deleteVacina(BuildContext context) {
    if (widget.idaviso > 0) {
      Widget cancelaButton = ElevatedButton(
        child: Text("Cancelar"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      Widget continuaButton = ElevatedButton(
        style:ButtonStyle( backgroundColor:  MaterialStateProperty.all<Color>(Colors.red) ),
        child: Text("Continar"),
        onPressed: () {
          _daoaviso.deleteAviso(widget.idaviso);
          Navigator.of(context).pop();
          Navigator.pop(context, aviso);
        },
      );

      //exibe o diálogo
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MsgAlerta(cancelaButton, continuaButton, "Confirma a Operação",
              "Deseja Apagar o Aviso Selecionado?");
        },
      );
    }
  }

  _selectaviso(int id) async {
    NotificacaoDao _daonotificacao = new NotificacaoDao();
    _daonotificacao.findNotificacaoAviso(id).then((value) => {
      setState(() {
        if(value.status != "A"){
          isChecked = true;
        }
      })
    });
    _daoaviso.findAviso(id).then((value) => {
          setState(() {
            aviso = value;
            if (globals.idpetsel == 0) {
              globals.idpetsel = aviso.idpet;
              PetDao().findPet(aviso.idpet).then((value) => {
                    setState(() {
                      globals.nomepetsel = value.nome;
                      globals.datanascimentopet = value.datanascimento;
                      globals.fotopetsel = value.foto;
                    })
                  });
            }

            _controladorNomeAviso.text = aviso.nomeaviso;
            _controladordatavencimento.text = aviso.datavencimento;
            _controladordatacadastro.text = aviso.datacadastro;
            _controladorDescricao.text = aviso.descricao;
            imgString = "";
          })
        });
  }
}
