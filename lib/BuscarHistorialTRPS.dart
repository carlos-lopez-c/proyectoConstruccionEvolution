import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class BuscarHistorialTRPS extends StatefulWidget {
  @override
  _BuscarHistorialTRPSState createState() => _BuscarHistorialTRPSState();
}

class _BuscarHistorialTRPSState extends State<BuscarHistorialTRPS> {
  final TextEditingController _cedulaController = TextEditingController();
  List<Map<String, dynamic>> _historiales = [];

  Future<void> _buscarHistorial() async {
    String cedula = _cedulaController.text.trim();

    if (cedula.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese una cédula')),
      );
      return;
    }

    try {
      // Obtener la carpeta local donde se almacenan los PDFs
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('No se pudo acceder al almacenamiento externo');
      }

      final folderPath = '${directory.path}/TerapPS';
      final folder = Directory(folderPath);

      if (!await folder.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró la carpeta de PDFs')),
        );
        return;
      }

      // Listar todos los archivos PDF en la carpeta
      List<FileSystemEntity> files = folder.listSync();
      List<Map<String, dynamic>> historiales = [];

      for (var file in files) {
        if (file is File && file.path.endsWith('.pdf')) {
          // Extraer el nombre del archivo sin la ruta completa
          String fileName = file.path.split('/').last;

          // Filtrar por cédula si el nombre del archivo contiene la cédula
          if (fileName.contains(cedula)) {
            historiales.add({
              'nombre': fileName,
              'pdfFileName': fileName,
            });
          }
        }
      }

      if (historiales.isNotEmpty) {
        setState(() {
          _historiales = historiales;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontraron PDFs para esta cédula')),
        );
        setState(() {
          _historiales = [];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar historiales: $e')),
      );
    }
  }

  Future<void> _abrirPDF(String fileName) async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('No se pudo acceder al almacenamiento externo');
      }

      final filePath = '${directory.path}/TerapPS/$fileName';

      final file = File(filePath);
      if (await file.exists()) {
        await launch('file://$filePath');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF no encontrado en el dispositivo')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al abrir el PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar Historial TRPS')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cedulaController,
              decoration: InputDecoration(
                labelText: 'Ingrese la cédula',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _buscarHistorial,
              child: Text('Buscar'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _historiales.length,
                itemBuilder: (context, index) {
                  final historial = _historiales[index];
                  return Card(
                    child: ListTile(
                      title: Text(historial['nombre']),
                      trailing: IconButton(
                        icon: Icon(Icons.picture_as_pdf, color: Colors.red),
                        onPressed: () => _abrirPDF(historial['pdfFileName']),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}