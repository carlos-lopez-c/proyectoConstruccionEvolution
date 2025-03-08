import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class BuscarHistorial extends StatefulWidget {
  const BuscarHistorial({super.key});

  @override
  _BuscarHistorialState createState() => _BuscarHistorialState();
}

class _BuscarHistorialState extends State<BuscarHistorial> {
  final TextEditingController _cedulaController = TextEditingController();
  List<File> _pdfsEncontrados = [];

  Future<void> _buscarPdfsPorCedula() async {
    final cedula = _cedulaController.text.trim();

    if (cedula.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese una cédula')),
      );
      return;
    }

    try {
      // Obtener el directorio de almacenamiento externo
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('No se pudo acceder al almacenamiento externo');
      }

      // Crear la carpeta "AdultPS" si no existe
      final folder = Directory('${directory.path}/AdultPS');
      if (!await folder.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontraron PDFs para esta cédula')),
        );
        return;
      }

      // Buscar archivos PDF que coincidan con la cédula
      final archivos = folder.listSync();
      final pdfs = archivos.where((archivo) {
        return archivo.path.endsWith('.pdf') && archivo.path.contains(cedula);
      }).toList();

      setState(() {
        _pdfsEncontrados = pdfs.cast<File>();
      });

      if (_pdfsEncontrados.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontraron PDFs para esta cédula')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar PDFs: $e')),
      );
    }
  }

  void _abrirPdf(File pdfFile) {
    // Aquí puedes implementar la lógica para abrir el PDF
    // Por ejemplo, usar un paquete como `flutter_pdfview` para visualizar el PDF.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Abriendo PDF: ${pdfFile.path}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Historial por Cédula'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cedulaController,
              decoration: const InputDecoration(
                labelText: 'Ingrese la cédula',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _buscarPdfsPorCedula,
              child: const Text('Buscar PDFs'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _pdfsEncontrados.isEmpty
                  ? const Center(
                      child: Text('No se encontraron PDFs'),
                    )
                  : ListView.builder(
                      itemCount: _pdfsEncontrados.length,
                      itemBuilder: (context, index) {
                        final pdfFile = _pdfsEncontrados[index];
                        return ListTile(
                          title: Text('PDF: ${pdfFile.path.split('/').last}'),
                          onTap: () => _abrirPdf(pdfFile),
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