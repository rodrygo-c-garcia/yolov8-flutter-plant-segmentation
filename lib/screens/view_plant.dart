import 'package:flutter/material.dart';
import '../service/service_plant.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../class/dolencia.dart';
import 'dart:convert';

class ViewPlant extends StatefulWidget {
  final Uint8List image; // El archivo con la imagen recortada
  const ViewPlant({Key? key, required this.image}) : super(key: key);

  @override
  State<ViewPlant> createState() => ViewPlantInfo();
}

class ViewPlantInfo extends State<ViewPlant> {
  ServicioPlanta service = ServicioPlanta();
  late Future<Dolencia> dolencia;

  @override
  void initState() {
    super.initState();
    dolencia = getDolencia(service.dolencia);
  }

  @override
  Widget build(BuildContext context) {
    // Declara dos variables para almacenar las URLs de las imágenes adicionales
    String imageUrl1 = "";
    String imageUrl2 = "";
    // Usa un switch para asignar las URLs según el valor de service.planta
    switch (service.planta) {
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
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              // Muestra la descripción de la planta usando service.descripcion
              Expanded(
                child: FutureBuilder<Dolencia>(
                  future: dolencia,
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
                      var dolencia = snapshot.data!;
                      // Retorna un widget que muestre los datos de la planta
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Muestra el nombre común de la planta
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Muestra el título de la dolencia
                                    Text(
                                      dolencia.titulo,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Muestra la introducción de la dolencia
                                    Text(
                                      dolencia.introduccion,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Muestra los beneficios de la dolencia
                              const Text(
                                'Beneficios:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: dolencia.beneficios.length,
                                itemBuilder: (context, index) {
                                  // Obtiene el valor de cada beneficio
                                  var valor = dolencia.beneficios[index];
                                  // Retorna un widget que muestre el valor de cada beneficio con un icono
                                  return ListTile(
                                    leading: const Icon(Icons.check),
                                    title: Text(
                                      valor,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                },
                              ),
// Muestra las formas de uso de la dolencia
                              const Text(
                                'Formas de uso:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: dolencia.formas_de_uso.length,
                                itemBuilder: (context, index) {
                                  // Obtiene el objeto de tipo FormaDeUso de cada forma de uso
                                  var forma = dolencia.formas_de_uso[index];
                                  // Retorna un widget que muestre el nombre, las instrucciones y la recomendación de cada forma de uso con un icono
                                  return ExpansionTile(
                                    leading: const Icon(Icons.medical_services),
                                    title: Text(forma.nombre),
                                    children: [
                                      // Muestra las instrucciones de cada forma de uso
                                      const Text(
                                        'Instrucciones:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // Usa un widget ListView.builder para mostrar cada instrucción con un icono
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: forma.instrucciones.length,
                                        itemBuilder: (context, index) {
                                          // Obtiene el valor de cada instrucción
                                          var valor =
                                              forma.instrucciones[index];
                                          // Retorna un widget que muestre el valor de cada instrucción con un icono
                                          return ListTile(
                                            leading:
                                                const Icon(Icons.arrow_right),
                                            title: Text(valor),
                                          );
                                        },
                                      ),
                                      // Muestra la recomendación de cada forma de uso
                                      const Text(
                                        'Recomendación:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 10),
                                        child: Text(
                                          forma.recomendacion,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Text(
                                  'Precauciones:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Text(
                                  dolencia.precauciones,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),

                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Text(
                                  'Consejos adicionales:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: dolencia.consejos_adicionales.length,
                                itemBuilder: (context, index) {
                                  // Obtiene el valor de cada consejo adicional
                                  var valor =
                                      dolencia.consejos_adicionales[index];
                                  // Retorna un widget que muestre el valor de cada consejo adicional con un icono
                                  return ListTile(
                                    leading: const Icon(Icons.lightbulb),
                                    title: Text(
                                      valor,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
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
        ),
      ),
    );
  }

  // Crea una función que haga la petición a la API y que retorne un objeto de tipo Future<Dolencia>
  Future<Dolencia> getDolencia(String dolor) async {
    // Define la URL de la API con el parámetro dolor
    var url =
        'https://ez6v5h6xf9.execute-api.eu-north-1.amazonaws.com/dolencia?dolor=$dolor';
    // Usa el método http.get para hacer la petición
    var response = await http.get(Uri.parse(url));
    // Usa el método jsonDecode para convertir la respuesta en un mapa de tipo Map<String, dynamic>
    var json = jsonDecode(response.body);
    // Usa el método Dolencia.fromJson para convertir el mapa en un objeto de tipo Dolencia
    var dolencia = Dolencia.fromJson(json);
    // Retorna el objeto de tipo Dolencia
    return dolencia;
  }
}
