import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:camera/camera.dart';
import '../service/service_plant.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import '../screens/view_plant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantnet_sucre/main.dart';

late List<CameraDescription> cameras;

class YoloVideo extends StatefulWidget {
  final FlutterVision vision;
  const YoloVideo({Key? key, required this.vision}) : super(key: key);

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> with RouteAware {
  // servicio de planta
  ServicioPlanta service = ServicioPlanta();
  // Crea el controlador de screenshot
  ScreenshotController screenshotController = ScreenshotController();

  late CameraController controller;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  int imageHeight = 1;
  int imageWidth = 1;

  List<String> tags = [];

  bool isCaptured = false;
  int frameCount = 0;
  @override
  void initState() {
    super.initState();
    init();
  }

/*
low: 240p (320x240)
medium: 480p (720x480)
high: 720p (1280x720)
veryHigh: 1080p (1920x1080)
ultraHigh: 2160p (3840x2160)
max: La máxima resolución disponible para la cámara
*/

  // inicia el modelo y las camaras

  init() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((value) {
      loadYoloModel().then((value) {
        setState(() {
          isLoaded = true;
          isDetecting = false;
          yoloResults = [];
        });
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
    await widget.vision.closeYoloModel();
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
    setState(() {
      isCaptured = false;
      tags.clear();
      frameCount = 0;
    });
  }

  @override
  void didPushNext() {
    // Se llama cuando se abre la pantalla siguiente y se sale de esta pantalla
    // Aquí puedes detener la detección de plantas
    stopDetection();
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el tamaño de la pantalla
    final Size size = MediaQuery.of(context).size;
    // Obtiene una referencia al Navigator del contexto
    final navigator = Navigator.of(context);
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Cargando Modelo..."),
        ),
      );
    }

    // retornamos un Sreenshot
    return Screenshot(
      // Envuelve el widget Stack con el widget Screenshot
      controller: screenshotController, // Pasa el controlador como parámetro
      child: Stack(
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(
              controller,
            ),
          ),
          ...displayBoxesAroundRecognizedObjects(size, service.planta),
          Positioned(
            bottom: 75,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 5, color: Colors.white, style: BorderStyle.solid),
              ),
              child: isDetecting
                  ? IconButton(
                      onPressed: () async {
                        stopDetection();
                      },
                      icon: const Icon(
                        Icons.stop,
                        color: Colors.red,
                      ),
                      iconSize: 50,
                    )
                  : IconButton(
                      onPressed: () async {
                        await startDetection(navigator);
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                      iconSize: 50,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadYoloModel() async {
    await widget.vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/yolov8LONGV2/longV2_21_320INT.tflite',
        modelVersion: "yolov8seg",
        numThreads: 3,
        useGpu: true);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(
      CameraImage cameraImage, NavigatorState navigator) async {
    imageHeight = cameraImage.height;
    imageWidth = cameraImage.width;

    final result = await widget.vision.yoloOnFrame(
        bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.8,
        confThreshold: 0.4,
        classThreshold: 0.7);
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
      frameCount++;
      tags = yoloResults.map((result) => result['tag']).toList().cast<String>();

      // Captura la pantalla si se cumple la condición
      if (tags.contains(service.planta) && !isCaptured && frameCount >= 3) {
        debugPrint("Planta encontrada: ${service.planta}");
        // Muestra un mensaje emergente con el texto "Enfoca esta planta $tagPlanta"
        isCaptured = true;
        Fluttertoast.showToast(
            msg: "Enfoca la planta ${service.planta}",
            toastLength: Toast.LENGTH_LONG, // La duración del mensaje
            gravity: ToastGravity.TOP, // La posición del mensaje
            timeInSecForIosWeb: 5, // El tiempo que se muestra el mensaje en iOS
            backgroundColor: Colors.blue, // El color de fondo del mensaje
            textColor: Colors.white, // El color del texto del mensaje
            fontSize: 16.0 // El tamaño del texto del mensaje
            );

        // Usa Future.delayed para retrasar la ejecución del método captureScreen
        Future.delayed(const Duration(seconds: 2), () {
          // Llama al método captureScreen después de 3 segundos
          captureScreen(navigator);
        });
      }
    }
  }

  void captureScreen(NavigatorState navigator) async {
    // Captura la imagen como un Uint8List
    Uint8List? capturedImage = await screenshotController.capture();
    // Comprueba si el valor es nulo
    if (capturedImage != null) {
      debugPrint("Imagen a enviar: $capturedImage.toString()");

      navigator.push(
        MaterialPageRoute(
          builder: (context) => ViewPlant(image: capturedImage),
        ),
      );
    } else {
      // Muestra un mensaje de error o un widget alternativo
      debugPrint("No se pudo capturar la imagen");
    }
  }

  Future<void> startDetection(NavigatorState navigator) async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        yoloOnFrame(image, navigator);
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
      tags.clear();
    });
  }

  // cajas y poligonos
  List<Widget> displayBoxesAroundRecognizedObjects(Size screen, String planta) {
    if (yoloResults.isEmpty) return [];
    if (!tags.contains(service.planta)) return [];

    // //double factorX = screen.width / (imageWidth);/
    double factorX = screen.width / (cameraImage?.height ?? 1);
    //double imgRatio = imageWidth / imageHeight;
    //double newWidth = imageWidth * factorX;
    //double newHeight = newWidth / imgRatio;
    //double factorY = newHeight / (imageHeight);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    //double pady = (screen.height - newHeight) / 2;

    Color colorGreen = const Color.fromARGB(136, 0, 255, 0);
    Color colorPick = const Color.fromARGB(136, 233, 30, 57);
    return yoloResults.map((result) {
      // Asignamos nuestro tag

      return Stack(children: [
        Positioned(
          left: result["box"][0] * factorX,
          top: result["box"][1] * factorY,
          width: (result["box"][2] - result["box"][0]) * factorX,
          height: (result["box"][3] - result["box"][1]) * factorY,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(color: Colors.pink, width: 2.0),
            ),
            child: Text(
              "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                background: Paint()
                  ..color = result['tag'] == planta ? colorGreen : colorPick,
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        Positioned(
            left: result["box"][0] * factorX,
            top: result["box"][1] * factorY,
            width: (result["box"][2] - result["box"][0]) * factorX,
            height: (result["box"][3] - result["box"][1]) * factorY,
            child: CustomPaint(
              painter: PolygonPainter(
                  points: (result["polygons"] as List<dynamic>).map((e) {
                    Map<String, double> xy = Map<String, double>.from(e);
                    xy['x'] = (xy['x'] as double) * factorX;
                    xy['y'] = (xy['y'] as double) * factorY;
                    return xy;
                  }).toList(),
                  planta: planta,
                  colorGreen: colorGreen,
                  colorPick: colorPick,
                  tag: result['tag']),
            )),
      ]);
    }).toList();
  }
}

class PolygonPainter extends CustomPainter {
  final List<Map<String, double>> points;
  String planta;
  Color colorPick;
  Color colorGreen;
  String tag;
  PolygonPainter(
      {required this.points,
      required this.planta,
      required this.colorPick,
      required this.colorGreen,
      required this.tag});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = tag == planta ? colorGreen : colorPick
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
