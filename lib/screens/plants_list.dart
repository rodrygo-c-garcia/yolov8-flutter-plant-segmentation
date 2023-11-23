import 'package:flutter/material.dart';
import 'dart:typed_data';

class PlantsList extends StatefulWidget {
  final Uint8List image;
  final List<String> tags;
  const PlantsList({Key? key, required this.image, required this.tags})
      : super(key: key);

  @override
  State<PlantsList> createState() => _PlantsListState();
}

class _PlantsListState extends State<PlantsList> with RouteAware {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver planta'),
      ),
      body: Center(
        child: Padding(
          // Aquí agregas el widget Padding
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment
                .center, // Alinea los widgets hijos horizontalmente
            children: [
              Row(
                children: [
                  // Muestra la imagen capturada usando Image.memory dentro de un Expanded y un FittedBox
                  Expanded(
                    child: FittedBox(
                      child: Image.memory(
                        fit: BoxFit.contain,
                        alignment: Alignment
                            .topCenter, // Alinea la imagen dentro del FittedBox
                        widget.image,
                        width: MediaQuery.of(context).size.width *
                            0.3, // Especifica el ancho de la imagen en píxeles
                      ),
                    ),
                  ),
                  // Muestra la primera imagen adicional usando Image.network dentro de un Expanded y un FittedBox
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTagButton(String tag) {
    return ElevatedButton(
      onPressed: () {
        debugPrint("Tag: $tag");
      },
      style: ElevatedButton.styleFrom(
          // Aquí puedes definir el estilo del botón, como el color, el tamaño, el borde, etc.
          ),
      child: Text(tag),
    );
  }

  List<Widget> buildTagButtons(List<String> tags) {
    return tags.map((tag) => buildTagButton(tag)).toList();
  }

  Widget buildTagGrid(List<String> tags) {
    return GridView.count(
      crossAxisCount: 3, // Esto hace que la cuadrícula tenga tres columnas
      children: buildTagButtons(
          tags), // Esto hace que la cuadrícula muestre los botones creados en el paso anterior
    );
  }
}
