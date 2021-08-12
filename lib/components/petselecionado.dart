import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vetpet/helpers/imagemutil.dart';
import '../helpers/globals.dart' as globals;

class PetSelecionado extends StatelessWidget {

  PetSelecionado();

  @override
  Widget build(BuildContext context) {
    if(globals.idpetsel == 0)
    {
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
                      child: Image.asset("asset/images/_MG_9521.jpg")),
                ),
                title: Text("Selecione um Pet Para Cadastrar a Vacina"),
                subtitle: Text( "" ),
                isThreeLine:true,
                tileColor:  Colors.orange[100],
                // selected: selecionado,
              ),
            ],
          ));
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

