// Define la clase Comunicacion
class Comunicacion {
  String id; // Identificador de la comunicación
  String titulo; // Título de la comunicación
  String descripcion; // Descripción de la comunicación
  DateTime fecha; // Fecha de la comunicación
  String autor; // Autor de la comunicación

  // Constructor de la clase Comunicacion
  Comunicacion({
    required this.id, // Parámetro requerido: identificador
    required this.titulo, // Parámetro requerido: título
    required this.descripcion, // Parámetro requerido: descripción
    required this.fecha, // Parámetro requerido: fecha
    required this.autor, // Parámetro requerido: autor
  });
}
