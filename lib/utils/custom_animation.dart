import 'package:flutter/material.dart';

class CustomAnimation extends PageRouteBuilder {
  final int milisegundos;
  final Curve animacion;
  final Alignment alineacion;
  final Widget pagina;
  CustomAnimation(
      {this.milisegundos = 5000,
      this.animacion = Curves.easeInOutBack,
      this.alineacion = const Alignment(0.8, 1),
      required this.pagina})
      : super(
          transitionDuration: Duration(milliseconds: milisegundos),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secAnimation,
              Widget child) {
            animation = CurvedAnimation(
              parent: animation,
              curve: animacion,
            );
            return ScaleTransition(
              alignment: alineacion,
              scale: animation,
              child: child,
            );
          },
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secAnimation) {
            return pagina;
          },
        );
}
