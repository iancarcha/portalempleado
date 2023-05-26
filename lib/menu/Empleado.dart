class Empleado {
  String nombre;
  String apellidos;
  String email;
  String telefono;
  String provincia;
  String direccion;

  Empleado({
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.telefono,
    required this.provincia,
    required this.direccion,
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

  void editarProvincia(String nuevoProvincia) {
    this.provincia = nuevoProvincia;
  }

  void editarDireccion(String nuevoDireccion) {
    this.direccion = nuevoDireccion;
  }
}