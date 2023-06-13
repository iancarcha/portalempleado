class Empleado {
  String nombre;
  String apellidos;
  String email;
  String telefono;
  String provincia;
  String direccion;
  String apodo;

  // Constructor de la clase Empleado
  Empleado({
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.telefono,
    required this.provincia,
    required this.direccion,
    required this.apodo,
  });

  // Método para editar el nombre del empleado
  void editarNombre(String nuevoNombre) {
    this.nombre = nuevoNombre;
  }

  // Método para editar los apellidos del empleado
  void editarApellidos(String nuevosApellidos) {
    this.apellidos = nuevosApellidos;
  }

  // Método para editar el email del empleado
  void editarEmail(String nuevoEmail) {
    this.email = nuevoEmail;
  }

  // Método para editar el teléfono del empleado
  void editarTelefono(String nuevoTelefono) {
    this.telefono = nuevoTelefono;
  }

  // Método para editar la provincia del empleado
  void editarProvincia(String nuevoProvincia) {
    this.provincia = nuevoProvincia;
  }

  // Método para editar la dirección del empleado
  void editarDireccion(String nuevoDireccion) {
    this.direccion = nuevoDireccion;
  }

  // Método para editar el apodo del empleado
  void editarApodo(String nuevoApodo) {
    this.apodo = nuevoApodo;
  }
}
