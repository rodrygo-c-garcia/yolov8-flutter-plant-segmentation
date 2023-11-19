import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
// Importar el paquete services
import 'package:flutter/services.dart' show rootBundle;
import '../service/service_plant.dart';

class CaptureAilment extends StatefulWidget {
  const CaptureAilment({Key? key}) : super(key: key);

  @override
  State<CaptureAilment> createState() => CaptureAilmentPlant();
}

class CaptureAilmentPlant extends State<CaptureAilment> {
  // una instancia de mi servicio
  ServicioPlanta service = ServicioPlanta();

  // Crear el controlador del campo de texto
  final TextEditingController controller = TextEditingController();
  String planta = "", descripcion = "";
  @override
  void initState() {
    super.initState();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '¿Qué dolencia tienes?',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe tu dolencia aquí',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Obtener la dolencia del campo de texto
                final dolencia = controller.text;
                // Buscar la planta que corresponde a la dolencia
                final plantaDescripcion = buscarPlanta(dolencia, service.lista);
                if (plantaDescripcion == null) {
                  planta = "No se encontró ninguna planta para tu dolencia";
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
              },
              child: const Text('Buscar planta'),
            ),
            const SizedBox(height: 20),
            const Text(
              'La planta que te recomiendo es:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              service.planta,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
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
