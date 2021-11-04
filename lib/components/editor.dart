import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Editor extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData icone;
  final TextInputType teclado;
  final String mascara;
  Editor(this.controlador,
      {this.rotulo = "",
      this.dica = "",
      this.icone = Icons.text_format,
      this.teclado = TextInputType.text,
      this.mascara = "0"});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        inputFormatters: [defineMascara(mascara)],
        style: TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
          icon:  Icon(icone,semanticLabel: rotulo ,) ,
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: teclado,
      ),
    );
  }
}

MaskTextInputFormatter defineMascara(String tipomask) {
  switch (tipomask) {
    case "Data":
      return new MaskTextInputFormatter(mask: "##/##/####");
  }
  return new MaskTextInputFormatter(mask: "");
}
