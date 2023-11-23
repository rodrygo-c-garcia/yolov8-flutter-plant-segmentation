import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:math';
import '../class/my_clipper.dart';
import 'detail_plant.dart';

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
    final navigator = Navigator.of(context);
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
                      child: ClipRect(
                        // Esto hace que la imagen se recorte con un rectángulo
                        clipBehavior: Clip
                            .hardEdge, // Esto hace que el recorte sea duro, sin anti-aliasing
                        clipper:
                            MyClipper(), // Esto usa la subclase que hemos creado antes como el clipper
                        child: Image.memory(
                          fit: BoxFit.contain,
                          // Alinea la imagen dentro del FittedBox
                          alignment: Alignment.topCenter,
                          widget.image,
                          width: MediaQuery.of(context).size.width *
                              0.5, // Especifica el ancho de la imagen en píxeles como el 80% del ancho de la pantalla
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                      ),
                    ),
                  ),

                  // Muestra la primera imagen adicional usando Image.network dentro de un Expanded y un FittedBox
                ],
              ),
              const Text(
                "Plantas Identificadas en la Imagen",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              Expanded(
                // Usa la función creada en el paso anterior, pasando la lista tags como parámetro
                child: buildTagGrid(widget.tags, navigator),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color randomColor() {
    // Crea un objeto Random
    Random random = Random();

    // Genera un valor alfa aleatorio entre 50 y 200 (más transparente que opaco)
    int a = random.nextInt(50) + 150;

    // Genera un valor verde aleatorio entre 0 y 255
    int g = random.nextInt(256);

    // Crea un color con los valores generados, manteniendo el rojo y el azul en cero
    return Color.fromARGB(a, 0, g, 0);
  }

  Widget buildTagButton(String tag, NavigatorState navigator) {
    return GestureDetector(
      onTap: () {
        // Aquí puedes poner el código que quieres que se ejecute cuando se presione el contenedor
        debugPrint("Presionaste el botón $tag");
        navigator.push(
          MaterialPageRoute(
            builder: (context) =>
                DetailPlant(tag: tag == "alparraco" ? "alcaparro" : tag),
          ),
        );
      },
      child: Container(
        // Esto hace que el botón tenga un ancho de 100 píxeles y un alto de 50 píxeles
        width: 100,
        height: 50,
        // Esto hace que el botón tenga un borde redondeado con un degradado
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              20), // Esto define el radio del borde redondeado
          border: Border.all(
            // Esto define el estilo del borde
            width: 3, // Esto define el ancho del borde
            color: Colors.white, // Esto define el color del borde
          ),
          gradient: LinearGradient(
            // Esto define el degradado del borde
            colors: [
              // Esto define la lista de colores del degradado
              randomColor(), // Esto usa la función modificada para generar un color verde aleatorio
              randomColor(), // Esto usa la función modificada para generar otro color verde aleatorio
            ],
            stops: const [
              // Esto define la lista de paradas del degradado, que indican dónde empieza y termina cada color
              0.0, // Esto indica que el primer color empieza en el 0% del borde
              1.0, // Esto indica que el segundo color termina en el 100% del borde
            ],
          ),
        ),
        // Esto hace que el botón tenga un texto con el elemento de la lista tags
        child: Stack(
          // Esto usa un widget Stack para colocar el icono sobre el botón
          children: [
            Positioned(
              // Esto usa un widget Positioned para ajustar la posición y el tamaño del icono
              left: 20,
              top: 30,
              width:
                  50, // Esto indica que el icono tiene un ancho de 30 píxeles
              height:
                  50, // Esto indica que el icono tiene un alto de 30 píxeles
              child: Image.asset(
                // Esto usa un widget Image.asset para mostrar el icono desde los assets locales
                'assets/images/plant.png', // Esto indica el nombre del archivo del icono
                fit: BoxFit.cover,
              ),
            ),
            Align(
              // Esto usa un widget Align para alinear el texto dentro del contenedor
              alignment: const Alignment(0.0, -0.8),
              child: Text(
                tag == "alparraco" ? "alcaparro" : tag,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildTagButtons(List<String> tags, NavigatorState navigator) {
    return tags.map((tag) => buildTagButton(tag, navigator)).toList();
  }

  Widget buildTagGrid(List<String> tags, NavigatorState navigator) {
    return GridView.count(
      crossAxisCount: 3, // Esto hace que la cuadrícula tenga tres columnas
      // Esto hace que haya 10 píxeles de espacio horizontal entre los botones
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      // Esto hace que la cuadrícula muestre los botones creados en el paso anterior
      children: buildTagButtons(tags, navigator),
    );
  }
}
