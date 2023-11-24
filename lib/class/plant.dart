class Planta {
  final int id;
  final String nombreComun;
  final String nombreCientifico;
  final String descripcion;
  final Map<String, String> propiedadesMedicinales;
  final List<String> formasDeUso;
  final List<String> contraindicaciones;

  Planta({
    required this.id,
    required this.nombreComun,
    required this.nombreCientifico,
    required this.descripcion,
    required this.propiedadesMedicinales,
    required this.formasDeUso,
    required this.contraindicaciones,
  });

  factory Planta.fromJson(Map<String, dynamic> json) {
    return Planta(
      id: json['id'],
      nombreComun: json['nombre_comun'],
      nombreCientifico: json['nombre_cientifico'],
      descripcion: json['descripcion'],
      propiedadesMedicinales:
          Map<String, String>.from(json['propiedades_medicinales']),
      formasDeUso: List<String>.from(json['formas_de_uso']),
      contraindicaciones: List<String>.from(json['contraindicaciones']),
    );
  }
}
