import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchHistoriaPage extends StatefulWidget {
  @override
  _SearchHistoriaPageState createState() => _SearchHistoriaPageState();
}

class _SearchHistoriaPageState extends State<SearchHistoriaPage> {
  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? _selectedHistoria;
  bool _isLoading = false;
  bool _isEditing = false;
  String? _errorMessage;

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
    });

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('HistoriaTeraGeneral')
          .where('cedula', isEqualTo: _searchController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _selectedHistoria =
              querySnapshot.docs[0].data() as Map<String, dynamic>;
          _isLoading = false;
        });
      } else {
        setState(() {
          _selectedHistoria = null;
          _isLoading = false;
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

  // Future<void> _updateHistoria() async {
  //   if (_documentReference != null && _selectedHistoria != null) {
  //     await _documentReference!.update(_selectedHistoria!);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Historia actualizada correctamente")),
  //     );
  //     setState(() {
  //       _isEditing = false;
  //     });
  //   }
  // }

  Widget _buildTextField(String label, String key, {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: _selectedHistoria?[key] != null
            ? _selectedHistoria![key].toString()
            : '',
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: false, // activa el color de fondo de capa cmapo de texto
          fillColor: _isEditing ? Colors.white : Colors.grey[300], // Color dinámico
        ),
        maxLines: isMultiline ? 3 : 1,
        onChanged: (value) => _selectedHistoria?[key] = value,
        readOnly: _isEditing, // enbale recubre con un color sobre los cmapos y esta deja que se vea y no se edite
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Historia Clínica de Terapia Psicológica'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cédula del Paciente',
                border: OutlineInputBorder(),
                filled: false,
                fillColor: const Color.fromARGB(255, 255, 255, 255), //FONDO DE LAS CAJAS DE TEXTO
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchHistorias,
                ),
                errorText: _errorMessage,
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : _selectedHistoria != null
                    ? Expanded(
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            children: [
                              _buildTextField("Nombre del Paciente", "nombre"),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                        "Fecha de Evaluación", "fechaEvaluacion"),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: _buildTextField("Edad", "edad"),
                                  ),
                                ],
                              ),
                              _buildTextField("Motivo de Consulta", "motivoConsulta", isMultiline: true),
                              _buildTextField("Estado Emocional", "estadoEmocional"),
                              _buildTextField("Niveles de Estrés y Ansiedad", "estresAnsiedad"),
                              _buildTextField("Dinámica Social", "dinamicaSocial"),
                              _buildTextField("Intervención Terapéutica", "intervencionTerapeutica", isMultiline: true),
                              _buildTextField("Observaciones", "observaciones", isMultiline: true),
                              SizedBox(height: 20),
                              // ElevatedButton(
                              //   onPressed: () {
                              //     setState(() {
                              //       _isEditing = !_isEditing;
                              //     });
                              //   },
                              //   child: Text(_isEditing ? "Cancelar Edición" : "Editar"),
                              // ),
                              // if (_isEditing)
                              //   ElevatedButton(
                              //     onPressed: _updateHistoria,
                              //     child: Text("Guardar Cambios"),
                              //   ),
                            ],
                          ),
                        ),
                      )
                    : Text('No se encontró la historia clínica'),
          ],
        ),
      ),
    );
  }
}