import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class AlertMsgUtil {
  static showMsg(BuildContext context, Function cancel, Function continua,{String titulo='Selecione',texto="Selecione"}) {
    return showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: titulo,
          positiveText: "Selecionar",
          negativeText: "Voltar",
          positiveTextStyle: TextStyle(color: Colors.deepOrange),
          contentText: texto ,
          onPositiveClick: () {
            continua();
          },
          onNegativeClick: () {
            cancel();
          },
        );
      },
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }
}
