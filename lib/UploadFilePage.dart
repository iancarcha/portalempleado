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
      // Implement your code to upload the selected file here
      // You can use a package like http or dio to perform the HTTP request

      // 3 segunditos de espera
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
    // Implement your code to download the selected file here
    // You can use a package like http or dio to perform the HTTP request
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir archivo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedFile.path != '') ...[
              Text('Archivo seleccionado: ${_selectedFile.path}'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadFile,
                child: Text('Subir archivo'),
              ),
              SizedBox(height: 20),
              if (_isFileUploaded)
                Column(
                  children: [
                    Text('El archivo se ha subido correctamente'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _downloadFile,
                      child: Text('Descargar archivo'),
                    ),
                  ],
                ),
              if (_isUploadFailed)
                Text(
                  'Se produjo un error al cargar el archivo. Inténtalo de nuevo.',
                  style: TextStyle(color: Colors.red),
                ),
            ] else ...[
              Text('Selecciona un archivo para subir'),
              SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: _selectFile,
              child: Text('Seleccionar archivo'),
            ),
          ],
        ),
      ),
    );
  }
}
