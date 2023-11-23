import 'package:flutter/material.dart';

class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    // Aquí va tu lógica para crear el rectángulo de recorte
    return Rect.fromLTRB(0, 35, size.width, size.height - 35);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    // Aquí puedes devolver true o false dependiendo de si quieres que el recorte se actualice cuando cambie el tamaño del widget hijo
    return true;
  }
}
