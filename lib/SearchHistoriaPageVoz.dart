import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchHistoriaPageVoz extends StatefulWidget {
  @override
  _SearchHistoriaPageVozState createState() => _SearchHistoriaPageVozState();
}

class _SearchHistoriaPageVozState extends State<SearchHistoriaPageVoz> {
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
 
  String? _EstadoCivilSelecciondo;
  String? _fonastenia;
  String? _fonalgia;
  String? _tensFonacion;
  String? _sensaCuello;
  String? _sensaCuerpExtra;
  String? _descarPost;
  String? _odinofagia;
  String? _extenReduci;
  String? _picoLaring;

  String? _preAlguEnfer;
  String? _sufreEstres;
  String? _ATerap1;
  String? _ATerap2;
  String? _ATerap3;
  String? _ATerap4;
  String? _ATerap5;
  String? _AbuVocal1;
  String? _AbuVocal2;
  String? _AbuVocal3;
  String? _AbuVocal4;
  String? _AbuVocal5;
  String? _AbuVocal6;
  String? _AbuVocal7;
  String? _AbuVocal8;
  String? _AbuVocal9;
  String? _AbuVocal10;
  String? _AbuVocal11;
  String? _MalVocal1;
  String? _MalVocal2;
  String? _MalVocal3;
  String? _MalVocal4;
  String? _FactExter1;
  String? _FactExter2;
  String? _FactExter3;
  String? _FactExter4;
  String? _FactExter5;

  String? _repoVocal;
  String? _sinBeberLiqui;
  String? _otorrino;
  String? _alimenCondi;
  String? _alimenCalienoFrio;
  String? _bebiAlcohol;
  String? _fuma;
  String? _cafe;
  String? _drogas;
  String? _ropaAjust;

