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
            'assets/images/apacarro/apacarro1.jpg'; // La ruta de la primera imagen local para apacarro
        imageUrl2 =
            'assets/images/apacarro/apacarro2.jpg'; // La ruta de la segunda imagen local para apacarro
        break;
      case "jengibre":
        imageUrl1 =
            'assets/images/jengibre/jengibre1.jpg'; // La ruta de la primera imagen local para jengibre
        imageUrl2 =
            'assets/images/jengibre/jengibre2.jpg'; // La ruta de la segunda imagen local para jengibre
        break;
      case "menta":
        imageUrl1 =
            'assets/images/menta/menta1.jpg'; // La ruta de la primera imagen local para menta
        imageUrl2 =
            'assets/images/menta/menta2.jpg'; // La ruta de la segunda imagen local para menta
        break;
      case "eucalipto":
        imageUrl1 =
            'assets/images/eucalipto/eucalipto1.jpeg'; // La ruta de la primera imagen local para eucalipto
        imageUrl2 =
            'assets/images/eucalipto/eucalipto2.jpeg'; // La ruta de la segunda imagen local para eucalipto
        break;
      case "malva":
        imageUrl1 =
            'assets/images/malva/malva1.jpg'; // La ruta de la primera imagen local para malva
        imageUrl2 =
            'assets/images/malva/malva2.jpg'; // La ruta de la segunda imagen local para malva
        break;
      case "manzanilla":
        imageUrl1 =
            'assets/images/manzanilla/manzanilla1.jpg'; // La ruta de la primera imagen local para manzanilla
        imageUrl2 =
            'assets/images/manzanilla/manzanilla2.jpg'; // La ruta de la segunda imagen local para manzanilla
        break;
      case "siempreviva":
        imageUrl1 =
            'assets/images/siempreviva/siempreviva1.jpg'; // La ruta de la primera imagen local para siempreviva
        imageUrl2 =
            'assets/images/siempreviva/siempreviva2.jpg'; // La ruta de la segunda imagen local para siempreviva
        break;
      default:
        imageUrl1 = ""; // La ruta por defecto para la primera imagen local
        imageUrl2 = ""; // La ruta por defecto para la segunda imagen local
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Como usar la Planta?'),
        backgroundColor: Colors.green,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.memory(
                          fit: BoxFit.contain,
                          alignment: Alignment
                              .topCenter, // Alinea la imagen dentro del FittedBox
                          widget.image,
                          width: MediaQuery.of(context).size.width * 0.9,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Muestra la primera imagen adicional usando Image.network dentro de un Expanded y un FittedBox
                  Expanded(
                    child: FittedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          imageUrl1, // La URL de la primera imagen adicional
                          fit: BoxFit.contain,
                          alignment: Alignment.topCenter,
                          // Usa el argumento loadingBuilder para mostrar un widget mientras la imagen se carga
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Muestra la segunda imagen adicional usando Image.network dentro de un Expanded y un FittedBox
                  Expanded(
                    child: FittedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          fit: BoxFit.contain,
                          alignment: Alignment
                              .topCenter, // Alinea la imagen dentro del FittedBox
                          imageUrl2, // La URL de la segunda imagen adicional
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  service.planta.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
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
