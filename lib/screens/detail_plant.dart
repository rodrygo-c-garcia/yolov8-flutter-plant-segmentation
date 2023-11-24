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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Informacion de ${widget.tag}"),
      ),
    );
  }
}
