import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Para manejar la selección de fechas
import 'SearchHistoriaPageVoz.dart';

class HistoriaT2 extends StatefulWidget {
  @override
  _HistoriaT2State createState() => _HistoriaT2State();
}

class _HistoriaT2State extends State<HistoriaT2> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};  

  final List<Map<String, dynamic>> _formFields = [
    {'name': 'nombre', 'label': 'Nombre completo'},
    {'name': 'ocupacion', 'label': 'Ocupación actual'},
    {'name': 'direccion', 'label': 'Dirección'},
    {'name': 'derivadoPor', 'label': 'Derivado por'},
    {'name': 'razonDeriva', 'label': 'Razón de la derivación', 'multiline': true},
    {'name': 'diagnosORL', 'label': 'Diagnostico ORL', 'multiline': true},
    {'name': 'telefono', 'label': 'Teléfono de contacto'},
    //seccion de preguntas 2.Historiaclinica
    {'name': 'HCmotivoConsul', 'label': 'Motivo de consulta', 'multiline': true},
    {'name': 'HCpregu1', 'label': '¿Es la primera vez que tiene esta dificultad?', 'multiline': true},
    {'name': 'HCpregu2', 'label': '¿Cuándo comenzó el problema?', 'multiline': true},
    {'name': 'HCformInicio', 'label': 'Forma de inicio', 'multiline': true},
    {'name': 'HCpregu3', 'label': '¿A qué lo atribuye?', 'multiline': true},
    {'name': 'HCpregu4', 'label': '¿Cómo lo afecta?', 'multiline': true},
    {'name': 'HCpregu5', 'label': '¿Cuándo se agrava?', 'multiline': true},
    {'name': 'HCpregu6', 'label': '¿Como ha sido su evolución?', 'multiline': true},
    {'name': 'HCmomento', 'label': 'Momento del dia con mayor dificultad', 'multiline': true},
    {'name': 'HCsituaMoles', 'label': '¿En qué situaciones aparecen molestias?', 'multiline': true},

    //Antecedentes morbidos
     {'name': 'AMexiProblem', 'label': 'Existen problemas de voz en su familia ¿Cuáles?', 'multiline': true},
     {'name': 'emoDananVoz', 'label': '¿Las emociones dañan su voz?', 'multiline': true},
     {'name': 'utiliMedicCual', 'label': '¿Utiliza algún medicamento? ¿Cuáles?', 'multiline': true},
     {'name': 'sufriAccident', 'label': '¿Ha sufrido accidentes, enfermedades graves, hospitalizaciones, etc?', 'multiline': true},
     {'name': 'interQuirur', 'label': '¿Ha sido intervenido quirúrgicamente?¿Por qué?', 'multiline': true},
     {'name': 'intubado', 'label': '¿Ha sido intubado?¿Por cuánto tiempo?', 'multiline': true},
     {'name': 'consulProfe', 'label': '¿Ha consultado con otros profesionales?', 'multiline': true},
     {'name': 'repoVocaltext', 'label': '¿cuanto tiempo?'},
     {'name': 'cuantasHorasDuerme', 'label': '¿Cuántas horas duerme?'},

     {'name': 'horasTrabaj', 'label': '¿Cuántas horas trabaja?', 'multiline': true},
     {'name': 'postuTrabajar', 'label': '¿Cuál es su postura para trabajar?', 'multiline': true},
     {'name': 'vozProlongada', 'label': '¿Utiliza su voz de forma prolongada durante la jornada laboral?', 'multiline': true},
     {'name': 'repoVocalTrabaj', 'label': '¿Realiza reposo vocal durante su jornada laboral?', 'multiline': true},
     {'name': 'liquitoTrabaj', 'label': '¿Ingiere líquidos durante su trabajo?', 'multiline': true},
     {'name': 'amplifi', 'label': '¿Utiliza amplificación para cantar?', 'multiline': true},
     {'name': 'profeVocal', 'label': '¿Asiste a clases con profesionales de la voz?', 'multiline': true},


     {'name': 'observa', 'label': 'Observaciones........', 'multiline': true},   
   
   
    
  ];

  DateTime? _fechaEntrevista;
  DateTime? _fechaNacimiento;
  int _edad = 0;
  String? _EstadoCivilSeleccionado;
  String?  _fonastenia;
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
 
  

  @override
  void initState() {
    super.initState();
    for (var field in _formFields) {
      _controllers[field['name']] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        Map<String, dynamic> formData = {};

        // Agregar los otros campos del formulario
        for (var field in _formFields) {
          formData[field['name']] = _controllers[field['name']]!.text;
        }

        // Formatear fechas
        formData['fechaEntrevista'] = _fechaEntrevista != null
            ? DateFormat('dd/MM/yyyy').format(_fechaEntrevista!)
            : null;
        formData['fechaNacimiento'] = _fechaNacimiento != null
            ? DateFormat('dd/MM/yyyy').format(_fechaNacimiento!)
            : null;
        formData['edad'] = _edad;
        formData['estCivil'] = _EstadoCivilSeleccionado;

        formData['fonastenia'] = _fonastenia;
        formData['fonalgia'] = _fonalgia;
        formData['tensFonacion'] = _tensFonacion;
        formData['sensaCuello'] = _sensaCuello;
        formData['sensaCuerpExtra'] = _sensaCuerpExtra;
        formData['descarPost'] = _descarPost;
        formData['odinofagia'] = _odinofagia;
        formData['extenReduci'] = _extenReduci;
        formData['picoLaring'] = _picoLaring;

        formData['preAlguEnfer'] = _preAlguEnfer;
        formData['sufreEstres'] = _sufreEstres;

        formData['ATerap1'] = _ATerap1;
        formData['ATerap2'] = _ATerap2;
        formData['ATerap3'] = _ATerap3;
        formData['ATerap4'] = _ATerap4;
        formData['ATerap5'] = _ATerap5;

        formData['AbuVocal1'] = _AbuVocal1;
        formData['AbuVocal2'] = _AbuVocal2;
        formData['AbuVocal3'] = _AbuVocal3;
        formData['AbuVocal4'] = _AbuVocal4;
        formData['AbuVocal5'] = _AbuVocal5;
        formData['AbuVocal6'] = _AbuVocal6;
        formData['AbuVocal7'] = _AbuVocal7;
        formData['AbuVocal8'] = _AbuVocal8;
        formData['AbuVocal9'] = _AbuVocal9;
        formData['AbuVocal10'] = _AbuVocal10;
        formData['AbuVocal11'] = _AbuVocal11;

        formData['MalVocal1'] = _MalVocal1;
        formData['MalVocal2'] = _MalVocal2;
        formData['MalVocal3'] = _MalVocal3;
        formData['MalVocal4'] = _MalVocal4;


        formData['FactExter1'] = _FactExter1;
        formData['FactExter2'] = _FactExter2;
        formData['FactExter3'] = _FactExter3;
        formData['FactExter4'] = _FactExter4;
        formData['FactExter5'] = _FactExter5;

        formData['repoVocal'] = _repoVocal;
        formData['sinBeberLiqui'] = _sinBeberLiqui;
        formData['otorrino'] = _otorrino;
        formData['alimenCondi'] = _alimenCondi;
        formData['alimenCalienoFrio'] = _alimenCalienoFrio;
        formData['bebiAlcohol'] = _bebiAlcohol;
        formData['fuma'] = _fuma;
        formData['cafe'] = _cafe;
        formData['drogas'] = _drogas;
        formData['ropaAjust'] = _ropaAjust;    


        // Enviar a Firebase
        await FirebaseFirestore.instance
            .collection('HistoriaAnamVoz')
            .add(formData);

        _clearForm();

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos enviados correctamente')),
        );
      } catch (e) {
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar los datos: $e')),
        );
      }
    }
  }

  void _clearForm() {
    for (var controller in _controllers.values) {
      controller.clear();
    }

    // Limpiar las fechas y otras selecciones
    setState(() {
      _fechaEntrevista = null;
      _fechaNacimiento = null;
      _edad = 0;
      _EstadoCivilSeleccionado = null;

  _fonastenia = null;
 _fonalgia = null;
 _tensFonacion = null;
 _sensaCuello = null;
 _sensaCuerpExtra = null;
 _descarPost = null;
 _odinofagia = null;
 _extenReduci = null;
 _picoLaring = null;
 _preAlguEnfer = null;
 _sufreEstres = null;
 _ATerap1 = null;
 _ATerap2 = null;
 _ATerap3 = null;
 _ATerap4 = null;
 _ATerap5 = null;
 _AbuVocal1 = null;
 _AbuVocal2 = null;
 _AbuVocal3 = null;
 _AbuVocal4 = null;
 _AbuVocal5 = null;
 _AbuVocal6 = null;
 _AbuVocal7 = null;
 _AbuVocal8 = null;
 _AbuVocal9 = null;
 _AbuVocal10 = null;
 _AbuVocal11 = null;
 _MalVocal1 = null;
 _MalVocal2 = null;
 _MalVocal3 = null;
 _MalVocal4 = null;
 _FactExter1 = null;
 _FactExter2 = null;
 _FactExter3 = null;
 _FactExter4 = null;
 _FactExter5 = null;
 _repoVocal = null;
 _sinBeberLiqui = null;
 _otorrino = null;
 _alimenCondi;
 _alimenCalienoFrio = null;
 _bebiAlcohol = null;
 _fuma = null;
 _cafe = null;
_drogas = null;
_ropaAjust = null;
      
    });
  }

  Widget _buildFechaField(String label, DateTime? fechaSeleccionada,
      void Function(DateTime?) onFechaSeleccionada) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () async {
          DateTime? fecha = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (fecha != null) {
            onFechaSeleccionada(fecha);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Text(
            fechaSeleccionada != null
                ? DateFormat('dd/MM/yyyy').format(fechaSeleccionada)
                : 'Seleccione una fecha',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
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
            spacing: 0.0, // Espacio horizontal entre los botones
            runSpacing:
                4.0, // Espacio vertical si se envuelven en una nueva línea
            children: options.map((option) {
              return Row(
                mainAxisSize:
                    MainAxisSize.min, // Ajusta el tamaño del Row al contenido
                children: [
                  Radio<String>(
                    value: option,
                    groupValue: groupValue,
                    onChanged: onChanged,
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
        title: const Text('Historia Clínica - Terapia',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(224, 68, 137, 255),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            _buildHeader(),

            
            Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchHistoriaPageVoz()), // Navega a la página Histori
            );
          },
          child: Text('Pagina de busqueda'),
        ),
      ),



            _buildSection('1.- Datos de identificación'),
            _buildFormField(_formFields[0]), // Nombre completo
              Row(
              children: [
                Expanded(
                  child: _buildFechaField(
                      'Fecha de Nacimiento', _fechaNacimiento, (fecha) {
                    setState(() {
                      _fechaNacimiento = fecha;

                      // Calcular la edad solo si la fecha no es nula
                      if (_fechaNacimiento != null) {
                        _edad = DateTime.now().year - _fechaNacimiento!.year;

                        // Ajustar la edad si la fecha de nacimiento aún no ha ocurrido en este año
                        if (DateTime.now().month < _fechaNacimiento!.month ||
                            (DateTime.now().month == _fechaNacimiento!.month &&
                                DateTime.now().day < _fechaNacimiento!.day)) {
                          _edad--;
                        }
                      } else {
                        _edad = 0; // Restablecer a 0 si la fecha es nula
                      }
                    });
                  }),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      _edad.toString(),
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),

            Divider(),
             _buildRadioButtonGroup(
              'Estada civil',
              ['Soltero', 'Casado', 'Otro'],
              _EstadoCivilSeleccionado,
              (value) => setState(() => _EstadoCivilSeleccionado = value),
            ),
            Divider(),

            _buildFormField(_formFields[1]), // ocupacion
            _buildFormField(_formFields[2]), // direccion
            _buildFormField(_formFields[3]), // derivadoPor
            _buildFormField(_formFields[4]), // RazonDeriva
            _buildFormField(_formFields[5]), // diagnosORL
            _buildFormField(_formFields[6]), // telefono

            _buildFechaField('Fecha evaluación', _fechaEntrevista,
                (fecha) => setState(() => _fechaEntrevista = fecha)),
            
                         
            Divider(),
            _buildSection('2 .- Historia clínica'),
            
            _buildFormField(_formFields[7]), // motivo de consulta
            _buildFormField(_formFields[8]), // pre1
            _buildFormField(_formFields[9]), //pre2
            _buildFormField(_formFields[10]), //forma inicio
            _buildFormField(_formFields[11]),//pre3
            _buildFormField(_formFields[12]),//pre4
            _buildFormField(_formFields[13]),//pre5
            _buildFormField(_formFields[14]),//pre6
            _buildFormField(_formFields[15]),//moemnto del dia....
            _buildFormField(_formFields[16]),//pre7
            
            Divider(),
            _buildSection('3 .- Sintomatología'),
            
            _buildRadioButtonGroup(
              'Fonastenia',
              ['SI', 'NO', 'Leve', 'Moderado', 'Severo'],
              _fonastenia,
              (value) => setState(() => _fonastenia = value),
            ),
            
             _buildRadioButtonGroup(
              'Fonalgia (dolor al hablar)',
              ['SI', 'NO', 'Leve', 'Moderado', 'Severo'],
              _fonalgia,
              (value) => setState(() => _fonalgia = value),
            ),

             _buildRadioButtonGroup(
              'Tensión en fonación',
              ['SI', 'NO'],
              _tensFonacion,
              (value) => setState(() => _tensFonacion = value),
            ),
            
           _buildRadioButtonGroup(
                'Sensación de constricción en el cuello',
                ['SI', 'NO'],
                _sensaCuello,
                (value) => setState(() => _sensaCuello = value),
              ),

              _buildRadioButtonGroup(
                'Sensación de cuerpo extraño',
                ['SI', 'NO'],
                _sensaCuerpExtra,
                (value) => setState(() => _sensaCuerpExtra = value),
              ),
              _buildRadioButtonGroup(
                'Descarga posterior',
                ['SI', 'NO'],
                _descarPost,
                (value) => setState(() => _descarPost = value),
              ),
              _buildRadioButtonGroup(
                'Odinofagia',
                ['SI', 'NO'],
                _odinofagia,
                (value) => setState(() => _odinofagia = value),
              ),
              _buildRadioButtonGroup(
                'Extensión tonal reducida',
                ['SI', 'NO'],
                _extenReduci,
                (value) => setState(() => _extenReduci = value),
              ),
              _buildRadioButtonGroup(
                'Picor laríngeo',
                ['SI', 'NO'],
                _picoLaring,
                (value) => setState(() => _picoLaring = value),
              ),





               Divider(),
            _buildSection('4 .- Antecedentes mórbidos'),
            Text("     En relación a ciertas enfermedades:"),

            _buildFormField(_formFields[17]),

            _buildRadioButtonGroup(
              '¿Presenta alguna enfermedad?',
              ['Respiratoria', 'Auditiva', 'Digestiva', 'Psicológica'],
              _preAlguEnfer,
              (value) => setState(() => _preAlguEnfer = value),
            ),

            _buildRadioButtonGroup(
              '¿Sufre de estrés?',
              ['SI', 'NO'],
              _sufreEstres,
              (value) => setState(() => _sufreEstres = value),
            ),

            _buildFormField(_formFields[18]),
            _buildFormField(_formFields[19]),
            _buildFormField(_formFields[20]),
            _buildFormField(_formFields[21]),
            _buildFormField(_formFields[22]),
            _buildFormField(_formFields[23]),



             Divider(),
            _buildSection('5 .- Antecedentes terapéuticos'),

            _buildRadioButtonGroup(
              '¿Ha recibido tratamiento médico por problemas de la voz?',
              ['SI', 'NO'],
              _ATerap1,
              (value) => setState(() => _ATerap1 = value),
            ),

            _buildRadioButtonGroup(
              '¿Se ha realizado exámenes?',
              ['SI', 'NO'],
              _ATerap2,
              (value) => setState(() => _ATerap2 = value),
            ),
            _buildRadioButtonGroup(
              '¿Ha recibido tratamiento fonoaudiológico por problemas de voz?',
              ['SI', 'NO'],
              _ATerap3,
              (value) => setState(() => _ATerap3 = value),
            ),
            _buildRadioButtonGroup(
              '¿Ha recibido técnica vocal?',
              ['SI', 'NO'],
              _ATerap4,
              (value) => setState(() => _ATerap4 = value),
            ),
            _buildRadioButtonGroup(
              '¿Aplica la técnica vocal?',
              ['SI', 'NO'],
              _ATerap5,
              (value) => setState(() => _ATerap5 = value),
            ),


            Divider(),
            _buildSection('6 .- Abuso vocal'),

             _buildRadioButtonGroup(
    'Tose en exceso',
    ['SI', 'NO'],
    _AbuVocal1,
    (value) => setState(() => _AbuVocal1 = value),
  ),

  _buildRadioButtonGroup(
    'Grita en exceso',
    ['SI', 'NO'],
    _AbuVocal2,
    (value) => setState(() => _AbuVocal2 = value),
  ),
  _buildRadioButtonGroup(
    'Habla mucho',
    ['SI', 'NO'],
    _AbuVocal3,
    (value) => setState(() => _AbuVocal3 = value),
  ),
  _buildRadioButtonGroup(
    'Habla rápido',
    ['SI', 'NO'],
    _AbuVocal4,
    (value) => setState(() => _AbuVocal4 = value),
  ),
  _buildRadioButtonGroup(
    'Imita voces',
    ['SI', 'NO'],
    _AbuVocal5,
    (value) => setState(() => _AbuVocal5 = value),
  ),
  _buildRadioButtonGroup(
    'Habla con exceso de ruido',
    ['SI', 'NO'],
    _AbuVocal6,
    (value) => setState(() =>_AbuVocal6  = value),
  ),
  _buildRadioButtonGroup(
    '¿Reduce el uso de la voz en resfríos?',
    ['SI', 'NO'],
    _AbuVocal7,
    (value) => setState(() => _AbuVocal7 = value),
  ),
  _buildRadioButtonGroup(
    'Carraspea en exceso',
    ['SI', 'NO'],
    _AbuVocal8,
    (value) => setState(() =>_AbuVocal8  = value),
  ),
  _buildRadioButtonGroup(
    '¿Habla forzando la voz?',
    ['SI', 'NO'],
    _AbuVocal9,
    (value) => setState(() => _AbuVocal9 = value),
  ),
  _buildRadioButtonGroup(
    '¿Habla al mismo tiempo que otras personas?',
    ['SI', 'NO'],
    _AbuVocal10,
    (value) => setState(() => _AbuVocal10 = value),
  ),
  _buildRadioButtonGroup(
    '¿Habla con dientes, hombro y cuello apretado?',
    ['SI', 'NO'],
    _AbuVocal11,
    (value) => setState(() => _AbuVocal11 = value),
  ),



  Divider(),
            _buildSection('7 .- Mal uso vocal'),

            _buildRadioButtonGroup(
    'Trata de hablar con un tono más agudo o grave que el suyo',
    ['SI', 'NO'],
    _MalVocal1,
    (value) => setState(() => _MalVocal1 = value),
  ),
  _buildRadioButtonGroup(
    'Trata de hablar con un volumen de voz más débil o alto de lo usual',
    ['SI', 'NO'],
    _MalVocal2,
    (value) => setState(() => _MalVocal2 = value),
  ),
  _buildRadioButtonGroup(
    'Canta fuera de registro',
    ['SI', 'NO'],
    _MalVocal3,
    (value) => setState(() => _MalVocal3 = value),
  ),
  _buildRadioButtonGroup(
    'Canta sin vocalizar',
    ['SI', 'NO'],
    _MalVocal4,
    (value) => setState(() => _MalVocal4 = value),
  ),

 Divider(),
            _buildSection('8 .- Factores externos'),


            _buildRadioButtonGroup(
    'Vive en ambiente de fumadores',
    ['SI', 'NO'],
    _FactExter1,
    (value) => setState(() => _FactExter1 = value),
  ),
  _buildRadioButtonGroup(
    'Trabaja en un ambiente ruidoso',
    ['SI', 'NO'],
    _FactExter2,
    (value) => setState(() => _FactExter2 = value),
  ),
  _buildRadioButtonGroup(
    'Permanece en ambiente con aire acondicionado',
    ['SI', 'NO'],
    _FactExter3,
    (value) => setState(() => _FactExter3 = value),
  ),
  _buildRadioButtonGroup(
    'Permanece en ambientes con poca ventilación',
    ['SI', 'NO'],
    _FactExter4,
    (value) => setState(() => _FactExter4 = value),
  ),
  _buildRadioButtonGroup(
    'Se expone a cambios bruscos de temperatura',
    ['SI', 'NO'],
    _FactExter5,
    (value) => setState(() => _FactExter5 = value),
  ),



  Divider(),
  _buildSection('9.- Hábitos generales'),
   _buildRadioButtonGroup(
    'Realiza reposo vocal',
    ['SI', 'NO'],
    _repoVocal,
    (value) => setState(() => _repoVocal = value),
  ),
  _buildFormField(_formFields[24]),

  _buildRadioButtonGroup(
    'Habla mucho tiempo sin beber liquido',
    ['SI', 'NO'],
    _sinBeberLiqui,
    (value) => setState(() => _sinBeberLiqui = value),
  ),

  _buildRadioButtonGroup(
    '¿Asiste al otorrinolaringólogo?',
    ['SI', 'NO'],
    _otorrino,
    (value) => setState(() => _otorrino = value),
  ),
  _buildRadioButtonGroup(
    'Consume alimentos muy condimentados',
    ['SI', 'NO'],
    _alimenCondi,
    (value) => setState(() => _alimenCondi = value),
  ),
  _buildRadioButtonGroup(
    'Consume alimentos muy calientes o muy fríos',
    ['SI', 'NO'],
    _alimenCalienoFrio,
    (value) => setState(() => _alimenCalienoFrio = value),
  ),
  _buildRadioButtonGroup(
    'Consume bebidas alcohólicas',
    ['SI', 'NO'],
    _bebiAlcohol,
    (value) => setState(() => _bebiAlcohol = value),
  ),
  _buildRadioButtonGroup(
    'Fuma',
    ['SI', 'NO'],
    _fuma,
    (value) => setState(() => _fuma = value),
  ),
  _buildRadioButtonGroup(
    'Consume café',
    ['SI', 'NO'],
    _cafe,
    (value) => setState(() => _cafe = value),
  ),
  _buildRadioButtonGroup(
    'Consume drogas',
    ['SI', 'NO'],
    _drogas,
    (value) => setState(() => _drogas = value),
  ),
  _buildRadioButtonGroup(
    'Utiliza ropa ajustada',
    ['SI', 'NO'],
    _ropaAjust,
    (value) => setState(() => _ropaAjust = value),
  ),  
  _buildFormField(_formFields[25]),


   Divider(),
  _buildSection('10.- Uso laboral y profesinal de la voz'),

  _buildFormField(_formFields[26]),
  _buildFormField(_formFields[27]),
  _buildFormField(_formFields[28]),
  _buildFormField(_formFields[29]),
  _buildFormField(_formFields[30]),
  _buildFormField(_formFields[31]),
  _buildFormField(_formFields[32]),

              
          ],
        ),
      ),
      floatingActionButton:
          _buildSubmitButton(), // Botón flotante en la parte inferior derecha
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // Posición en la esquina inferior derecha
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/imagenes/san-miguel.png', // Imagen del ángel
                width: 60,
                height: 100,
              ),
              SizedBox(width: 10), // Espacio entre la imagen y el texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Cambiado a 'center' para centrar el texto
                  children: [
                    Text(
                      'Fundación de niños especiales',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign
                          .center, // Asegura que cada texto también esté centrado
                    ),
                    Text(
                      '"SAN MIGUEL" FUNESAMI',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center, // Centra el texto
                    ),
                    
                    SizedBox(height: 5),
                    Text(
                      'Anamnesis de Voz',
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 252, 4, 4),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center, // Centra el texto
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Historia clínica',
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 252, 4, 4),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center, // Centra el texto
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 9.0),
      child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildFormField(Map<String, dynamic> field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controllers[field['name']],
        decoration: InputDecoration(
          labelText: field['label'],
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        keyboardType: field['name'] == 'telefono'
            ? TextInputType.phone // Aquí configuramos el teclado numérico
            : TextInputType.text, // Para otros campos el teclado es de texto
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor complete este campo';
          }
          return null;
        },
        minLines: field['multiline'] == true
            ? 3
            : null, // Campo mínimo de 1 línea si es multilinea
        maxLines: field['multiline'] == true
            ? 3
            : 1, // Campo máximo de 3 líneas si es multilinea
      ),
    );
  }

  Widget _buildSubmitButton() {
    return FloatingActionButton(
      onPressed: _submitForm,
      child: Icon(Icons.save), // Usa un icono de guardado como en la imagen
      backgroundColor: Color.fromARGB(224, 68, 137, 255),
    );
  }
}