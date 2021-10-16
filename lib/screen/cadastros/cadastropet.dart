import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vetpet/components/editordate.dart';
import 'package:vetpet/components/editortexto.dart';
import 'package:vetpet/components/msgalerta.dart';
import 'package:vetpet/database/dao/notificacao_dao.dart';
import 'dart:io';
import 'package:vetpet/database/dao/pet_dao.dart';
import 'package:intl/intl.dart';
import 'package:dart_date/dart_date.dart';
import 'package:vetpet/helpers/globals.dart';
import 'package:vetpet/helpers/imagemutil.dart';
import 'package:vetpet/model/pet.dart';
import 'dart:developer' as developer;



const _textoBotaoConfirmar = 'Salvar';
enum TipoSexoSel { M, F }

class CadastroPet extends StatefulWidget {
final int idpet;

  const CadastroPet(this.idpet) ;

  @override
  State<StatefulWidget> createState() {
    return CadastroPetState();
  }
}

class CadastroPetState extends State<CadastroPet> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorRaca = TextEditingController();
  late TextEditingController _controladordatanascimento =  TextEditingController();
  final TextEditingController _controladorpelagem = TextEditingController();
  final TextEditingController _controladortipo = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TipoSexoSel? _sexoSel = TipoSexoSel.M;
  late  String imgString = "";
  final PetDao _daopet = PetDao();
  late Pet  pet = Pet(0, "", "", "", "", "", "", "");
  late bool buscapet = true;

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_BR';
    //_initialValue = DateTime.now().toString();
    _controladordatanascimento =
        TextEditingController(text: DateTime.now().format(pattern, 'pt_BR'));

  }
  @override
  Widget build(BuildContext context) {
   // pet = _daopet.findPet(widget.idpet);
    if(widget.idpet >0 && buscapet )
      {_selectpet(widget.idpet);
      buscapet = false;}
    return Scaffold(
        appBar: AppBar(
          title: widget.idpet ==0 ?Text("Cadastrar Pet"):Text("Editar Pet"),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[Padding(
            padding: const EdgeInsets.only(left:00.0,top:8.0,right: 0,bottom: 0.0),
                child:GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child:CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xffFDCF09),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(55),
                        child:imgString.isEmpty?  Image.asset("asset/images/_MG_9521.jpg"):
                        ImageUtility.imageFromBase64String(imgString)
                    ),

                ),),
              ),]),
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
                EditorTexto(_controladortipo,
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
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [ElevatedButton(
                  child: Text(_textoBotaoConfirmar),
                  onPressed: () => _cadastrarPet(context),
                ),Text(widget.idpet > 0?"    ":""),widget.idpet > 0? ElevatedButton(
          child: Text("Excluir"),
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red))  ,
          onPressed: () => _deletePet(context),
        ): Text(""),
                    ],),

              ],
            ),
          ),
        ));
  }

  Future<void> _cadastrarPet(BuildContext context) async {
    final String nome = _controladorNome.text;
    final String datanascimento = _controladordatanascimento.text;
    final String pelagem = _controladorpelagem.text;
    final String raca = _controladorRaca.text;
    final String sexo = (_sexoSel!.index == 0) ? "M" : "F";
    final String tipo = _controladortipo.text;
    final String foto =  imgString;

    if ( _formKey.currentState!.validate()) {

      if(widget.idpet >0  )
        {
          final pet = Pet(widget.idpet, nome, datanascimento, pelagem, raca, sexo, tipo, foto);

          _daopet.updatePet(pet,widget.idpet) ;
          //Provider.of<PetDao>(context, listen: true).updatePet(pet,widget.idpet);
          _daopet.notificarDadosAlterador();
        }
      else
        {
          final pet = Pet(0, nome, datanascimento, pelagem, raca, sexo, tipo, foto);
          _daopet.save(pet) ;
          _daopet.notificarDadosAlterador();
        }


      Navigator.pop(context, pet);
    }
  }
  _deletePet(BuildContext context){
    if(widget.idpet >0  ){
      Widget cancelaButton = ElevatedButton(
        child: Text("Cancelar"),
        onPressed:  () {Navigator.of(context).pop(); },
      );
      Widget continuaButton = ElevatedButton(

        child: Text("Continar"),
        style:ButtonStyle( backgroundColor:  MaterialStateProperty.all<Color>(Colors.red) ),
        onPressed:  () {
          _daopet.deletePet(widget.idpet);
          Navigator.of(context).pop();
          Navigator.pop(context, pet);},
      );


      //exibe o diálogo
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MsgAlerta(cancelaButton,continuaButton,"Confirma a Operação","Deseja Apagar o Pet Selecionado ?");
        },
      );
    }
  }
  _selectimg(String source) async {

    ImageUtility.recuperaIMG(source).then((value) =>
    {
      setState(() {
        final XFile? pickedImage = value ;
        final File pickedImageFile = File(pickedImage!.path);
        imgString=  ImageUtility.base64String(pickedImageFile.readAsBytesSync());
      })
    });
  }
  _selectpet(int id) async {


    _daopet.findPet(id).then((value) =>
    {
      setState(() {
        pet = value;
        developer.log(pet.datanascimento);
        _controladorNome.text = pet.nome ;
        _controladordatanascimento.text = pet.datanascimento ;
        _controladorpelagem.text = pet.pelagem ;
        if(pet.sexo == "M")
           _sexoSel = TipoSexoSel.M;
        else
          _sexoSel = TipoSexoSel.F;
        _controladortipo.text = pet.tipo ;
        _controladorRaca.text = pet.raca ;

        imgString=  pet.foto;
      })
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galeria de Photo'),
                      onTap: () {
                        _selectimg("Galeria");
                         Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _selectimg("Camera");
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

}
