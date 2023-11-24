import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:screenshot/screenshot.dart';
import '../screens/plants_list.dart';
import 'package:plantnet_sucre/main.dart';

class YoloCaptureV8Seg extends StatefulWidget {
  final FlutterVision vision;
  const YoloCaptureV8Seg({Key? key, required this.vision}) : super(key: key);

  @override
  State<YoloCaptureV8Seg> createState() => _YoloV8CaptureSegState();
}

class _YoloV8CaptureSegState extends State<YoloCaptureV8Seg> with RouteAware {
  late List<Map<String, dynamic>> yoloResults;
  ScreenshotController screenshotController = ScreenshotController();
  File? imageFile;
  int imageHeight = 1;
  int imageWidth = 1;
  bool isLoaded = false;
  List<String> tags = [];
  bool isDetected = false;

  @override
  void initState() {
    super.initState();
    loadYoloModel().then((value) {
      setState(() {
        yoloResults = [];
        isLoaded = true;
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Registra el RouteObserver para esta pantalla
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    // Invoca a super para comunicarte con el RouteObserver
    super.didPush();
  }

  // Define el método didPop que se llama cuando se cierra esta pantalla
  @override
  void didPop() {
    // Invoca a super para comunicarte con el RouteObserver
    super.didPop();
  }

  @override
  void didPopNext() {
    // Esta función se ejecuta cuando se cierra la pantalla ViewPlant y se vuelve a la pantalla _YoloVideoState
    super.didPopNext();
    // Aquí puedes restablecer el valor de isDetected a false
    setState(() {});
  }

  @override
  void didPushNext() {
    // Se llama cuando se abre la pantalla siguiente y se sale de esta pantalla
    // Aquí puedes detener la detección de plantas
    isDetected = true;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Cargando Modelo..."),
        ),
      );
    }
    final navigator = Navigator.of(context);
    return Screenshot(
      // Envuelve el widget Stack con el widget Screenshot
      controller: screenshotController,
      child: Stack(
        fit: StackFit.expand,
        children: [
          imageFile != null ? Image.file(imageFile!) : const SizedBox(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: pickImage,
                  child: const Text("Capturar imagen"),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: yoloOnImage,
                  child: const Text("Identificar"),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    plantsList(navigator);
                  },
                  style: ElevatedButton.styleFrom(
                    // Esto cambia el estilo del botón
                    backgroundColor: Colors
                        .green, // Esto hace que el botón sea de color verde
                  ),
                  child: const Text("Ver Planta"),
                ),
              ],
            ),
          ),
          ...displayBoxesAroundRecognizedObjects(size),
        ],
      ),
    );
  }

  Future<void> loadYoloModel() async {
    await widget.vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/best640_float32.tflite',
        modelVersion: "yolov8seg",
        quantization: false,
        numThreads: 6,
        useGpu: true);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Capture a photo
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        imageFile = File(photo.path);
      });
    }
  }

  yoloOnImage() async {
    // Muestra el loading con el indicador de tipo cubeGrid
    if (!(imageFile == null)) {
      EasyLoading.show(
        status: 'Identificando Planta...',
      );

      yoloResults.clear();
      Uint8List byte = await imageFile!.readAsBytes();
      final image = await decodeImageFromList(byte);
      imageHeight = image.height;
      imageWidth = image.width;
      final result = await widget.vision.yoloOnImage(
          bytesList: byte,
          imageHeight: image.height,
          imageWidth: image.width,
          iouThreshold: 0.8,
          confThreshold: 0.4,
          classThreshold: 0.5);
      if (result.isNotEmpty) {
        EasyLoading.showSuccess('Identificado!');
        setState(() {
          yoloResults = result;
          isDetected = false;
        });
        tags =
            yoloResults.map((result) => result['tag']).toList().cast<String>();
        tags = tags.toSet().toList();
        debugPrint("TAGS: $tags.toString()");
      } else {
        // Muestra un mensaje de error si el resultado está vacío
        EasyLoading.showError('No se pudo identificar la Planta.');
      }
      // Oculta el loading después de llamar al método setState
      EasyLoading.dismiss();
    } else {
      Fluttertoast.showToast(
          msg: "Por favor suba una imagen primero.",
          toastLength: Toast.LENGTH_LONG, // La duración del mensaje
          gravity: ToastGravity.CENTER, // La posición del mensaje
          timeInSecForIosWeb: 3, // El tiempo que se muestra el mensaje en iOS
          backgroundColor: Colors.blue, // El color de fondo del mensaje
          textColor: Colors.white, // El color del texto del mensaje
          fontSize: 16.0 // El tamaño del texto del mensaje
          );
    }
  }

  void plantsList(NavigatorState navigator) async {
    if (tags.isNotEmpty && !isDetected) {
      Uint8List? capturedImage = await screenshotController.capture();
      // Obtener el objeto RenderRepaintBoundary del widget usando el operador as

      // Comprueba si el valor es nulo
      if (capturedImage != null) {
        navigator.push(
          MaterialPageRoute(
            builder: (context) => PlantsList(image: capturedImage, tags: tags),
          ),
        );
      }
    } else {
      Fluttertoast.showToast(
          msg: "Por favor identifique una planta primero.",
          toastLength: Toast.LENGTH_LONG, // La duración del mensaje
          gravity: ToastGravity.CENTER, // La posición del mensaje
          timeInSecForIosWeb: 3, // El tiempo que se muestra el mensaje en iOS
          backgroundColor: Colors.orange, // El color de fondo del mensaje
          textColor: Colors.white, // El color del texto del mensaje
          fontSize: 16.0 // El tamaño del texto del mensaje
          );
    }
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];

    double factorX = screen.width / (imageWidth);
    double imgRatio = imageWidth / imageHeight;
    double newWidth = imageWidth * factorX;
    double newHeight = newWidth / imgRatio;
    double factorY = newHeight / (imageHeight);

    double pady = (screen.height - newHeight) / 3.5;

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);
    return yoloResults.map((result) {
      return Stack(children: [
        Positioned(
          left: result["box"][0] * factorX,
          top: result["box"][1] * factorY + pady,
          width: (result["box"][2] - result["box"][0]) * factorX,
          height: (result["box"][3] - result["box"][1]) * factorY,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(color: Colors.pink, width: 2.0),
            ),
            child: Text(
              "${result['tag'] == "alparraco" ? "alcaparro" : result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                background: Paint()..color = colorPick,
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        Positioned(
            left: result["box"][0] * factorX,
            top: result["box"][1] * factorY + pady,
            width: (result["box"][2] - result["box"][0]) * factorX,
            height: (result["box"][3] - result["box"][1]) * factorY,
            child: CustomPaint(
              painter: PolygonPainter(
                  points: (result["polygons"] as List<dynamic>).map((e) {
                Map<String, double> xy = Map<String, double>.from(e);
                xy['x'] = (xy['x'] as double) * factorX;
                xy['y'] = (xy['y'] as double) * factorY;
                return xy;
              }).toList()),
            )),
      ]);
    }).toList();
  }
}

class PolygonPainter extends CustomPainter {
  final List<Map<String, double>> points;

  PolygonPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(129, 255, 2, 124)
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0]['x']!, points[0]['y']!);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i]['x']!, points[i]['y']!);
      }
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
