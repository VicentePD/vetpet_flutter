import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';

import 'dart:developer' as developer;
class EditorDate extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData icone;
  final TextInputType teclado;
  final bool obrigatorio;
  EditorDate(this.controlador,
      {this.rotulo = "",
      this.dica = "",
      this.icone = Icons.text_format,
      this.teclado = TextInputType.text,
      this.obrigatorio = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controlador,
          validator: (value) =>_validarCampo(value,obrigatorio) ,
        inputFormatters: [MaskTextInputFormatter(mask: "##/##/####")],
        onTap:() {_selectDate(context);},
        style: TextStyle(fontSize: 16.0),

        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: teclado,

      ),
    );
  }
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      controlador.text = DateFormat.yMd().format(picked);
  }
}



 dynamic _validarCampo(value,bool obrigatorio){
  if (value!.isEmpty) {
    if(obrigatorio){
      return "Campo não Preenchido!";
    }
    return null;
  }
  final components = value.split("/");
  if (components.length == 3) {
    final day = int.tryParse(components[0]);
    final month = int.tryParse(components[1]);
    final year = int.tryParse(components[2]);
    if (day != null && month != null && year != null) {
      final date = DateTime(year, month, day);
      if (date.year == year && date.month == month && date.day == day) {
        return null;
      }
    }
  }
  return "Data Inválida";

}
