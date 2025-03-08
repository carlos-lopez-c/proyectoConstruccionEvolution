import 'package:flutter/material.dart';
import 'package:hc_ps_bueno/BuscarHistorial.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

class HistoriaAdult extends StatefulWidget {
  const HistoriaAdult({super.key});

  @override
  _HistoriaAdultState createState() => _HistoriaAdultState();
}

class _HistoriaAdultState extends State<HistoriaAdult> {
  DateTime? _selectedDate;
  DateTime? _evaluationDate;
  int _age = 0;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _cursoController = TextEditingController();
  final TextEditingController _institucionController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _remisionController = TextEditingController();
  final TextEditingController _coberturaController = TextEditingController();
  final TextEditingController _observacionesController = TextEditingController();
  final TextEditingController _responsableController = TextEditingController();
  final TextEditingController _motivoConsultaController = TextEditingController();
  final TextEditingController _desencadenantesController = TextEditingController();
  final TextEditingController _antecedentesGController = TextEditingController();
  final TextEditingController _estructuraFamiliarController = TextEditingController();
  final TextEditingController _pruebasController = TextEditingController();
  final TextEditingController _impresionDiagnosticaController = TextEditingController();
  final TextEditingController _areasIntervencionController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _age = _calculateAge(_selectedDate!);
      });
    }
  }

  Future<void> _selectEvaluationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _evaluationDate) {
      setState(() {
        _evaluationDate = picked;
      });
    }
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> _buscarPaciente() async {
    String cedula = _cedulaController.text.trim();

    if (cedula.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese una cédula')),
      );
      return;
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('HistoriaAdult')
          .where('cedula', isEqualTo: cedula)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var pacienteData = querySnapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          _nombreController.text = pacienteData['nombres'] ?? '';
          _selectedDate = DateTime.parse(pacienteData['fechaNacimiento']);
          _age = _calculateAge(_selectedDate!);
          _cursoController.text = pacienteData['curso'] ?? '';
          _institucionController.text = pacienteData['institucion'] ?? '';
          _direccionController.text = pacienteData['direccion'] ?? '';
          _telefonoController.text = pacienteData['telefono'] ?? '';
          _remisionController.text = pacienteData['remision'] ?? '';
          _evaluationDate = DateTime.parse(pacienteData['fechaEvaluacion']);
          _coberturaController.text = pacienteData['cobertura'] ?? '';
          _observacionesController.text = pacienteData['observaciones'] ?? '';
          _responsableController.text = pacienteData['responsable'] ?? '';
          _motivoConsultaController.text = pacienteData['motivoConsulta'] ?? '';
          _desencadenantesController.text = pacienteData['desencadenantes'] ?? '';
          _antecedentesGController.text = pacienteData['antecedenteG'] ?? '';
          _estructuraFamiliarController.text = pacienteData['estructuraFamiliar'] ?? '';
          _pruebasController.text = pacienteData['pruebas'] ?? '';
          _impresionDiagnosticaController.text = pacienteData['impresionDiagnostica'] ?? '';
          _areasIntervencionController.text = pacienteData['areasIntervencion'] ?? '';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Paciente encontrado')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró ningún paciente con esa cédula')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar paciente: $e')),
      );
    }
  }

  Future<Uint8List> generatePdf(Map<String, dynamic> data) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Historia Clínica de Adultos',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text('Nombre: ${data['nombres']}'),
                pw.Text('Cédula: ${data['cedula']}'),
                pw.Text('Fecha de Nacimiento: ${data['fechaNacimiento']}'),
                pw.Text('Edad: ${data['edad']}'),
                pw.Text('Curso: ${data['curso']}'),
                pw.Text('Institución: ${data['institucion']}'),
                pw.Text('Dirección: ${data['direccion']}'),
                pw.Text('Teléfono: ${data['telefono']}'),
                pw.Text('Motivo de Consulta: ${data['motivoConsulta']}'),
                pw.Text('Observaciones: ${data['observaciones']}'),
                pw.Text('Desencadenantes: ${data['desencadenantes']}'),
                pw.Text('Antecedentes Generales: ${data['antecedentesG']}'),
                pw.Text('Estructura Familiar: ${data['estructuraFamiliar']}'),
                pw.Text('Pruebas Aplicadas: ${data['pruebas']}'),
                pw.Text('Impresión Diagnóstica: ${data['impresionDiagnostica']}'),
                pw.Text('Áreas de Intervención: ${data['areasIntervencion']}'),
              ],
            );
          },
        ),
      );

      return pdf.save();
    } catch (e) {
      print('Error al generar el PDF: $e');
      throw Exception('Error al generar el PDF: $e');
    }
  }

  Future<void> savePdfLocally(Uint8List pdfBytes, String nombrePdf) async {
    try {
      // Obtener el directorio de almacenamiento externo
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('No se pudo acceder al almacenamiento externo');
      }

      // Crear la carpeta "AdultPS" si no existe
      final folder = Directory('${directory.path}/AdultPS');
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      // Guardar el PDF en la carpeta
      final file = File('${folder.path}/$nombrePdf.pdf');
      await file.writeAsBytes(pdfBytes);

      // Mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF guardado en: ${file.path}')),
      );
    } catch (e) {
      // Manejar errores
      print('Error al guardar el PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el PDF: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    // Verificación de que todos los campos estén llenos
    if (_cedulaController.text.isEmpty ||
        _nombreController.text.isEmpty ||
        _cursoController.text.isEmpty ||
        _institucionController.text.isEmpty ||
        _direccionController.text.isEmpty ||
        _telefonoController.text.isEmpty ||
        _remisionController.text.isEmpty ||
        _coberturaController.text.isEmpty ||
        _observacionesController.text.isEmpty ||
        _responsableController.text.isEmpty ||
        _motivoConsultaController.text.isEmpty ||
        _desencadenantesController.text.isEmpty ||
        _antecedentesGController.text.isEmpty ||
        _estructuraFamiliarController.text.isEmpty ||
        _pruebasController.text.isEmpty ||
        _impresionDiagnosticaController.text.isEmpty ||
        _areasIntervencionController.text.isEmpty ||
        _selectedDate == null ||
        _evaluationDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Verifique que todos los campos estén llenos antes de enviar el formulario'),
        ),
      );
      return;
    }

    // Validación para el campo de teléfono (solo números)
    if (!RegExp(r'^[0-9]+$').hasMatch(_telefonoController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('En el campo de teléfono solo se permiten números'),
        ),
      );
      return;
    }

    try {
      String cedula = _cedulaController.text.trim();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('HistoriaAdult')
          .where('cedula', isEqualTo: cedula)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Si el paciente ya existe, actualiza el registro
        var docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('HistoriaAdult')
            .doc(docId)
            .update({
          'nombres': _nombreController.text,
          'cedula': _cedulaController.text,
          'fechaNacimiento': _selectedDate!.toIso8601String(),
          'edad': _age,
          'curso': _cursoController.text,
          'institucion': _institucionController.text,
          'direccion': _direccionController.text,
          'telefono': _telefonoController.text,
          'remision': _remisionController.text,
          'fechaEvaluacion': _evaluationDate!.toIso8601String(),
          'cobertura': _coberturaController.text,
          'observaciones': _observacionesController.text,
          'responsable': _responsableController.text,
          'motivoConsulta': _motivoConsultaController.text,
          'desencadenantes': _desencadenantesController.text,
          'antecedenteG': _antecedentesGController.text,
          'estructuraFamiliar': _estructuraFamiliarController.text,
          'pruebas': _pruebasController.text,
          'impresionDiagnostica': _impresionDiagnosticaController.text,
          'areasIntervencion': _areasIntervencionController.text,
          'fechaActualizacion': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Formulario actualizado con éxito')),
        );
      } else {
        // Si el paciente no existe, crea un nuevo registro
        await FirebaseFirestore.instance.collection('HistoriaAdult').add({
          'nombres': _nombreController.text,
          'cedula': _cedulaController.text,
          'fechaNacimiento': _selectedDate!.toIso8601String(),
          'edad': _age,
          'curso': _cursoController.text,
          'institucion': _institucionController.text,
          'direccion': _direccionController.text,
          'telefono': _telefonoController.text,
          'remision': _remisionController.text,
          'fechaEvaluacion': _evaluationDate!.toIso8601String(),
          'cobertura': _coberturaController.text,
          'observaciones': _observacionesController.text,
          'responsable': _responsableController.text,
          'motivoConsulta': _motivoConsultaController.text,
          'desencadenantes': _desencadenantesController.text,
          'antecedenteG': _antecedentesGController.text,
          'estructuraFamiliar': _estructuraFamiliarController.text,
          'pruebas': _pruebasController.text,
          'impresionDiagnostica': _impresionDiagnosticaController.text,
          'areasIntervencion': _areasIntervencionController.text,
          'fechaCreacion': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Formulario enviado con éxito')),
        );
      }

      // Generar el PDF
      final pdfData = await generatePdf({
        'nombres': _nombreController.text,
        'cedula': _cedulaController.text,
        'fechaNacimiento': _selectedDate!.toIso8601String(),
        'edad': _age,
        'curso': _cursoController.text,
        'institucion': _institucionController.text,
        'direccion': _direccionController.text,
        'telefono': _telefonoController.text,
        'motivoConsulta': _motivoConsultaController.text,
        'observaciones': _observacionesController.text,
        'desencadenantes': _desencadenantesController.text,
        'antecedentesG': _antecedentesGController.text,
        'estructuraFamiliar': _estructuraFamiliarController.text,
        'pruebas': _pruebasController.text,
        'impresionDiagnostica': _impresionDiagnosticaController.text,
        'areasIntervencion': _areasIntervencionController.text,
      });

      // Nombre del PDF basado en la fecha de evaluación
      final nombrePdf = '${_evaluationDate!.toIso8601String()}_${_cedulaController.text.trim()}';

      // Guardar el PDF localmente en la carpeta "AdultPS"
      await savePdfLocally(pdfData, nombrePdf);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formulario enviado con éxito y PDF generado')),
      );

      // Limpiar el formulario y resetear los campos
      _nombreController.clear();
      _cedulaController.clear();
      _cursoController.clear();
      _institucionController.clear();
      _direccionController.clear();
      _telefonoController.clear();
      _remisionController.clear();
      _coberturaController.clear();
      _observacionesController.clear();
      _responsableController.clear();
      _motivoConsultaController.clear();
      _desencadenantesController.clear();
      _antecedentesGController.clear();
      _estructuraFamiliarController.clear();
      _pruebasController.clear();
      _impresionDiagnosticaController.clear();
      _areasIntervencionController.clear();
      setState(() {
        _selectedDate = null;
        _evaluationDate = null;
        _age = 0;
      });
    } catch (e) {
      print('Error en _submitForm: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar el formulario: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con imagen y texto
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/imagenes/san-miguel.png',
                    width: 117,
                    height: 125,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '            FUNDACIÓN',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '"UNA MIRADA FELIZ"',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Acuerdo Ministerial 078-08',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'HISTORIA CLÍNICA PSICOLÓGICA',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'HISTORIA CLINICA DE ADULTOS',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // Sección 1: Datos Personales
            const Text(
              '1.- DATOS PERSONALES:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombres y Apellidos',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cedulaController,
                    decoration: const InputDecoration(
                      labelText: 'Cédula',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _buscarPaciente,
                  child: const Text('Buscar'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Navegar a la página BuscarHistorial
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BuscarHistorial()),
                    );
                  },
                  child: const Text('Historial'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Fecha de Nacimiento',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _selectedDate != null
                            ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                            : 'Seleccione una fecha',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: TextEditingController(
                      text: _age.toString(),
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Edad',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _cursoController,
              decoration: const InputDecoration(
                labelText: 'Curso Escolar Actual',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _institucionController,
              decoration: const InputDecoration(
                labelText: 'Institución',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _direccionController,
              decoration: const InputDecoration(
                labelText: 'Dirección',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _telefonoController,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _remisionController,
              decoration: const InputDecoration(
                labelText: 'Remisión',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _selectEvaluationDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Fecha de Evaluación',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _evaluationDate != null
                      ? DateFormat('dd/MM/yyyy').format(_evaluationDate!)
                      : 'Seleccione una fecha',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _coberturaController,
              decoration: const InputDecoration(
                labelText: 'Final de Cobertura',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _observacionesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Observaciones',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _responsableController,
              decoration: const InputDecoration(
                labelText: 'Responsable',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Sección 2: Motivo de Consulta
            const Text(
              '2.- MOTIVO DE CONSULTA:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _motivoConsultaController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Describa el motivo de la consulta',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Sección 3: Desencadenantes
            const Text(
              '3.- DESENCADENANTES DE MOTIVO DE CONSULTA:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _desencadenantesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Describa los desencadenantes',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Sección 4: Antecedentes Familiares
            const Text(
              '4.- ANTECEDENTES FAMILIARES:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _antecedentesGController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Describa los antecedentes familiares',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Sección 5: Antecedentes y Estructura Familiar
            const Text(
              '5.- ANTECEDENTES Y ESTRUCTURA FAMILIAR:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _estructuraFamiliarController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Describa los antecedentes y estructura familiar',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Sección 6: Pruebas Aplicadas
            const Text(
              '6.- PRUEBAS APLICADAS:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _pruebasController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Describa las pruebas aplicadas',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Sección 7: Impresión Diagnóstica
            const Text(
              '7.- IMPRESIÓN DIAGNÓSTICA:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _impresionDiagnosticaController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Describa la impresión diagnóstica',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Sección 8: Áreas de Intervención
            const Text(
              '8.- ÁREAS DE INTERVENCIÓN:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _areasIntervencionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Describa las áreas de intervención',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitForm,
        child: const Icon(Icons.save),
      ),
    );
  }
}