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
}
