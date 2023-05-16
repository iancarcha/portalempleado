class Empleado {
  String nombre;
  String apellidos;
  String email;
  String telefono;

  Empleado({
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.telefono,
  });

  void editarNombre(String nuevoNombre) {
    this.nombre = nuevoNombre;
  }

  void editarApellidos(String nuevosApellidos) {
    this.apellidos = nuevosApellidos;
  }

  void editarEmail(String nuevoEmail) {
    this.email = nuevoEmail;
  }

  void editarTelefono(String nuevoTelefono) {
    this.telefono = nuevoTelefono;
  }
}