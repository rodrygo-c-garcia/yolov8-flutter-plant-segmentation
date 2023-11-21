import 'package:flutter/material.dart';
import '../service/service_plant.dart';
import 'dart:typed_data';

class ViewPlant extends StatefulWidget {
  final Uint8List image; // El archivo con la imagen recortada
  const ViewPlant({Key? key, required this.image}) : super(key: key);

  @override
  State<ViewPlant> createState() => ViewPlantInfo();
}

class ViewPlantInfo extends State<ViewPlant> {
  ServicioPlanta service = ServicioPlanta();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver planta'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment
              .center, // Alinea los widgets hijos horizontalmente
          children: [
            // Muestra la imagen capturada usando Image.memory dentro de un FittedBox
            FittedBox(
              fit: BoxFit.contain,
              alignment:
                  Alignment.topCenter, // Alinea la imagen dentro del FittedBox
              child: Image.memory(
                widget.image,
                width: MediaQuery.of(context).size.width *
                    0.5, // Especifica el ancho de la imagen en píxeles
              ),
            ),
            // Muestra la descripción de la planta usando service.descripcion
            Text(service.descripcion),
          ],
        ),
      ),
    );
  }
}
