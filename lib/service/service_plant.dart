// Crear una clase de servicio que gestione las variables globales
class ServicioPlanta {
  // Usar el patrón singleton para crear una única instancia de la clase
  static final ServicioPlanta _instance = ServicioPlanta._internal();

  // Crear el constructor privado
  ServicioPlanta._internal();

  // Crear el método que devuelve la instancia de la clase
  factory ServicioPlanta() {
    return _instance;
  }

  // Crear los atributos que quieres usar como variables globales
  String planta = "", dolencia = "";

  // Crear la lista de objetos DolenciaPlanta
  List<DolenciaPlanta> lista = [];
}

class DolenciaPlanta {
  final String dolencia;
  final String planta;

  DolenciaPlanta(this.dolencia, this.planta);
}
