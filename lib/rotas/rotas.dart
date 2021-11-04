import 'package:flutter/cupertino.dart';
import 'package:vetpet/screen/listaavisos.dart';
import 'package:vetpet/screen/vacinascreen.dart';


Route createRouteVacina() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>  VacinaScreen( operacao:"Vencendo"),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
Route createRouteAlerta() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>  AvisoScreen(operacao:"Vencendo"),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}