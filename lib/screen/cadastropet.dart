import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vetpet/components/editordate.dart';
import 'package:vetpet/components/editortexto.dart';
import 'dart:io';
import 'package:vetpet/database/dao/pet_dao.dart';


import 'package:vetpet/helpers/imagemutil.dart';
import 'package:vetpet/model/Pet.dart';
import 'dart:developer' as developer;



const _textoBotaoConfirmar = 'Confirmar';
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
  final TextEditingController _controladordatanascimento =  TextEditingController();
  final TextEditingController _controladorpelagem = TextEditingController();
  final TextEditingController _controladortipo = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TipoSexoSel? _sexoSel = TipoSexoSel.M;
  late  String imgString = "";
  final pet = Pet(0, "", "", "", "", "", "", "");
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

                ElevatedButton(
                  child: Text(_textoBotaoConfirmar),
                  onPressed: () => _cadastrarPet(context),
                ),

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
      final pet = Pet(0, nome, datanascimento, pelagem, raca, sexo, tipo, foto);
      final PetDao _daopet = PetDao();
      _daopet.save(pet);
      Navigator.pop(context, pet);
    }
  }
  _selectimg(String source) async {

    ImageUtility.recuperaIMG(source).then((value) =>
    {
      setState(() {
        final PickedFile? pickedImage = value;
        final File pickedImageFile = File(pickedImage!.path);
        imgString=  ImageUtility.base64String(pickedImageFile.readAsBytesSync());
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
