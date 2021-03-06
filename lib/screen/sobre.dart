import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetpet/helpers/estilos.dart';

class SobreAplicativoScreen extends StatefulWidget {
  @override
  _SobreAplicativoScreenState createState() =>
      _SobreAplicativoScreenState();
}

class _SobreAplicativoScreenState extends State<SobreAplicativoScreen> {
  //
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
      ),
      body:  Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("asset/images/_MG_9521.jpg"),
              fit: BoxFit.cover,)),
          child: ListView( padding: const EdgeInsets.all(8),
              children: <Widget>[Text(' Atenção',
                                        style: Estilos.EstiloTextoNegritoTitulo_1(),
                                      ),Text('    O aplicativo não salva informações fora dele. \n '
                  '   Caso seja desinstalado, todas as informações serão perdidas. Não será possível recuperá-las. \n\n'
                  '   Esta é a primeira versão do aplicativo, em breve teremos melhorias. \n\n'
                  '   Para deixar de receber notificações, você deve editar o cadastro e marcar o flag de instivação. \n'
                  '   Para editar um aviso ou vacina cadastrada, voê deve pressionar o item. A tela de para edição irá ser exibida \n\n'
                  '   As notificações podem falhar, por isso consulte-as regularmente.\n\n'
                  '   Caso tenha mais de um Pet, para cadastrar um aviso ou vacina, você tem que selecionar o Pet na tela inicial.'
                  'Para  selecionar o Pet desejado, basta um clique no excolhido, ele ficará destacado dos demais. \n\n'
                  '   Sugestões ou erros encontrados podem ser enviados para o e-mail para vicentepd.sys@gmail.com',
                  style: Estilos.EstiloTextoNegrito_1() ),
                                    Column(
        children: [
        SizedBox(
          height: 10.h,
        ),
        SizedBox(height: 5),
        ],),Text('Versão 1.0.0',style: Estilos.EstiloTexto_1(),)])

      ));
  }
}
