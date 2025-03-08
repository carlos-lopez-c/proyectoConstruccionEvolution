import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HistorialNino extends StatefulWidget {
  const HistorialNino({super.key});

  @override
  _HistorialNinoState createState() => _HistorialNinoState();
}

class _HistorialNinoState extends State<HistorialNino> {
  List<File> _pdfFiles = [];
  List<File> _filteredPdfFiles = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPDFs();
  }

  Future<void> _loadPDFs() async {
    try {
      // Obtener el directorio de almacenamiento externo
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('No se pudo acceder al almacenamiento externo');
      }

      // Ruta de la carpeta AdultPS
      final path = '${directory.path}/NinosPS';
      final dir = Directory(path);

      if (dir.existsSync()) {
        // Buscar archivos PDF en la carpeta
        final files = dir.listSync().where((file) {
          return file is File && file.path.endsWith('.pdf');
        }).cast<File>().toList();

        setState(() {
          _pdfFiles = files;
          _filteredPdfFiles = files;
        });
      } else {
        // Si la carpeta no existe, no hay archivos
        setState(() {
          _pdfFiles = [];
          _filteredPdfFiles = [];
        });
      }
    } catch (e) {
      // Manejar errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los PDFs: $e')),
      );
    }
  }

  void _filterPDFs(String query) {
    setState(() {
      _filteredPdfFiles = _pdfFiles.where((file) {
        final fileName = file.path.split('/').last;
        return fileName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Niños'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar por cédula',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _filterPDFs(_searchController.text);
                  },
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredPdfFiles.isEmpty
                ? const Center(
                    child: Text('No se encontraron archivos PDF'),
                  )
                : ListView.builder(
                    itemCount: _filteredPdfFiles.length,
                    itemBuilder: (context, index) {
                      final file = _filteredPdfFiles[index];
                      final fileName = file.path.split('/').last;
                      return ListTile(
                        title: Text(fileName),
                        trailing: IconButton(
                          icon: const Icon(Icons.open_in_new),
                          onPressed: () {
                            // Abrir el PDF (puedes usar un paquete como `flutter_pdfview`)
                            _openPDF(file);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _openPDF(File file) {
    // Aquí puedes implementar la lógica para abrir el PDF
    // Por ejemplo, usando el paquete `flutter_pdfview`
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Abriendo PDF: ${file.path}')),
    );
  }
}