  Future<void> _searchHistorias() async {
    setState(() {
      _isLoading = true;
      _isEditing = false;
    });

    try {
      // Realiza la búsqueda en Firestore por nombre
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('HistoriaAnamVoz')
          .where('nombre', isEqualTo: _searchController.text)
          .get();

      setState(() {
        _results = querySnapshot.docs;
        _isLoading = false;

        if (_results.isNotEmpty) {
          _selectedHistoria = _results[0].data() as Map<String, dynamic>;

          // Asegurarse de que el campo 'sexo' existe en la historia seleccionada
          _EstadoCivilSelecciondo = _selectedHistoria?['estCivil'] ?? '';
          _fonastenia = _selectedHistoria?['fonastenia'] ?? '';
          _fonalgia = _selectedHistoria?['fonalgia'] ?? '';
          _tensFonacion = _selectedHistoria?['tensFonacion'] ?? '';
          _sensaCuello = _selectedHistoria?['sensaCuello'] ?? '';
          _sensaCuerpExtra = _selectedHistoria?['sensaCuerpExtra'] ?? '';
          _descarPost = _selectedHistoria?['descarPost'] ?? '';
          _odinofagia = _selectedHistoria?['odinofagia'] ?? '';
          _extenReduci = _selectedHistoria?['extenReduci'] ?? '';
          _picoLaring = _selectedHistoria?['picoLaring'] ?? '';

          _preAlguEnfer = _selectedHistoria?['preAlguEnfer'] ?? '';
          _sufreEstres = _selectedHistoria?['sufreEstres'] ?? '';

          _ATerap1 = _selectedHistoria?['ATerap1'] ?? '';
          _ATerap2 = _selectedHistoria?['ATerap2'] ?? '';
          _ATerap3 = _selectedHistoria?['ATerap3'] ?? '';
          _ATerap4 = _selectedHistoria?['ATerap4'] ?? '';
          _ATerap5 = _selectedHistoria?['ATerap5'] ?? '';

          _AbuVocal1 = _selectedHistoria?['AbuVocal1'] ?? '';
          _AbuVocal2 = _selectedHistoria?['AbuVocal2'] ?? '';
          _AbuVocal3 = _selectedHistoria?['AbuVocal3'] ?? '';
          _AbuVocal4 = _selectedHistoria?['AbuVocal4'] ?? '';
          _AbuVocal5 = _selectedHistoria?['AbuVocal5'] ?? '';
          _AbuVocal6 = _selectedHistoria?['AbuVocal6'] ?? '';
          _AbuVocal7 = _selectedHistoria?['AbuVocal7'] ?? '';
          _AbuVocal8 = _selectedHistoria?['AbuVocal8'] ?? '';
          _AbuVocal9 = _selectedHistoria?['AbuVocal9'] ?? '';
          _AbuVocal10 = _selectedHistoria?['AbuVocal10'] ?? '';
          _AbuVocal11 = _selectedHistoria?['AbuVocal11'] ?? '';

          _MalVocal1 = _selectedHistoria?['MalVocal1'] ?? '';
          _MalVocal2 = _selectedHistoria?['MalVocal2'] ?? '';
          _MalVocal3 = _selectedHistoria?['MalVocal3'] ?? '';
          _MalVocal4 = _selectedHistoria?['MalVocal4'] ?? '';

          _FactExter1 = _selectedHistoria?['FactExter1'] ?? '';
          _FactExter2 = _selectedHistoria?['FactExter2'] ?? '';
          _FactExter3 = _selectedHistoria?['FactExter3'] ?? '';
          _FactExter4 = _selectedHistoria?['FactExter4'] ?? '';
          _FactExter5 = _selectedHistoria?['FactExter5'] ?? '';

          _repoVocal = _selectedHistoria?['repoVocal'] ?? '';
          _sinBeberLiqui = _selectedHistoria?['sinBeberLiqui'] ?? '';
          _otorrino = _selectedHistoria?['otorrino'] ?? '';
          _alimenCondi = _selectedHistoria?['alimenCondi'] ?? '';
          _alimenCalienoFrio = _selectedHistoria?['alimenCalienoFrio'] ?? '';
          _bebiAlcohol = _selectedHistoria?['bebiAlcohol'] ?? '';
          _fuma = _selectedHistoria?['fuma'] ?? '';
          _cafe = _selectedHistoria?['cafe'] ?? '';
          _drogas = _selectedHistoria?['drogas'] ?? '';
          _ropaAjust = _selectedHistoria?['ropaAjust'] ?? '';

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
            .collection('HistoriaAnamVoz')
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
        title: Text('Buscar - Anamesis de Voz '),
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
                            _buildSection('1.- Datos de identificación'),
                            _buildTextField(
                                'Nombre completo del paciente', 'nombre'),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                      'Fecha de Nacimiento', 'fechaNacimiento'),
                                ),
                                SizedBox(width: 16.0),
                                Expanded(
                                  child: _buildTextField('Edad', 'edad',
                                      isNumeric: true),
                                ),
                              ],
                            ),

                            Divider(),
                            _buildRadioButtonGroup(
                              'Estado civil',
                              ['Soltero', 'Casado', 'Otro'],
                              _EstadoCivilSelecciondo,
                              (String? value) {
                                setState(() {
                                  _EstadoCivilSelecciondo = value;
                                  _selectedHistoria!['estCivil'] = value;
                                });
                              },
                            ),
                            Divider(),

                            _buildTextField('Ocupación actual', 'ocupacion'),
                            _buildTextField('Dirección', 'direccion'),
                            _buildTextField('Derivado por', 'derivadoPor'),
                            _buildTextFielMaxLine(
                                'Razón derivación', 'razonDeriva'),
                            _buildTextFielMaxLine(
                                'Diagnostico ORL', 'diagnosORL'),
                            _buildTextField('Teléfono', 'telefono'),
                            _buildTextField(
                                'Fecha de entrevista', 'fechaEntrevista'),
                            Divider(),
                            SizedBox(height: 10),
                            _buildSection('2.- Historia clínica'),
                            _buildTextFielMaxLine(
                                'Motivo de consulta', 'HCmotivoConsul'),

                            _buildTextFielMaxLine(
                                '¿Es la primera vez que tiene esta dificultad?',
                                'HCpregu1'),
                            _buildTextFielMaxLine(
                                '¿Cuándo comenzó el problema?', 'HCpregu2'),
                            _buildTextFielMaxLine(
                                'Forma de inicio', 'HCformInicio'),
                            _buildTextFielMaxLine(
                                '¿A qué lo atribuye?', 'HCpregu3'),
                            _buildTextFielMaxLine(
                                '¿Cómo lo afecta?', 'HCpregu4'),
                            _buildTextFielMaxLine(
                                '¿Cuándo se agrava?', 'HCpregu5'),
                            _buildTextFielMaxLine(
                                '¿Como ha sido su evolución?', 'HCpregu6'),
                            _buildTextFielMaxLine(
                                'Momento del dia con mayor dificultad',
                                'HCmomento'),
                            _buildTextFielMaxLine(
                                '¿En qué situaciones aparecen molestias?',
                                'HCsituaMoles'),

                            Divider(),
                            SizedBox(height: 10),
                            _buildSection('3.- Sintomatología'),

                            // Definimos los grupos de opciones para cada variable
                            _buildRadioButtonGroup(
                              'Fonastenia',
                              ['SI', 'NO', 'Leve', 'Moderado', 'Severo'],
                              _fonastenia,
                              (String? value) {
                                setState(() {
                                  _fonastenia = value;
                                  _selectedHistoria!['fonastenia'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Fonalgia (dolor al hablar',
                              ['SI', 'NO', 'Leve', 'Moderado', 'Severo'],
                              _fonalgia,
                              (String? value) {
                                setState(() {
                                  _fonalgia = value;
                                  _selectedHistoria!['fonalgia'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Tensión en la Fonación',
                              ['SI', 'NO'],
                              _tensFonacion,
                              (String? value) {
                                setState(() {
                                  _tensFonacion = value;
                                  _selectedHistoria!['tensFonacion'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Sensación de cuello extraño',
                              ['SI', 'NO'],
                              _sensaCuello,
                              (String? value) {
                                setState(() {
                                  _sensaCuello = value;
                                  _selectedHistoria!['sensaCuello'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Sensación de cuerpo extrano',
                              ['SI', 'NO'],
                              _sensaCuerpExtra,
                              (String? value) {
                                setState(() {
                                  _sensaCuerpExtra = value;
                                  _selectedHistoria!['sensaCuerpExtra'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Descarga Posterior',
                              ['SI', 'NO'],
                              _descarPost,
                              (String? value) {
                                setState(() {
                                  _descarPost = value;
                                  _selectedHistoria!['descarPost'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Odinofagia',
                              ['SI', 'NO'],
                              _odinofagia,
                              (String? value) {
                                setState(() {
                                  _odinofagia = value;
                                  _selectedHistoria!['odinofagia'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Extensión total reducida',
                              ['SI', 'NO'],
                              _extenReduci,
                              (String? value) {
                                setState(() {
                                  _extenReduci = value;
                                  _selectedHistoria!['extenReduci'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Picor Laríngeo',
                              ['SI', 'NO'],
                              _picoLaring,
                              (String? value) {
                                setState(() {
                                  _picoLaring = value;
                                  _selectedHistoria!['picoLaring'] = value;
                                });
                              },
                            ),

                            Divider(),
                            SizedBox(height: 10),
                            _buildSection('4.- Antecedentes mórbidos'),
                            Text("     En relación a ciertas enfermedades:"),
                            SizedBox(height: 10),
                            _buildTextFielMaxLine(
                                'Existen problemas de voz en su familia ¿Cuáles?',
                                'AMexiProblem'),

                            _buildRadioButtonGroup(
                              '¿Presenta alguna enfermedad?',
                              [
                                'Respiratoria',
                                'Auditiva',
                                'Digestiva',
                                'Psicológica'
                              ],
                              _preAlguEnfer,
                              (String? value) {
                                setState(() {
                                  _preAlguEnfer = value;
                                  _selectedHistoria!['preAlguEnfer'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              '¿Sufre de estrés?',
                              ['SI', 'NO'],
                              _sufreEstres,
                              (String? value) {
                                setState(() {
                                  _sufreEstres = value;
                                  _selectedHistoria!['sufreEstres'] = value;
                                });
                              },
                            ),

                            _buildTextFielMaxLine(
                                '¿Las emociones dañan su voz?', 'emoDananVoz'),
                            _buildTextFielMaxLine(
                                '¿Utiliza algún medicamento? ¿Cuáles?',
                                'utiliMedicCual'),
                            _buildTextFielMaxLine(
                                '¿Ha sufrido accidentes, enfermedades graves, hospitalizaciones, etc?',
                                'sufriAccident'),
                            _buildTextFielMaxLine(
                                '¿Ha sido intervenido quirúrgicamente?¿Por qué?',
                                'interQuirur'),
                            _buildTextFielMaxLine(
                                '¿Ha sido intubado?¿Por cuánto tiempo?',
                                'intubado'),
                            _buildTextFielMaxLine(
                                '¿Ha consultado con otros profesionales?',
                                'consulProfe'),

                            Divider(),
                            SizedBox(height: 10),
                            _buildSection('5.- Antecedentes terapéuticos'),

                            _buildRadioButtonGroup(
                              '¿Ha recibido tratamiento médico por problemas de la voz?',
                              ['SI', 'NO'],
                              _ATerap1,
                              (String? value) {
                                setState(() {
                                  _ATerap1 = value;
                                  _selectedHistoria!['ATerap1'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              '¿Se ha realizado exámenes?',
                              ['SI', 'NO'],
                              _ATerap2,
                              (String? value) {
                                setState(() {
                                  _ATerap2 = value;
                                  _selectedHistoria!['ATerap2'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              '¿Ha recibido tratamiento fonoaudiológico por problemas de voz?',
                              ['SI', 'NO'],
                              _ATerap3,
                              (String? value) {
                                setState(() {
                                  _ATerap3 = value;
                                  _selectedHistoria!['ATerap3'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              '¿Ha recibido técnica vocal?',
                              ['SI', 'NO'],
                              _ATerap4,
                              (String? value) {
                                setState(() {
                                  _ATerap4 = value;
                                  _selectedHistoria!['ATerap4'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Aplica la técnica vocal:',
                              ['SI', 'NO'],
                              _ATerap5,
                              (String? value) {
                                setState(() {
                                  _ATerap5 = value;
                                  _selectedHistoria!['ATerap5'] = value;
                                });
                              },
                            ),

                            Divider(),
                            SizedBox(height: 10),
                            _buildSection('6.- Abuso vocal'),

                            _buildRadioButtonGroup(
                              'Tose en exceso',
                              ['SI', 'NO'],
                              _AbuVocal1,
                              (String? value) {
                                setState(() {
                                  _AbuVocal1 = value;
                                  _selectedHistoria!['AbuVocal1'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Grita en exceso',
                              ['SI', 'NO'],
                              _AbuVocal2,
                              (String? value) {
                                setState(() {
                                  _AbuVocal2 = value;
                                  _selectedHistoria!['AbuVocal2'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Habla mucho',
                              ['SI', 'NO'],
                              _AbuVocal3,
                              (String? value) {
                                setState(() {
                                  _AbuVocal3 = value;
                                  _selectedHistoria!['AbuVocal3'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Habla rápido',
                              ['SI', 'NO'],
                              _AbuVocal4,
                              (String? value) {
                                setState(() {
                                  _AbuVocal4 = value;
                                  _selectedHistoria!['AbuVocal4'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Imita voces',
                              ['SI', 'NO'],
                              _AbuVocal5,
                              (String? value) {
                                setState(() {
                                  _AbuVocal5 = value;
                                  _selectedHistoria!['AbuVocal5'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Habla con exceso de ruido',
                              ['SI', 'NO'],
                              _AbuVocal6,
                              (String? value) {
                                setState(() {
                                  _AbuVocal6 = value;
                                  _selectedHistoria!['AbuVocal6'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              '¿Reduce el uso de la voz en resfríos?',
                              ['SI', 'NO'],
                              _AbuVocal7,
                              (String? value) {
                                setState(() {
                                  _AbuVocal7 = value;
                                  _selectedHistoria!['AbuVocal7'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Carraspea en exceso',
                              ['SI', 'NO'],
                              _AbuVocal8,
                              (String? value) {
                                setState(() {
                                  _AbuVocal8 = value;
                                  _selectedHistoria!['AbuVocal8'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              '¿Habla forzando la voz?',
                              ['SI', 'NO'],
                              _AbuVocal9,
                              (String? value) {
                                setState(() {
                                  _AbuVocal9 = value;
                                  _selectedHistoria!['AbuVocal9'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              '¿Habla al mismo tiempo que otras personas?',
                              ['SI', 'NO'],
                              _AbuVocal10,
                              (String? value) {
                                setState(() {
                                  _AbuVocal10 = value;
                                  _selectedHistoria!['AbuVocal10'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              '¿Habla con dientes, hombro y cuello apretado?',
                              ['SI', 'NO'],
                              _AbuVocal11,
                              (String? value) {
                                setState(() {
                                  _AbuVocal11 = value;
                                  _selectedHistoria!['AbuVocal11'] = value;
                                });
                              },
                            ),

                            Divider(),
                            SizedBox(height: 10),
                            _buildSection('7.- Mal uso vocal'),

                            _buildRadioButtonGroup(
                              'Trata de hablar con un tono más agudo o grave que el suyo',
                              ['SI', 'NO'],
                              _MalVocal1,
                              (String? value) {
                                setState(() {
                                  _MalVocal1 = value;
                                  _selectedHistoria!['MalVocal1'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Trata de hablar con un volumen de voz más débil o alto de lo usual',
                              ['SI', 'NO'],
                              _MalVocal2,
                              (String? value) {
                                setState(() {
                                  _MalVocal2 = value;
                                  _selectedHistoria!['MalVocal2'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Canta fuera de registro',
                              ['SI', 'NO'],
                              _MalVocal3,
                              (String? value) {
                                setState(() {
                                  _MalVocal3 = value;
                                  _selectedHistoria!['MalVocal3'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Canta sin vocalizar',
                              ['SI', 'NO'],
                              _MalVocal4,
                              (String? value) {
                                setState(() {
                                  _MalVocal4 = value;
                                  _selectedHistoria!['MalVocal4'] = value;
                                });
                              },
                            ),

                            Divider(),
                            SizedBox(height: 10),
                            _buildSection('8.- Factores externos'),

                            _buildRadioButtonGroup(
                              'Vive en ambiente de fumadores',
                              ['SI', 'NO'],
                              _FactExter1,
                              (String? value) {
                                setState(() {
                                  _FactExter1 = value;
                                  _selectedHistoria!['FactExter1'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Trabaja en un ambiente ruidoso',
                              ['SI', 'NO'],
                              _FactExter2,
                              (String? value) {
                                setState(() {
                                  _FactExter2 = value;
                                  _selectedHistoria!['FactExter2'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Permanece en ambiente con aire acondicionado',
                              ['SI', 'NO'],
                              _FactExter3,
                              (String? value) {
                                setState(() {
                                  _FactExter3 = value;
                                  _selectedHistoria!['FactExter3'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Permanece en ambientes con poca ventilación',
                              ['SI', 'NO'],
                              _FactExter4,
                              (String? value) {
                                setState(() {
                                  _FactExter4 = value;
                                  _selectedHistoria!['FactExter4'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Se expone a cambios bruscos de temperatura',
                              ['SI', 'NO'],
                              _FactExter5,
                              (String? value) {
                                setState(() {
                                  _FactExter5 = value;
                                  _selectedHistoria!['FactExter5'] = value;
                                });
                              },
                            ),

                            Divider(),
                            SizedBox(height: 10),
                            _buildSection('9.- Hábitos generales'),

                            _buildRadioButtonGroup(
                              'Realiza reposo vocal',
                              ['SI', 'NO'],
                              _repoVocal,
                              (String? value) {
                                setState(() {
                                  _repoVocal = value;
                                  _selectedHistoria!['repoVocal'] = value;
                                });
                              },
                            ),
                            _buildTextField('¿cuanto tiempo?', 'repoVocaltext'),
                            _buildRadioButtonGroup(
                              'Habla durante mucho tiempo sin beber líquido',
                              ['SI', 'NO'],
                              _sinBeberLiqui,
                              (String? value) {
                                setState(() {
                                  _sinBeberLiqui = value;
                                  _selectedHistoria!['sinBeberLiqui'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              '¿Asiste al otorrinolaringólogo?',
                              ['SI', 'NO'],
                              _otorrino,
                              (String? value) {
                                setState(() {
                                  _otorrino = value;
                                  _selectedHistoria!['otorrino'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Consume alimentos muy condimentados',
                              ['SI', 'NO'],
                              _alimenCondi,
                              (String? value) {
                                setState(() {
                                  _alimenCondi = value;
                                  _selectedHistoria!['alimenCondi'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Consume alimentos muy calientes o muy fríos',
                              ['SI', 'NO'],
                              _alimenCalienoFrio,
                              (String? value) {
                                setState(() {
                                  _alimenCalienoFrio = value;
                                  _selectedHistoria!['alimenCalienoFrio'] =
                                      value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Consume bebidas alcohólicas',
                              ['SI', 'NO'],
                              _bebiAlcohol,
                              (String? value) {
                                setState(() {
                                  _bebiAlcohol = value;
                                  _selectedHistoria!['bebiAlcohol'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Fuma',
                              ['SI', 'NO'],
                              _fuma,
                              (String? value) {
                                setState(() {
                                  _fuma = value;
                                  _selectedHistoria!['fuma'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Consume café',
                              ['SI', 'NO'],
                              _cafe,
                              (String? value) {
                                setState(() {
                                  _cafe = value;
                                  _selectedHistoria!['cafe'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Consume drogas',
                              ['SI', 'NO'],
                              _drogas,
                              (String? value) {
                                setState(() {
                                  _drogas = value;
                                  _selectedHistoria!['drogas'] = value;
                                });
                              },
                            ),

                            _buildRadioButtonGroup(
                              'Utiliza ropa ajustada',
                              ['SI', 'NO'],
                              _ropaAjust,
                              (String? value) {
                                setState(() {
                                  _ropaAjust = value;
                                  _selectedHistoria!['ropaAjust'] = value;
                                });
                              },
                            ),

                            _buildTextField(
                                '¿Cuántas horas duerme?', 'cuantasHorasDuerme'),

                            Divider(),
                            SizedBox(height: 10),
                            _buildSection(
                                '10.- Uso laboral y profesional de la voz'),

                            _buildTextFielMaxLine(
                                '¿Cuántas horas trabaja?', 'horasTrabaj'),
                            _buildTextFielMaxLine(
                                '¿Cuál es su postura para trabajar?',
                                'postuTrabajar'),
                            _buildTextFielMaxLine(
                                '¿Utiliza su voz de forma prolongada durante la jornada laboral?',
                                'vozProlongada'),
                            _buildTextFielMaxLine(
                                '¿Realiza reposo vocal durante su jornada laboral?',
                                'repoVocalTrabaj'),
                            _buildTextFielMaxLine(
                                '¿Ingiere líquidos durante su trabajo?',
                                'liquitoTrabaj'),
                            _buildTextFielMaxLine(
                                'En caso de cantantes ¿Utiliza amplificación para cantar?',
                                'amplifi'),
                            _buildTextFielMaxLine(
                                '¿Asiste a clases con profesionales de la voz?',
                                'profeVocal'),

                            Divider(),
                            SizedBox(height: 10),
                            _buildTextFielMaxLine('Observaciones', 'observa'),

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

  Widget _buildTextFielMaxLine(String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Scrollbar(
              child: SingleChildScrollView(
                child: TextField(
                  controller: TextEditingController(
                    text: (_selectedHistoria?[key] ?? '').toString(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedHistoria![key] = value;
                    });
                  },
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  enabled: _isEditing,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
              ),
            ),
          ),
        ],
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