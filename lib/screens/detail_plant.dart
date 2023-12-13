import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../class/plant.dart';

class DetailPlant extends StatefulWidget {
  final String tag;
  const DetailPlant({Key? key, required this.tag}) : super(key: key);

  @override
  State<DetailPlant> createState() => ViewDetailPlant();
}

class ViewDetailPlant extends State<DetailPlant> {
  //var plant;
  late Future<Planta> plant;
  String imageUrl1 = "";
  String imageUrl2 = "";

  @override
  void initState() {
    super.initState();
    plant = getPlanta(widget.tag);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.tag) {
      case "alcaparro":
        imageUrl1 =
            'assets/images/alparraco/alparraco1.jpeg'; // La ruta de la primera imagen local para apacarro
        imageUrl2 =
            'assets/images/alparraco/alparraco2.jpeg'; // La ruta de la segunda imagen local para apacarro
        break;
      case "jengibre":
        imageUrl1 =
            'assets/images/jengibre/jengibre1.jpeg'; // La ruta de la primera imagen local para jengibre
        imageUrl2 =
            'assets/images/jengibre/jengibre2.jpeg'; // La ruta de la segunda imagen local para jengibre
        break;
      case "menta_silvestre":
        imageUrl1 =
            'assets/images/menta/menta1.jpeg'; // La ruta de la primera imagen local para menta
        imageUrl2 =
            'assets/images/menta/menta2.jpeg'; // La ruta de la segunda imagen local para menta
        break;
      case "eucalipto":
        imageUrl1 =
            'assets/images/eucalipto/eucalipto1.jpeg'; // La ruta de la primera imagen local para eucalipto
        imageUrl2 =
            'assets/images/eucalipto/eucalipto2.jpeg'; // La ruta de la segunda imagen local para eucalipto
        break;
      case "malva":
        imageUrl1 =
            'assets/images/malva/malva1.jpeg'; // La ruta de la primera imagen local para malva
        imageUrl2 =
            'assets/images/malva/malva2.jpeg'; // La ruta de la segunda imagen local para malva
        break;
      case "manzanilla":
        imageUrl1 =
            'assets/images/manzanilla/manzanilla1.jpeg'; // La ruta de la primera imagen local para manzanilla
        imageUrl2 =
            'assets/images/manzanilla/manzanilla2.jpeg'; // La ruta de la segunda imagen local para manzanilla
        break;
      case "siempreviva":
        imageUrl1 =
            'assets/images/siempreviva/siempreviva1.jpeg'; // La ruta de la primera imagen local para siempreviva
        imageUrl2 =
            'assets/images/siempreviva/siempreviva2.jpeg'; // La ruta de la segunda imagen local para siempreviva
        break;
      default:
        imageUrl1 = ""; // La ruta por defecto para la primera imagen local
        imageUrl2 = ""; // La ruta por defecto para la segunda imagen local
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Informacion de ${widget.tag}"),
        backgroundColor: Colors.green,
      ),
      // Usa un widget FutureBuilder para mostrar el contenido según el estado de la petición
      body: Column(
        children: [
          // Usa un widget Row para mostrar dos imágenes en una fila
          // Usa un widget Row para mostrar dos imágenes en una fila
          Row(
            // Usa la propiedad mainAxisAlignment para centrar los widgets hijos
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Usa el widget Padding para agregar un relleno personalizado alrededor de la primera imagen
              Padding(
                // Usa la clase EdgeInsets para crear un relleno simétrico horizontal y vertical
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(imageUrl1, width: 150, height: 300),
                ),
              ),
              // Usa el widget Padding para agregar un relleno personalizado alrededor de la segunda imagen
              Padding(
                // Usa la clase EdgeInsets para crear un relleno simétrico horizontal y vertical
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(imageUrl2, width: 150, height: 300),
                ),
              ),
            ],
          ),

          Expanded(
            child: FutureBuilder<Planta>(
              future:
                  plant, // Usa la variable que guarda el objeto de tipo Planta
              builder: (context, snapshot) {
                // Si la petición está en progreso, muestra un indicador de carga
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // Si la petición falló, muestra un mensaje de error
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                // Si la petición fue exitosa, muestra los datos de la planta
                if (snapshot.hasData) {
                  // Obtiene el objeto de tipo Planta del snapshot
                  var planta = snapshot.data!;
                  // Retorna un widget que muestre los datos de la planta
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Muestra el nombre común de la planta
                          Text(
                            planta.nombreComun,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Muestra el nombre científico de la planta
                          Text(
                            planta.nombreCientifico,
                            style: const TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          // Muestra la descripción de la planta
                          Text(
                            planta.descripcion,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),

                          // Muestra las propiedades medicinales de la planta
                          const Text(
                            'Propiedades medicinales:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Usa un widget ListView.builder para mostrar cada propiedad medicinal con su descripción
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: planta.propiedadesMedicinales.length,
                            itemBuilder: (context, index) {
                              // Obtiene la clave y el valor de cada propiedad medicinal
                              var clave = planta.propiedadesMedicinales.keys
                                  .elementAt(index);
                              var valor = planta.propiedadesMedicinales.values
                                  .elementAt(index);
                              // Retorna un widget que muestre la clave y el valor de cada propiedad medicinal
                              return ListTile(
                                leading: const Icon(Icons.medical_services),
                                title: Text(clave),
                                subtitle: Text(valor),
                              );
                            },
                          ),
                          // Muestra las formas de uso de la planta
                          const Text(
                            'Formas de uso:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Usa un widget ListView.builder para mostrar cada forma de uso
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: planta.formasDeUso.length,
                            itemBuilder: (context, index) {
                              // Obtiene el valor de cada forma de uso
                              var valor = planta.formasDeUso[index];
                              // Retorna un widget que muestre el valor de cada forma de uso
                              return ListTile(
                                leading: const Icon(Icons.local_pharmacy),
                                title: Text(valor),
                              );
                            },
                          ),
                          // Muestra las contraindicaciones de la planta
                          const Text(
                            'Contraindicaciones:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Usa un widget ListView.builder para mostrar cada contraindicación
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: planta.contraindicaciones.length,
                            itemBuilder: (context, index) {
                              // Obtiene el valor de cada contraindicación
                              var valor = planta.contraindicaciones[index];
                              // Retorna un widget que muestre el valor de cada contraindicación
                              return ListTile(
                                leading: const Icon(Icons.warning),
                                title: Text(valor),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
                // Si no hay datos, muestra un widget vacío
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Planta> getPlanta(String tag) async {
    // Construye la URL con el tag que recibes como parámetro
    var url = Uri.parse(
        'https://qs68na5bn3.execute-api.eu-north-1.amazonaws.com/plants?plant=$tag');
    // Hace la petición GET a la API
    var response = await http.get(url);
    // Verifica que la respuesta sea exitosa
    if (response.statusCode == 200) {
      // Convierte la respuesta en un mapa
      var data = jsonDecode(response.body);
      // Crea un objeto de tipo Planta con el mapa
      var planta = Planta.fromJson(data);
      // Devuelve el objeto
      return planta;
    } else {
      // Lanza una excepción si la respuesta no es exitosa
      throw Exception('Error al obtener la planta');
    }
  }
}
