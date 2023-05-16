import 'package:portalempleado/menu/Empleado.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmpleadoService {
  static final String _nombreKey = 'nombre';
  static final String _apellidosKey = 'apellidos';
  static final String _emailKey = 'email';
  static final String _telefonoKey = 'telefono';

  static Future<Empleado> cargarEmpleado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nombre = prefs.getString(_nombreKey);
    String? apellidos = prefs.getString(_apellidosKey);
    String? email = prefs.getString(_emailKey);
    String? telefono = prefs.getString(_telefonoKey);
    return Empleado(
      nombre: nombre ?? '',
      apellidos: apellidos ?? '',
      email: email ?? '',
      telefono: telefono ?? '',
    );
  }

  static Future<void> guardarEmpleado(Empleado empleado) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nombreKey, empleado.nombre);
    await prefs.setString(_apellidosKey, empleado.apellidos);
    await prefs.setString(_emailKey, empleado.email);
    await prefs.setString(_telefonoKey, empleado.telefono);
  }
}
