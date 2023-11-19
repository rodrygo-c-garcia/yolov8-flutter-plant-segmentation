import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import '../models/yolo_image_v8seg.dart';
import '../models/yolo_capture_v8seg.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'capture_ailment.dart';
import 'dart:async';

enum Options { none, imagev8seg, capturev8seg, frame }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlutterVision vision;
  Timer? _timer;

  Options option = Options.none;
  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
    // incializamos el loading
    EasyLoading.addStatusCallback((status) {
      debugPrint('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    EasyLoading.showSuccess('Use in initState');
    // EasyLoading.removeCallbacks();
  }

  @override
  void dispose() async {
    super.dispose();
    await vision.closeTesseractModel();
    await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          // Esto crea una fila horizontal
          children: [
            Icon(Icons.camera), // Esto muestra un icono de una planta
            SizedBox(
                width: 8), // Esto añade un espacio entre el icono y el texto
            Text('PlantNet Sucre'), // Esto muestra el texto del título
          ],
        ),
        backgroundColor: Colors.green, // Esto cambia el fondo a verde
      ),
      body: task(option),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        //barra de menú horizontal
        items: const [
          //ítems de la barra
          BottomNavigationBarItem(
            //ítem para YoloV8seg on Frame
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            //ítem para YoloV8seg on Image
            icon: Icon(Icons.image),
            label: 'On Image',
          ),
          BottomNavigationBarItem(
            //ítem para YoloV8seg on capture
            icon: Icon(Icons.camera),
            label: 'On Capture',
          ),
          BottomNavigationBarItem(
            //ítem para YoloV8seg on capture
            icon: Icon(Icons.video_call),
            label: 'On Frame',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: option.index, //índice del ítem seleccionado
        onTap: (int index) {
          //función para cambiar el ítem seleccionado
          setState(() {
            option = Options.values[index];
          });
        },
      ),
    );
  }

  Widget task(Options option) {
    if (option == Options.frame) {
      //return YoloVideo(vision: vision);
      return const CaptureAilment();
    }
    if (option == Options.imagev8seg) {
      return YoloImageV8Seg(vision: vision);
    }
    if (option == Options.capturev8seg) {
      return YoloCaptureV8Seg(vision: vision);
    }
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.green[200], // Esto es un color verde claro
          ),
          const Image(
            image: AssetImage("assets/images/OIG3.jpeg"),
          ),
        ],
      ),
    );
  }
}
