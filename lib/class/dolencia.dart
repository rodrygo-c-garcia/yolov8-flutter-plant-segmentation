// Crea una clase que represente la información que te devuelve la API
class Dolencia {
  // Define los atributos de la clase
  String titulo;
  String introduccion;
  List<String> beneficios;
  List<FormaDeUso> formas_de_uso;
  String precauciones;
  List<String> consejos_adicionales;

  // Crea un constructor de la clase que reciba los atributos como parámetros
  Dolencia({
    required this.titulo,
    required this.introduccion,
    required this.beneficios,
    required this.formas_de_uso,
    required this.precauciones,
    required this.consejos_adicionales,
  });

  // Crea un método que convierta un JSON en un objeto de tipo Dolencia
  factory Dolencia.fromJson(Map<String, dynamic> json) {
    // Obtiene los valores del JSON y los asigna a las variables locales
    var titulo = json['titulo'];
    var introduccion = json['introduccion'];
    var beneficios = List<String>.from(json['beneficios']);
    var formas_de_uso = List<FormaDeUso>.from(
        json['formas_de_uso'].map((x) => FormaDeUso.fromJson(x)));
    var precauciones = json['precauciones'];
    var consejos_adicionales = List<String>.from(json['consejos_adicionales']);

    // Retorna un objeto de tipo Dolencia con los valores obtenidos
    return Dolencia(
      titulo: titulo,
      introduccion: introduccion,
      beneficios: beneficios,
      formas_de_uso: formas_de_uso,
      precauciones: precauciones,
      consejos_adicionales: consejos_adicionales,
    );
  }
}

// Crea una clase que represente una forma de uso de la dolencia
class FormaDeUso {
  // Define los atributos de la clase
  String nombre;
  List<String> instrucciones;
  String recomendacion;

  // Crea un constructor de la clase que reciba los atributos como parámetros
  FormaDeUso({
    required this.nombre,
    required this.instrucciones,
    required this.recomendacion,
  });

  // Crea un método que convierta un JSON en un objeto de tipo FormaDeUso
  factory FormaDeUso.fromJson(Map<String, dynamic> json) {
    // Obtiene los valores del JSON y los asigna a las variables locales
    var nombre = json['nombre'];
    var instrucciones = List<String>.from(json['instrucciones']);
    var recomendacion = json['recomendacion'];

    // Retorna un objeto de tipo FormaDeUso con los valores obtenidos
    return FormaDeUso(
      nombre: nombre,
      instrucciones: instrucciones,
      recomendacion: recomendacion,
    );
  }
}
