import 'dart:io'; // Importar librería para trabajar con archivos
import 'package:path_provider/path_provider.dart'; // Importar librería para obtener el directorio de almacenamiento
import 'package:flutter/material.dart'; // Importar librería de Flutter para construir la interfaz de usuario
import 'package:file_picker/file_picker.dart'; // Importar librería para seleccionar archivos
import 'package:firebase_storage/firebase_storage.dart'; // Importar librería para interactuar con Firebase Storage
import 'package:path/path.dart'; // Importar librería para manejar rutas de archivos
import 'package:http/http.dart' as http; // Importar librería para realizar solicitudes HTTP

class UploadFilePage extends StatefulWidget {
  @override
  _UploadFilePageState createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  late File _selectedFile = File(''); // Variable que representa el archivo seleccionado
  bool _isFileUploaded = false; // Variable para indicar si el archivo ha sido subido correctamente
  bool _isUploadFailed = false; // Variable para indicar si ha ocurrido un error durante la subida del archivo

  // Seleccionar el archivo
  void _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom, // Tipo de archivo permitido
      allowedExtensions: ['png', 'pdf', 'jpeg', 'jpg'], // Extensiones permitidas
    );
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!); // Guardar el archivo seleccionado en la variable
      });
    }
  }

  // Función para cargar archivos
  void _uploadFile() async {
    try {
      if (_selectedFile.path != '') { // Verificar que haya un archivo seleccionado
        String fileName = basename(_selectedFile.path); // Obtener el nombre del archivo
        Reference storageRef = FirebaseStorage.instance.ref().child(fileName); // Crear una referencia al archivo en Firebase Storage
        UploadTask uploadTask = storageRef.putFile(_selectedFile); // Subir el archivo
        await uploadTask.whenComplete(() => null); // Esperar a que se complete la subida
        setState(() {
          _isFileUploaded = true; // Indicar que el archivo ha sido subido correctamente
          _isUploadFailed = false; // Indicar que no ha ocurrido un error durante la subida
        });
      }
    } catch (e) {
      print(e.toString()); // Imprimir el error en caso de que ocurra
      setState(() {
        _isUploadFailed = true; // Indicar que ha ocurrido un error durante la subida
        _isFileUploaded = false; // Indicar que el archivo no ha sido subido correctamente
      });
    }
  }

  // Función para descargar el archivo
  void _downloadFile(BuildContext context) async {
    if (_selectedFile.path != '') { // Verificar que haya un archivo seleccionado
      String fileName = basename(_selectedFile.path); // Obtener el nombre del archivo
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName); // Crear una referencia al archivo en Firebase Storage
      final url = await storageRef.getDownloadURL(); // Obtener la URL de descarga del archivo

      // Realizar la solicitud HTTP para descargar el archivo
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) { // Verificar que la descarga sea exitosa
        // Guardar el archivo en el dispositivo

        // Obtener el directorio de almacenamiento externo
        final directory = await getExternalStorageDirectory();
        final filePath = '${directory!.path}/$fileName';

        // Guardar el archivo en el directorio de almacenamiento externo
        File(filePath).writeAsBytes(response.bodyBytes);

        // Mostrar una notificación o mensaje al usuario de que la descarga ha sido exitosa
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: Text('Descarga completa'),
            content: Text('El archivo se ha descargado exitosamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          ),
        );
      } else {
        // Mostrar una notificación o mensaje al usuario de que ha ocurrido un error durante la descarga
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: Text('Error de descarga'),
            content: Text('Ocurrió un error al descargar el archivo.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir archivo'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              'Subir archivo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C4E80),
              ),
            ),
            SizedBox(height: 30),
            if (_selectedFile.path != '') ...[
              Text(
                'Archivo seleccionado:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C4E80),
                ),
              ),
              SizedBox(height: 10),
              Text(
                _selectedFile.path,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1C4E80),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadFile,
                child: Text(
                  'Subir archivo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF1C4E80)),
                ),
              ),
              SizedBox(height: 20),
              if (_isFileUploaded)
                Column(
                  children: [
                    Text(
                      'El archivo se ha subido correctamente',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C4E80),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _downloadFile(context); // Pasar el contexto desde el método build()
                      },
                      child: Text(
                        'Descargar archivo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFF1C4E80)),
                      ),
                    ),
                  ],
                ),
              if (_isUploadFailed)
                Text(
                  'Se produjo un error al cargar el archivo. Inténtalo de nuevo.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
            ] else ...[
              Text(
                'Selecciona un archivo para subir',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C4E80),
                ),
              ),
              SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: _selectFile,
              child: Text(
                'Seleccionar archivo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
