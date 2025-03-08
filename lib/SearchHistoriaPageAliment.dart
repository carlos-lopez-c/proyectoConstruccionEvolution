import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchHistoriaPageAliment extends StatefulWidget {
  @override
  _SearchHistoriaPageAlimentState createState() => _SearchHistoriaPageAlimentState();
}

class _SearchHistoriaPageAlimentState extends State<SearchHistoriaPageAliment> {
  late ScrollController _scrollController;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(); // Inicializa el controlador aquí
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Libera los recursos del controlador
    super.dispose();
  }

  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _results = [];
  bool _isLoading = false;
  bool _isEditing = false; // Indica si el modo de edición está activado
  Map<String, dynamic>? _selectedHistoria;
 
 String? _lateralidad;
  String? _IA1;
  String? _IA2;
  String? _IA3;
  String? _IA4;

  String? _EF1;
  String? _EF2;
  String? _EF3;
  String? _EF4;

  String? _S1;
  String? _S2;
  String? _S3;
  String? _S4;
  String? _S5;
  String? _S6;
  String? _S7;

  String? _PA1;
  String? _PA2;
  String? _PA3;

  String? _SB1;
  String? _SB2;
  String? _SB3;
  String? _SB4;
  String? _SB5;

  Future<void> _searchHistorias() async {
    setState(() {
      _isLoading = true;
      _isEditing = false;
    });

    try {
      // Realiza la búsqueda en Firestore por nombre
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('HistoriaAnamAliment')
          .where('nombre', isEqualTo: _searchController.text)
          .get();

      setState(() {
        _results = querySnapshot.docs;
        _isLoading = false;

        if (_results.isNotEmpty) {
          _selectedHistoria = _results[0].data() as Map<String, dynamic>;

          // Asegurarse de que el campo 'sexo' existe en la historia seleccionada
          
          _lateralidad = _selectedHistoria?['lateralidad'] ?? '';
          _IA1 = _selectedHistoria?['IA1'] ?? '';
_IA2 = _selectedHistoria?['IA2'] ?? '';
_IA3 = _selectedHistoria?['IA3'] ?? '';
_IA4 = _selectedHistoria?['IA4'] ?? '';

_EF1 = _selectedHistoria?['EF1'] ?? '';
_EF2 = _selectedHistoria?['EF2'] ?? '';
_EF3 = _selectedHistoria?['EF3'] ?? '';
_EF4 = _selectedHistoria?['EF4'] ?? '';

_S1 = _selectedHistoria?['S1'] ?? '';
_S2 = _selectedHistoria?['S2'] ?? '';
_S3 = _selectedHistoria?['S3'] ?? '';
_S4 = _selectedHistoria?['S4'] ?? '';
_S5 = _selectedHistoria?['S5'] ?? '';
_S6 = _selectedHistoria?['S6'] ?? '';
_S7 = _selectedHistoria?['S7'] ?? '';

_PA1 = _selectedHistoria?['PA1'] ?? '';
_PA2 = _selectedHistoria?['PA2'] ?? '';
_PA3 = _selectedHistoria?['PA3'] ?? '';

_SB1 = _selectedHistoria?['SB1'] ?? '';
_SB2 = _selectedHistoria?['SB2'] ?? '';
_SB3 = _selectedHistoria?['SB3'] ?? '';
_SB4 = _selectedHistoria?['SB4'] ?? '';
_SB5 = _selectedHistoria?['SB5'] ?? '';

          

          _selectedHistoria = _results[0].data() as Map<String, dynamic>;
        }
      });
    } catch (e) {
      print("Error al buscar historias clínicas: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    try {
      if (_selectedHistoria != null) {
        // Actualizar el documento en Firestore
        await FirebaseFirestore.instance
            .collection('HistoriaAnamAliment')
            .doc(_results[0].id)
            .update(_selectedHistoria!);

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Cambios guardados exitosamente'),
        ));

        // Desactivar el modo de edición
        setState(() {
          _isEditing = false;
        });
      }
    } catch (e) {
      print("Error al guardar los cambios: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al guardar los cambios: $e'),
      ));
    }
  }

  Widget _buildRadioButtonGroup(String label, List<String> options,
      String? groupValue, void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 0.0,
            runSpacing: 4.0,
            children: options.map((option) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<String>(
                    value: option,
                    groupValue: groupValue, // El valor actualmente seleccionado
                    onChanged: _isEditing
                        ? onChanged
                        : null, // Solo permite cambiar si está en modo edición
                  ),
                  Text(option),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar - Anamesis de Alimentos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Nombre del Paciente',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchHistorias,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isEditing
                      ? _saveChanges
                      : () {
                          setState(() {
                            _isEditing = true; // Activar modo edición
                          });
                        },
                  child: Text(_isEditing ? 'Guardar' : 'Editar'),
                ),
              ],
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : _selectedHistoria != null
                    ? Expanded(
                        child: ListView(
                          controller:
                              _scrollController, // Asignar el controlador
                          children: [
                            _buildSection('1.- Antecedentes personales'),
                           _buildTextField('Nombre', 'nombre'),
                           _buildTextField('Fecha de la entrevista', 'fechaEntrevista'),
                           _buildRadioButtonGroup(
                              'Lateralidad',
                              ['Diestro', 'Zurdo', 'Ambidiestro'],
                              _lateralidad,
                              (String? value) {
                                setState(() {
                                  _lateralidad = value;
                                  _selectedHistoria!['lateralidad'] = value;
                                });
                              },
                            ),
                          
                           
                            Divider(),
                            SizedBox(height: 10),
                            _buildSection('2.- Independencia y autonomía'),

                             _buildRadioButtonGroup(
                             '¿Se alimenta solo(a) o necesita ayuda?',
                             ['solo', 'con ayuda parcial', 'con ayuda total'],
                              _IA1,
                              (String? value) {
                                setState(() {
                                  _IA1 = value;
                                  _selectedHistoria!['IA1'] = value;
                                });
                              },
                            ),

                             _buildRadioButtonGroup(
                             '¿Qué tipo de ayuda necesita?',
              [
                'Para identificar qué está comiendo',
                'Para llevar el alimento a la boca/evitar derrames',
                'Ninguna'
              ],
                              _IA2,
                              (String? value) {
                                setState(() {
                                  _IA2 = value;
                                  _selectedHistoria!['IA2'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                             '¿Prepara sus propios alimentos o para alguine más?',
              ['SI', 'NO'],
                              _IA3,
                              (String? value) {
                                setState(() {
                                  _IA3 = value;
                                  _selectedHistoria!['IA3'] = value;
                                });
                              },
                            ),

                            _buildTextField('¿Por qué?', 'IA3porque'),

                            _buildRadioButtonGroup(
                             '¿Decide qué alimentos desea consumir o participar activamente en estas decisiones en el hogar?',
              ['SI', 'NO'],
                              _IA4,
                              (String? value) {
                                setState(() {
                                  _IA4 = value;
                                  _selectedHistoria!['IA4'] = value;
                                });
                              },
                            ),


                            Divider(),
                            SizedBox(height: 10),
                            _buildSection('3.- Eficiencia'),

                            _buildRadioButtonGroup(
                             '¿Consume la totalidad del alimento que se le sirve?',
              ['SI', 'NO'],
                              _EF1,
                              (String? value) {
                                setState(() {
                                  _EF1 = value;
                                  _selectedHistoria!['EF1'] = value;
                                });
                              },
                            ),

                            _buildTextField('¿Qué porción consume?', 'EF1text'),

                            _buildRadioButtonGroup(
                             '¿Ha presentado pérdidas importantes de peso en el último tiempo?',
              ['SI', 'NO'],
                              _EF2,
                              (String? value) {
                                setState(() {
                                  _EF2 = value;
                                  _selectedHistoria!['EF2'] = value;
                                });
                              },
                            ),

                            _buildTextField('¿Cuántos kilos?', 'EF2text'),

                            _buildRadioButtonGroup(
                             '¿Manifiesta interés por alimentarse?',
              ['SI', 'NO'],
                              _EF3,
                              (String? value) {
                                setState(() {
                                  _EF3 = value;
                                  _selectedHistoria!['EF3'] = value;
                                });
                              },
                            ),
                            _buildRadioButtonGroup(
                             '¿Manifiesta rechazo o preferencias por algún tipo de alimento?',
              ['SI', 'NO'],
                              _EF4,
                              (String? value) {
                                setState(() {
                                  _EF4 = value;
                                  _selectedHistoria!['EF4'] = value;
                                });
                              },
                            ),
                            _buildTextField('¿Cuál?', 'EF3text'),

                            _buildTextField('¿Que tipo de liquido consume habitualmente?', 'EF4text'),
                            _buildTextField('¿Cuánto líquido consume habitualmente?', 'EF5text'),


                            Divider(),
                            SizedBox(height: 10),
                            _buildSection('4.- Seguridad'),
                            _buildRadioButtonGroup(
                             '¿Se atora con su saliva?',
              ['SI', 'NO'],
                              _S1,
                              (String? value) {
                                setState(() {
                                  _S1 = value;
                                  _selectedHistoria!['S1'] = value;
                                });
                              },
                            ),
                            _buildTextField('¿Con qué frecuencia?', 'Stext1'),
                            _buildRadioButtonGroup(
                             '¿Tiene tos o ahogos cuando se alimenta o consume sus medicamentos?',
              ['SI', 'NO'],
                              _S2,
                              (String? value) {
                                setState(() {
                                  _S2 = value;
                                  _selectedHistoria!['S2'] = value;
                                });
                              },
                            ),
                             _buildTextField('¿Con qué alimentos/líquidos/medicamentos?', 'Stext2'),

                               _buildRadioButtonGroup(
                             '¿Presenta alguna dificultad para tomar líquidos de un vaso?',
              ['SI', 'NO'],
                              _S3,
                              (String? value) {
                                setState(() {
                                  _S3 = value;
                                  _selectedHistoria!['S3'] = value;
                                });
                              },
                            ),

                             _buildRadioButtonGroup(
                             '¿Presenta dificultad con las sopas o los granos pequeños como el arroz?',
              ['SI', 'NO'],
                              _S4,
                              (String? value) {
                                setState(() {
                                  _S4 = value;
                                  _selectedHistoria!['S4'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                             '¿Ha presentado neumonías?',
              ['SI', 'NO'],
                              _S5,
                              (String? value) {
                                setState(() {
                                  _S5 = value;
                                  _selectedHistoria!['S5'] = value;
                                });
                              },
                            ),

                            _buildTextField('¿Con qué frecuencia?', 'Stext3'),


                            _buildRadioButtonGroup(
                            '¿Se queda con restos de alimento en la boca luego de alimentarse?',
              ['SI', 'NO'],
                              _S6,
                              (String? value) {
                                setState(() {
                                  _S6 = value;
                                  _selectedHistoria!['S6'] = value;
                                });
                              },
                            ),


                            _buildRadioButtonGroup(
                            '¿Siente que el alimento se va hacia su nariz?',
              ['SI', 'NO'],
                              _S7,
                              (String? value) {
                                setState(() {
                                  _S7 = value;
                                  _selectedHistoria!['S7'] = value;
                                });
                              },
                            ),


                            Divider(),
                            SizedBox(height: 10),
                            _buildSection('5.- Proceso de alimentación'),

                            _buildRadioButtonGroup(
                            '¿Se demora más tiempo que el resto de la familia?',
              ['SI', 'NO'],
                              _PA1,
                              (String? value) {
                                setState(() {
                                  _PA1 = value;
                                  _selectedHistoria!['PA1'] = value;
                                });
                              },
                            ),

                            _buildTextField('¿Cuánto?', 'PAtext1'),


                            _buildRadioButtonGroup(
                            '¿Cree usted que come muy rápido?',
              ['SI', 'NO'],
                              _PA2,
                              (String? value) {
                                setState(() {
                                  _PA2 = value;
                                  _selectedHistoria!['PA2'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                             '¿Suele realizar alguna otra actividad mientras come?',
              ['SI', 'NO'],
                              _PA3,
                              (String? value) {
                                setState(() {
                                  _PA3 = value;
                                  _selectedHistoria!['PA3'] = value;
                                });
                              },
                            ),

                            _buildTextField('¿Cuál(es)?', 'PAtext2'),

                            Divider(),
                            SizedBox(height: 10),
                            _buildSection('6.- Salud Bocal'),

                               _buildRadioButtonGroup(
                              '¿Cuenta con todas sus piezas dentarias/dientes?',
              ['SI', 'NO'],
                              _SB1,
                              (String? value) {
                                setState(() {
                                  _SB1 = value;
                                  _selectedHistoria!['SB1'] = value;
                                });
                              },
                            ),

                            _buildTextField('¿Por qué?', 'SBtext1'),

                             _buildRadioButtonGroup(
                               '¿Utiliza placa dental?',
              ['SI', 'NO'],
                              _SB2,
                              (String? value) {
                                setState(() {
                                  _SB2 = value;
                                  _selectedHistoria!['SB2'] = value;
                                });
                              },
                            ),

                             _buildRadioButtonGroup(
                                '¿Se realiza aseo bucal después de cada comida?',
              ['SI', 'NO'],
                              _SB3,
                              (String? value) {
                                setState(() {
                                  _SB3 = value;
                                  _selectedHistoria!['SB3'] = value;
                                });
                              },
                            ),

                             _buildTextField('¿Con qué frecuencia se lava los dientes/lava su prótesis?', 'SBtext2'),

                             _buildRadioButtonGroup(
                                '¿Asiste regularmente a controles dentales?',
              ['SI', 'NO'],
                              _SB4,
                              (String? value) {
                                setState(() {
                                  _SB4 = value;
                                  _selectedHistoria!['SB4'] = value;
                                });
                              },
                            ),

                             _buildTextField('¿Con qué frecuencia?', 'SBtext3'),

                             _buildRadioButtonGroup(
                                '¿Tiene alguna molestia o dolor dentro de su boca (dientes, encías, paladar, lengua)?',
              ['SI', 'NO'],
                              _SB5,
                              (String? value) {
                                setState(() {
                                  _SB5 = value;
                                  _selectedHistoria!['SB5'] = value;
                                });
                              },
                            ),

                             _buildTextField('¿Cuál?', 'SBtext4'),                            

                            SizedBox(height: 20),
                          ],
                        ),
                      )
                    : Text('No se encontraron historias clínicas'),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String key, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Fondo completamente blanco sin opacidad
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Desplazamiento de la sombra
            ),
          ],
        ),
        child: TextField(
          controller: TextEditingController(
            text: (_selectedHistoria?[key] ?? '')
                .toString(), // Conversión a string
          ),
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          onChanged: (value) {
            setState(() {
              _selectedHistoria![key] =
                  isNumeric ? int.tryParse(value) : value; // Conversión inversa
            });
          },
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.grey[800], // Color de la etiqueta más oscuro
            ),
            border: OutlineInputBorder(),
          ),
          enabled: _isEditing, // Control de edición (bloqueado o no)
          style: TextStyle(
            color: Colors.black, // Asegura que el texto se vea claramente
          ),
        ),
      ),
    );
  }


  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}