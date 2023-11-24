import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../service/service_plant.dart';
import 'package:flutter_vision/flutter_vision.dart';
import '../models/yolo_video.dart';

class CaptureAilment extends StatefulWidget {
  const CaptureAilment({Key? key}) : super(key: key);

  @override
  State<CaptureAilment> createState() => CaptureAilmentPlant();
}

class CaptureAilmentPlant extends State<CaptureAilment> {
  late FlutterVision vision;
  // una instancia de mi servicio
  ServicioPlanta service = ServicioPlanta();

  // Crear el controlador del campo de texto
  final TextEditingController controller = TextEditingController();
  String planta = "", descripcion = "";

  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
    // Llamar al método leerTabla y asignar el resultado a la variable lista
    debugPrint("iniciamos");
    llamarLista();
  }

  void llamarLista() async {
    service.lista = await leerTabla("assets/plantas.xlsx");
  }

  // Mover el método leerTabla dentro de la clase MyHomePageState
  Future<List<DolenciaPlanta>> leerTabla(String path) async {
    final bytes = await rootBundle.load(path);
    final excel = Excel.decodeBytes(bytes.buffer.asUint8List());
    final sheet = excel.sheets.values.first;

    final lista = <DolenciaPlanta>[];

    for (var row in sheet.rows.skip(1)) {
      final rowData = row.map((cell) => cell?.value?.toString() ?? '').toList();
      final combinedRow =
          rowData.join(','); // Concatenar los valores de la fila
      int indice =
          combinedRow.indexOf(","); // Encontrar la posición de la primera coma
      String parte1 = combinedRow.substring(
          0, indice); // Obtener la primera parte de la cadena
      String parte2 = combinedRow
          .substring(indice + 1); // Obtener la segunda parte de la cadena
      final dolenciaPlanta = DolenciaPlanta(
        parte1
            .trim(), // Eliminar los espacios en blanco al principio y al final
        parte2.trim(),
      );
      lista.add(dolenciaPlanta);
    }

    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Aquí agregas el widget Container
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                // Usa el widget Image.asset para mostrar una imagen desde los assets locales
                child: Image.asset(
                  'assets/images/enfermo.png',
                  width: 150,
                  height: 150,
                ),
              ),
              const Text(
                '¿Qué dolencia tienes?',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Helvetica",
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              const Opacity(
                opacity: 0.5,
                child: Text(
                  'Escribe tu dolencia aquí',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ej: Tengo gripe, ¿que planta me recomiendas?',
                ),
                style: const TextStyle(
                  // Usa la propiedad fontSize para especificar el tamaño de la fuente en píxeles
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Obtener la dolencia del campo de texto
                  final dolencia = controller.text;
                  // Buscar la planta que corresponde a la dolencia
                  final plantaDescripcion =
                      buscarPlanta(dolencia, service.lista);
                  if (plantaDescripcion == null) {
                    descripcion = "";
                  } else {
                    final partes = plantaDescripcion.split("-");
                    planta = partes[0];
                    descripcion = partes[1];
                  }
                  // Actualizar el estado con la planta
                  setState(() {
                    service.planta = planta;
                    service.descripcion = descripcion;
                  });
                  // Verificar si la descripción es vacía o no
                  if (descripcion != "") {
                    // Mostrar una ventana emergente con un mensaje
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            "¡Recomendacion!",
                            style: TextStyle(
                              color: Color.fromARGB(255, 37, 70, 161),
                              fontSize: 16,
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                // Usa el widget Image.asset para mostrar una imagen desde los assets locales
                                child: Image.asset(
                                  'assets/images/OIG5.jpeg',
                                  width: 200,
                                  height: 200,
                                ),
                              ),
                              // Aquí agregas la imagen que quieres mostrar
                              const Text(
                                '"Por favor enfoca la planta a la cámara"',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 134, 161, 37),
                                  fontSize: 18,
                                  fontFamily: "Helvetica",
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Cerrar la ventana emergente
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navegar a la clase YoloV8Seg y pasar los valores de servicio.planta y service.descripcion
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            YoloVideo(vision: vision)));
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Continuar"),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //Image.asset("assets/images/OIG5.jpeg"),
                              // Aquí agregas la imagen que quieres mostrar
                              Text(
                                '"No se encontro ninguna planta para tu dolencia en nuestra BD"',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 134, 161, 37),
                                  fontSize: 18,
                                  fontFamily: "Helvetica",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Cerrar la ventana emergente
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Aceptar"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Buscar planta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String limpiarTexto(String texto) {
  return texto.replaceAll(RegExp(r'[^\w\s]'), '');
}

String? buscarPlanta(String dolencia, List<DolenciaPlanta> lista) {
  dolencia = limpiarTexto(dolencia.toLowerCase());
  List<String> palabras = dolencia.split(' ');

  // Recorrer la lista de objetos DolenciaPlanta
  for (var palabra in palabras) {
    for (var dolenciaPlanta in lista) {
      // Comparar cada palabra con la dolencia del objeto
      if (dolenciaPlanta.dolencia == palabra) {
        // Devolver la planta del objeto
        return dolenciaPlanta.planta;
      }
    }
  }

  // Si no se encuentra ninguna planta, devolver un mensaje de error
  return null;
}
