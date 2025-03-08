import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchHistoriaPageTP extends StatefulWidget {
  @override
  _SearchHistoriaPageTPState createState() => _SearchHistoriaPageTPState();
}

class _SearchHistoriaPageTPState extends State<SearchHistoriaPageTP> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _selectedHistoria;
  bool _isLoading = false;
  String? _errorMessage;

  // Función de búsqueda
  Future<void> _searchHistorias() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _errorMessage = "Ingresa la cédula del paciente";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedHistoria = null;
    });

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('HistoriaTeraGeneral')
          .where('cedula', isEqualTo: _searchController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _selectedHistoria = querySnapshot.docs.first.data() as Map<String, dynamic>;
          _isLoading = false;
        });
      } else {
        setState(() {
          _selectedHistoria = null;
          _isLoading = false;
          _errorMessage = 'No pertenece a esta sección';
        });
      }
    } catch (e) {
      print("Error al buscar historias clínicas: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = "Error al buscar la historia clínica";
      });
    }
  }

  // Construcción del campo de texto
  Widget _buildTextField(String label, String key, {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: TextFormField(
        initialValue: _selectedHistoria?[key]?.toString() ?? 'No disponible',
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        maxLines: isMultiline ? 3 : 1,
        readOnly: true,
      ),
    );
  }

  // Pantalla de búsqueda
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Historia Clínica'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.0),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Ingresa la cédula',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: _searchHistorias,
                child: Text('Buscar'),
              ),
              if (_isLoading) CircularProgressIndicator(),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              if (_selectedHistoria != null) ...[
                _buildTextField("Nombre", "nombre"),
                _buildTextField("Cédula", "cedula"),
                _buildTextField("Edad", "edad"),
                _buildTextField("Fecha de Nacimiento", "fechaNacimiento"),
                _buildTextField("Fecha de Evaluación", "fechaEvaluacion"),
                _buildTextField("Motivo de Consulta", "motivoConsulta", isMultiline: true),
                _buildTextField("Observaciones", "observaciones", isMultiline: true),
                _buildTextField("Dinámica Social", "dinamicaSocial"),
                _buildTextField("Estado Emocional", "estadoEmocional"),
                _buildTextField("Estrés y Ansiedad", "estresAnsiedad"),
                _buildTextField("Intervención Terapéutica", "intervencionTerapeutica"),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
