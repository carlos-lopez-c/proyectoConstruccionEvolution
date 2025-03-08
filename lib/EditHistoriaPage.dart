import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditHistoriaPage extends StatefulWidget {
  final String historiaId;
  final Map<String, dynamic> historiaData;

  EditHistoriaPage({required this.historiaId, required this.historiaData});

  @override
  _EditHistoriaPageState createState() => _EditHistoriaPageState();
}

class _EditHistoriaPageState extends State<EditHistoriaPage> {
  late TextEditingController _nombreController;
  late TextEditingController _motivoController;

  @override
  void initState() {
    super.initState();
    // Inicializamos los controladores con los valores actuales de la historia clínica
    _nombreController = TextEditingController(text: widget.historiaData['nombre']);
    _motivoController = TextEditingController(text: widget.historiaData['motivoC']);
  }

  Future<void> _saveChanges() async {
    try {
      // Actualizar los datos en Firebase
      await FirebaseFirestore.instance
          .collection('historias_clinicas')
          .doc(widget.historiaId)
          .update({
        'nombre': _nombreController.text,
        'motivoC': _motivoController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cambios guardados exitosamente')));
      Navigator.pop(context); // Regresar a la página anterior
    } catch (e) {
      print('Error al actualizar la historia clínica: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar los cambios')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Historia Clínica'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre completo'),
            ),
            TextField(
              controller: _motivoController,
              decoration: InputDecoration(labelText: 'Motivo de consulta'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
