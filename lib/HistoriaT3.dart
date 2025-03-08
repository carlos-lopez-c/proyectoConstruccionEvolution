import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Para manejar la selección de fechas
import 'SearchHistoriaPageAliment.dart';

class HistoriaT3 extends StatefulWidget {
  @override
  _HistoriaT3State createState() => _HistoriaT3State();
}

class _HistoriaT3State extends State<HistoriaT3> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  final List<Map<String, dynamic>> _formFields = [
    {'name': 'nombre', 'label': 'Nombre completo'},
    {'name': 'IA3porque', 'label': '¿Por qué?'},
    {'name': 'EF1text', 'label': '¿Qué porción consume?'},
    {'name': 'EF2text', 'label': '¿Cuántos kilos?'},
    {'name': 'EF3text', 'label': '¿Cuál?'},
    {'name': 'EF4text', 'label': '¿Qué tipo de líquido consume habitualmente?'},
    {'name': 'EF5text', 'label': '¿Cuánto líquido consume al día?'},

    {'name': 'Stext1', 'label': '¿Con qué frecuencia?'},
    {'name': 'Stext2', 'label': '¿Con qué alimentos/líquidos/medicamentos?'},
    {'name': 'Stext3', 'label': '¿Con qué frecuencia?'},

    {'name': 'PAtext1', 'label': '¿Cuánto?'},
    {'name': 'PAtext2', 'label': '¿Cuál(es)?', 'multiline': true},

    {'name': 'SBtext1', 'label': '¿Por qué?', 'multiline': true},
    {
      'name': 'SBtext2',
      'label': '¿Con qué frecuencia se lava los dientes/lava su prótesis?',
      'multiline': true
    },
    {'name': 'SBtext3', 'label': '¿Con qué frecuencia?'},
    {'name': 'SBtext4', 'label': '¿Cuál?', 'multiline': true},
    // {'name': 'razonDeriva', 'label': 'Razón de la derivación', 'multiline': true},
  ];

  DateTime? _fechaEntrevista;

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

        formData['lateralidad'] = _lateralidad;

        formData['IA1'] = _IA1;
        formData['IA2'] = _IA2;
        formData['IA3'] = _IA3;
        formData['IA4'] = _IA4;

        formData['EF1'] = _EF1;
        formData['EF2'] = _EF2;
        formData['EF3'] = _EF3;
        formData['EF4'] = _EF4;

        formData['S1'] = _S1;
        formData['S2'] = _S2;
        formData['S3'] = _S3;
        formData['S4'] = _S4;
        formData['S5'] = _S5;
        formData['S6'] = _S6;
        formData['S7'] = _S7;

        formData['PA1'] = _PA1;
        formData['PA2'] = _PA2;
        formData['PA3'] = _PA3;

        formData['SB1'] = _SB1;
        formData['SB2'] = _SB2;
        formData['SB3'] = _SB3;
        formData['SB4'] = _SB4;
        formData['SB5'] = _SB5;

        // Enviar a Firebase
        await FirebaseFirestore.instance
            .collection('HistoriaAnamAliment')
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

      _lateralidad = null;
      _IA1 = null;
      _IA2 = null;
      _IA3 = null;
      _IA4 = null;

      _EF1 = null;
      _EF2 = null;
      _EF3 = null;
      _EF4 = null;

      _S1 = null;
      _S2 = null;
      _S3 = null;
      _S4 = null;
      _S5 = null;
      _S6 = null;
      _S7 = null;

      _PA1 = null;
      _PA2 = null;
      _PA3 = null;

      _SB1 = null;
      _SB2 = null;
      _SB3 = null;
      _SB4 = null;
      _SB5 = null;
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
                    MaterialPageRoute(
                        builder: (context) =>
                            SearchHistoriaPageAliment()), // Navega a la página busqueda
                  );
                },
                child: Text('Pagina de busqueda'),
              ),
            ),

            _buildSection('1.- Antecedentes personales'),
            _buildFormField(_formFields[0]), // Nombre completo
            _buildFechaField('Fecha evaluación', _fechaEntrevista,
                (fecha) => setState(() => _fechaEntrevista = fecha)),

            Divider(),
            _buildRadioButtonGroup(
              'Lateralidad',
              ['Diestro', 'Zurdo', 'Ambidiestro'],
              _lateralidad,
              (value) => setState(() => _lateralidad = value),
            ),

            Divider(),
            _buildSection('2 .- Independencia y autonomia'),
            _buildRadioButtonGroup(
              '¿Se alimenta solo(a) o necesita ayuda?',
              ['solo', 'con ayuda parcial', 'con ayuda total'],
              _IA1,
              (value) => setState(() => _IA1 = value),
            ),

            _buildRadioButtonGroup(
              '¿Qué tipo de ayuda necesita?',
              [
                'Para identificar qué está comiendo',
                'Para llevar el alimento a la boca/evitar derrames',
                'Ninguna'
              ],
              _IA2,
              (value) => setState(() => _IA2 = value),
            ),

            _buildRadioButtonGroup(
              '¿Prepara sus propios alimentos o para alguine más?',
              ['SI', 'NO'],
              _IA3,
              (value) => setState(() => _IA3 = value),
            ),

            _buildFormField(_formFields[1]), // IA3porque

            _buildRadioButtonGroup(
              '¿Decide qué alimentos desea consumir o participar activamente en estas decisiones en el hogar?',
              ['SI', 'NO'],
              _IA4,
              (value) => setState(() => _IA4 = value),
            ),

            Divider(),
            _buildSection('3 .- Eficiencia'),
            _buildRadioButtonGroup(
              '¿Consume la totalidad del alimento que se le sirve?',
              ['SI', 'NO'],
              _EF1,
              (value) => setState(() => _EF1 = value),
            ),

            _buildFormField(_formFields[2]), // EF1
            _buildRadioButtonGroup(
              '¿Ha presentado pérdidas importantes de peso en el último tiempo?',
              ['SI', 'NO'],
              _EF2,
              (value) => setState(() => _EF2 = value),
            ),
            _buildFormField(_formFields[3]), // EF2
            _buildRadioButtonGroup(
              '¿Manifiesta interés por alimentarse?',
              ['SI', 'NO'],
              _EF3,
              (value) => setState(() => _EF3 = value),
            ),

            _buildRadioButtonGroup(
              '¿Manifiesta rechazo o preferencias por algún tipo de alimento?',
              ['SI', 'NO'],
              _EF4,
              (value) => setState(() => _EF4 = value),
            ),
            _buildFormField(_formFields[4]), // EF3

            _buildFormField(_formFields[5]), // EF4
            _buildFormField(_formFields[6]), // EF5

            Divider(),
            _buildSection('4 .- Seguridad'),

            _buildRadioButtonGroup(
              '¿Se atora con su saliva?',
              ['SI', 'NO'],
              _S1,
              (value) => setState(() => _S1 = value),
            ),
            _buildFormField(_formFields[7]),

            _buildRadioButtonGroup(
              '¿Tiene tos o ahogos cuando se alimenta o consume sus medicamentos?',
              ['SI', 'NO'],
              _S2,
              (value) => setState(() => _S2 = value),
            ),
            _buildFormField(_formFields[8]),

            _buildRadioButtonGroup(
              '¿Presenta alguna dificultad para tomar líquidos de un vaso?',
              ['SI', 'NO'],
              _S3,
              (value) => setState(() => _S3 = value),
            ),
            _buildRadioButtonGroup(
              '¿Presenta dificultad con las sopas o los granos pequeños como el arroz?',
              ['SI', 'NO'],
              _S4,
              (value) => setState(() => _S4 = value),
            ),

            _buildRadioButtonGroup(
              '¿Ha presentado neumonías?',
              ['SI', 'NO'],
              _S5,
              (value) => setState(() => _S5 = value),
            ),
            _buildFormField(_formFields[9]),

            _buildRadioButtonGroup(
              '¿Se queda con restos de alimento en la boca luego de alimentarse?',
              ['SI', 'NO'],
              _S6,
              (value) => setState(() => _S6 = value),
            ),

            _buildRadioButtonGroup(
              '¿Siente que el alimento se va hacia su nariz?',
              ['SI', 'NO'],
              _S7,
              (value) => setState(() => _S7 = value),
            ),

            Divider(),
            _buildSection('5 .- Proceso de alimentación'),
            _buildRadioButtonGroup(
              '¿Se demora más tiempo que el resto de la familia?',
              ['SI', 'NO'],
              _PA1,
              (value) => setState(() => _PA1 = value),
            ),
            _buildFormField(_formFields[10]),

            _buildRadioButtonGroup(
              '¿Cree usted que come muy rápido?',
              ['SI', 'NO'],
              _PA2,
              (value) => setState(() => _PA2 = value),
            ),

            _buildRadioButtonGroup(
              '¿Suele realizar alguna otra actividad mientras come?',
              ['SI', 'NO'],
              _PA3,
              (value) => setState(() => _PA3 = value),
            ),
            _buildFormField(_formFields[11]),

            Divider(),
            _buildSection('6 .- Salud bocal'),

            _buildRadioButtonGroup(
              '¿Cuenta con todas sus piezas dentarias/dientes?',
              ['SI', 'NO'],
              _SB1,
              (value) => setState(() => _SB1 = value),
            ),
            _buildFormField(_formFields[12]),
            _buildRadioButtonGroup(
              '¿Utiliza placa dental?',
              ['SI', 'NO'],
              _SB2,
              (value) => setState(() => _SB2 = value),
            ),
            _buildRadioButtonGroup(
              '¿Se realiza aseo bucal después de cada comida?',
              ['SI', 'NO'],
              _SB3,
              (value) => setState(() => _SB3 = value),
            ),
            _buildFormField(_formFields[13]),
            _buildRadioButtonGroup(
              '¿Asiste regularmente a controles dentales?',
              ['SI', 'NO'],
              _SB4,
              (value) => setState(() => _SB4 = value),
            ),
            _buildFormField(_formFields[14]),
            _buildRadioButtonGroup(
              '¿Tiene alguna molestia o dolor dentro de su boca (dientes, encías, paladar, lengua)?',
              ['SI', 'NO'],
              _SB5,
              (value) => setState(() => _SB5 = value),
            ),
            _buildFormField(_formFields[15]),
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
                      'Historia clínica',
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 252, 4, 4),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center, // Centra el texto
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
                      'Anamnesis alimentaria adultos y adultos mayores',
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
