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
    // Declara dos variables para almacenar las URLs de las imágenes adicionales
    String imageUrl1 = "";
    String imageUrl2 = "";
    // Usa un switch para asignar las URLs según el valor de service.planta
    switch (service.planta) {
      case "apacarro":
        imageUrl1 =
            "https://i.ibb.co/..."; // La URL de la primera imagen adicional para apacarro
        imageUrl2 =
            "https://i.ibb.co/..."; // La URL de la segunda imagen adicional para apacarro
        break;
      case "jengibre":
        imageUrl1 =
            "https://i.ibb.co/..."; // La URL de la primera imagen adicional para jengibre
        imageUrl2 =
            "https://i.ibb.co/..."; // La URL de la segunda imagen adicional para jengibre
        break;
      case "menta":
        imageUrl1 =
            "https://i.ibb.co/..."; // La URL de la primera imagen adicional para menta
        imageUrl2 =
            "https://i.ibb.co/..."; // La URL de la segunda imagen adicional para menta
        break;
      case "eucalipto":
        imageUrl1 =
            "https://i.ibb.co/wCMvVMY/eucalipto.jpg"; // La URL de la primera imagen adicional para eucalipto
        imageUrl2 =
            "https://i.ibb.co/QCYy0sW/eucalipto.jpg"; // La URL de la segunda imagen adicional para eucalipto
        break;
      case "malva":
        imageUrl1 =
            "https://i.ibb.co/..."; // La URL de la primera imagen adicional para malva
        imageUrl2 =
            "https://i.ibb.co/..."; // La URL de la segunda imagen adicional para malva
        break;
      case "manzanilla":
        imageUrl1 =
            "https://i.ibb.co/..."; // La URL de la primera imagen adicional para manzanilla
        imageUrl2 =
            "https://i.ibb.co/..."; // La URL de la segunda imagen adicional para manzanilla
        break;
      case "siempreviva":
        imageUrl1 =
            "https://i.ibb.co/..."; // La URL de la primera imagen adicional para siempreviva
        imageUrl2 =
            "https://i.ibb.co/..."; // La URL de la segunda imagen adicional para siempreviva
        break;
      default:
        imageUrl1 = ""; // La URL por defecto para la primera imagen adicional
        imageUrl2 = ""; // La URL por defecto para la segunda imagen adicional
        break;
    }

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
              // Muestra la imagen capturada usando Image.memory dentro de un FittedBox
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
                  Expanded(
                    child: FittedBox(
                      child: Image.network(
                        imageUrl1, // La URL de la primera imagen adicional
                        fit: BoxFit.contain,
                        alignment: Alignment
                            .topCenter, // Alinea la imagen dentro del FittedBox
                        // Usa el argumento loadingBuilder para mostrar un widget mientras la imagen se carga
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          // Si el progreso de carga es nulo, significa que la imagen ya se ha cargado, así que se devuelve el widget hijo
                          if (loadingProgress == null) return child;
                          // Si no, se devuelve un widget CircularProgressIndicator para mostrar el progreso de carga
                          return CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          );
                        },
                      ),
                    ),
                  ),
                  // Muestra la segunda imagen adicional usando Image.network dentro de un Expanded y un FittedBox
                  Expanded(
                    child: FittedBox(
                      child: Image.network(
                        fit: BoxFit.contain,
                        alignment: Alignment
                            .topCenter, // Alinea la imagen dentro del FittedBox
                        imageUrl2, // La URL de la segunda imagen adicional
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                service.planta,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              // Muestra la descripción de la planta usando service.descripcion
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    service.descripcion,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
