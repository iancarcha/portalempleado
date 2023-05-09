import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


class UploadFilePage extends StatefulWidget {
  @override
  _UploadFilePageState createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  late File _selectedFile = File('');
  bool _isFileUploaded = false;
  bool _isUploadFailed = false;

  // Seleccionar el archivo
  void _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'pdf','jpeg','jpg'],
    );
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  // Funcion para cargar archivos
  void _uploadFile() async {
    try {
      // Implementa aquí el código para cargar el archivo seleccionado
      // Puedes utilizar un paquete como http o dio para realizar la solicitud HTTP

      // Esperar 3 segundos
      await Future.delayed(Duration(seconds: 3));

      setState(() {
        _isFileUploaded = true;
        _isUploadFailed = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        _isUploadFailed = true;
        _isFileUploaded = false;
      });
    }
  }

  // Function para descargar archivos
  void _downloadFile() {
    // Implementa aquí el código para descargar el archivo seleccionado
    // Puedes utilizar un paquete como http o dio para realizar la solicitud HTTP
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir archivo'),
        backgroundColor: Color(0xFF1C4E80),
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
                      onPressed: _downloadFile,
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
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF1C4E80)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
