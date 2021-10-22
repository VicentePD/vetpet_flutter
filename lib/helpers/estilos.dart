import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Estilos {
  static TextStyle EstiloTexto_1() {
    return TextStyle(
      color: Colors.orange,
    );
  }

  static TextStyle EstiloTextoNegrito_1() {
    return TextStyle(
      color: Colors.orange,
      fontSize: ScreenUtil().setSp(14),
      fontWeight: FontWeight.bold,
    );
  }
  static TextStyle EstiloTextoNegritoTitulo_1() {
    return TextStyle(
      color: Colors.orange,
      fontSize: ScreenUtil().setSp(24),
      fontWeight: FontWeight.bold,
    );
  }
}
