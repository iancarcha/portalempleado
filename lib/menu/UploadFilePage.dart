/*import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class UploadFilePage extends StatefulWidget {
  @override
  _UploadFilePageState createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  late File _selectedFile = File('');
  bool _isFileUploaded = false;
  bool _isUploadFailed = false;*/

  // Seleccionar el archivo
  /*void _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'pdf', 'jpeg', 'jpg'],
    );
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }*/

  // Funcion para cargar archivos
  /*void _uploadFile() async {
    try {
      if (_selectedFile.path != '') {
        String fileName = basename(_selectedFile.path);
        Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(_selectedFile);
        await uploadTask.whenComplete(() => null);
        setState(() {
          _isFileUploaded = true;
          _isUploadFailed = false;
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        _isUploadFailed = true;
        _isFileUploaded = false;
      });
    }
  }

  void _downloadFile(BuildContext context) async {
    if (_selectedFile.path != '') {
      String fileName = basename(_selectedFile.path);
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      final url = await storageRef.getDownloadURL();*/

      // Realizar la solicitud HTTP para descargar el archivo
      /*var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {*/
        // Guardar el archivo en el dispositivo

        // Obtener el directorio de descarga
        //final directory = await getDownloadsDirectory();
        //final filePath = '${directory!.path}/$fileName';

        // Guardar el archivo en el directorio de descarga
        //File(filePath).writeAsBytes(response.bodyBytes);

        // Mostrar una notificación o mensaje al usuario de que la descarga ha sido exitosa
        /*showDialog(
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
  }*/


  /*@override
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
            ),
          ],
        ),
      ),
    );
  }
}
*/