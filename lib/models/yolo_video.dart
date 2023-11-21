import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:camera/camera.dart';
import '../service/service_plant.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import '../screens/view_plant.dart';
import 'package:fluttertoast/fluttertoast.dart';

late List<CameraDescription> cameras;

class YoloVideo extends StatefulWidget {
  final FlutterVision vision;
  const YoloVideo({Key? key, required this.vision}) : super(key: key);

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> {
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
  Widget build(BuildContext context) {
    // Obtenemos el tamaño de la pantalla
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Cargando Modelo..."),
        ),
      );
    }
    return Stack(
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
                      await startDetection();
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
    );
  }

  Future<void> loadYoloModel() async {
    await widget.vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/best224_float32.tflite',
        modelVersion: "yolov8seg",
        numThreads: 4,
        useGpu: true);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    imageHeight = cameraImage.height;
    imageWidth = cameraImage.width;
    final result = await widget.vision.yoloOnFrame(
        bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.4,
        confThreshold: 0.4,
        classThreshold: 0.5);
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  // cajas y poligonos
  List<Widget> displayBoxesAroundRecognizedObjects(Size screen, String planta) {
    if (yoloResults.isEmpty) return [];

    //double factorX = screen.width / (imageWidth);
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
      debugPrint(result['tag']);
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
