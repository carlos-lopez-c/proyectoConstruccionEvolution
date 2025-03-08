import 'package:flutter/material.dart';
import 'package:hc_ps_bueno/BuscarHistorialTRPS.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

class HistoriaT extends StatefulWidget {
  @override
  _HistoriaTState createState() => _HistoriaTState();
}

class _HistoriaTState extends State<HistoriaT> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _motivoConsultaController = TextEditingController();
  final TextEditingController _estadoEmocionalController = TextEditingController();
  final TextEditingController _estresAnsiedadController = TextEditingController();
  final TextEditingController _dinamicaSocialController = TextEditingController();
  final TextEditingController _intervencionTerapeuticaController = TextEditingController();
  final TextEditingController _observacionesController = TextEditingController();

  DateTime? _fechaNacimiento;
  DateTime? _fechaEvaluacion;
  int _edad = 0;

  void _seleccionarFechaNacimiento(BuildContext context) async {
    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (fechaSeleccionada != null) {
      setState(() {
        _fechaNacimiento = fechaSeleccionada;
        _edad = DateTime.now().year - fechaSeleccionada.year;
        if (DateTime.now().month < fechaSeleccionada.month ||
            (DateTime.now().month == fechaSeleccionada.month &&
                DateTime.now().day < fechaSeleccionada.day)) {
          _edad--;
        }
      });
    }
  }

  void _seleccionarFechaEvaluacion(BuildContext context) async {
    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (fechaSeleccionada != null) {
      setState(() {
        _fechaEvaluacion = fechaSeleccionada;
      });
    }
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
          .collection('HistoriaTeraGeneral')
          .where('cedula', isEqualTo: cedula)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var pacienteData = querySnapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          _nombreController.text = pacienteData['nombre'] ?? '';
          _fechaNacimiento = DateFormat('dd/MM/yyyy').parse(pacienteData['fechaNacimiento']);
          _fechaEvaluacion = DateFormat('dd/MM/yyyy').parse(pacienteData['fechaEvaluacion']);
          _edad = pacienteData['edad'] ?? 0;
          _motivoConsultaController.text = pacienteData['motivoConsulta'] ?? '';
          _estadoEmocionalController.text = pacienteData['estadoEmocional'] ?? '';
          _estresAnsiedadController.text = pacienteData['estresAnsiedad'] ?? '';
          _dinamicaSocialController.text = pacienteData['dinamicaSocial'] ?? '';
          _intervencionTerapeuticaController.text = pacienteData['intervencionTerapeutica'] ?? '';
          _observacionesController.text = pacienteData['observaciones'] ?? '';
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
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Historia Clínica Psicológica',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Nombre: ${data['nombre']}'),
              pw.Text('Cédula: ${data['cedula']}'),
              pw.Text('Fecha de Nacimiento: ${data['fechaNacimiento']}'),
              pw.Text('Fecha de Evaluación: ${data['fechaEvaluacion']}'),
              pw.Text('Edad: ${data['edad']}'),
              pw.Text('Motivo de Consulta: ${data['motivoConsulta']}'),
              pw.Text('Estado Emocional: ${data['estadoEmocional']}'),
              pw.Text('Niveles de Estrés y Ansiedad: ${data['estresAnsiedad']}'),
              pw.Text('Dinámica Social: ${data['dinamicaSocial']}'),
              pw.Text('Intervención Terapéutica: ${data['intervencionTerapeutica']}'),
              pw.Text('Observaciones: ${data['observaciones']}'),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> savePdfLocally(Uint8List pdfBytes, String nombrePdf) async {
    try {
      // Obtener el directorio de almacenamiento externo
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('No se pudo acceder al almacenamiento externo');
      }

      // Crear la carpeta "TerapPS" si no existe
      final folder = Directory('${directory.path}/TerapPS');
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

  Future<void> _guardarDatos() async {
    if (_formKey.currentState!.validate()) {
      try {
        String cedula = _cedulaController.text.trim();

        // Buscar el documento existente
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('HistoriaTeraGeneral')
            .where('cedula', isEqualTo: cedula)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Sobrescribir el registro existente
          var docId = querySnapshot.docs.first.id;
          await FirebaseFirestore.instance
              .collection('HistoriaTeraGeneral')
              .doc(docId)
              .update({
            'nombre': _nombreController.text,
            'cedula': cedula,
            'fechaNacimiento': _fechaNacimiento != null
                ? DateFormat('dd/MM/yyyy').format(_fechaNacimiento!)
                : null,
            'fechaEvaluacion': _fechaEvaluacion != null
                ? DateFormat('dd/MM/yyyy').format(_fechaEvaluacion!)
                : null,
            'edad': _edad,
            'motivoConsulta': _motivoConsultaController.text,
            'estadoEmocional': _estadoEmocionalController.text,
            'estresAnsiedad': _estresAnsiedadController.text,
            'dinamicaSocial': _dinamicaSocialController.text,
            'intervencionTerapeutica': _intervencionTerapeuticaController.text,
            'observaciones': _observacionesController.text,
          });
        } else {
          // Crear un nuevo registro si no existe
          await FirebaseFirestore.instance.collection('HistoriaTeraGeneral').add({
            'nombre': _nombreController.text,
            'cedula': cedula,
            'fechaNacimiento': _fechaNacimiento != null
                ? DateFormat('dd/MM/yyyy').format(_fechaNacimiento!)
                : null,
            'fechaEvaluacion': _fechaEvaluacion != null
                ? DateFormat('dd/MM/yyyy').format(_fechaEvaluacion!)
                : null,
            'edad': _edad,
            'motivoConsulta': _motivoConsultaController.text,
            'estadoEmocional': _estadoEmocionalController.text,
            'estresAnsiedad': _estresAnsiedadController.text,
            'dinamicaSocial': _dinamicaSocialController.text,
            'intervencionTerapeutica': _intervencionTerapeuticaController.text,
            'observaciones': _observacionesController.text,
          });
        }

        // Generar el PDF
        final pdfData = await generatePdf({
          'nombre': _nombreController.text,
          'cedula': cedula,
          'fechaNacimiento': _fechaNacimiento != null
              ? DateFormat('dd/MM/yyyy').format(_fechaNacimiento!)
              : 'No especificada',
          'fechaEvaluacion': _fechaEvaluacion != null
              ? DateFormat('dd/MM/yyyy').format(_fechaEvaluacion!)
              : 'No especificada',
          'edad': _edad,
          'motivoConsulta': _motivoConsultaController.text,
          'estadoEmocional': _estadoEmocionalController.text,
          'estresAnsiedad': _estresAnsiedadController.text,
          'dinamicaSocial': _dinamicaSocialController.text,
          'intervencionTerapeutica': _intervencionTerapeuticaController.text,
          'observaciones': _observacionesController.text,
        });

        // Nombre del PDF basado en la fecha de evaluación y la cédula
        final nombrePdf = '${DateFormat('yyyyMMdd').format(_fechaEvaluacion!)}_${cedula}';

        // Guardar el PDF localmente en la carpeta "TerapPS"
        await savePdfLocally(pdfData, nombrePdf);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Formulario guardado correctamente en Firebase y PDF generado')),
        );

        // Limpiar el formulario
        _nombreController.clear();
        _cedulaController.clear();
        _motivoConsultaController.clear();
        _estadoEmocionalController.clear();
        _estresAnsiedadController.clear();
        _dinamicaSocialController.clear();
        _intervencionTerapeuticaController.clear();
        _observacionesController.clear();
        setState(() {
          _fechaNacimiento = null;
          _fechaEvaluacion = null;
          _edad = 0;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar los datos: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historia Clínica Psicológica")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/imagenes/san-miguel.png',
                    width: 70,
                    height: 100,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Fundación ',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '"UNA MIRADA FELIZ"',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Historias clínicas área de Terapias Psicologia',
                          style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 92, 60, 60)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: "Nombre del Paciente"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del paciente';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _cedulaController,
                decoration: InputDecoration(labelText: "Cédula"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la cédula';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _buscarPaciente,
                      child: Text('Buscar'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _guardarDatos,
                      child: Text('Guardar'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BuscarHistorialTRPS()),
                        );
                      },
                      child: Text('Historial'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _seleccionarFechaNacimiento(context),
                      child: InputDecorator(
                        decoration:
                            InputDecoration(labelText: "Fecha de Nacimiento"),
                        child: Text(
                          _fechaNacimiento != null
                              ? DateFormat('dd/MM/yyyy')
                                  .format(_fechaNacimiento!)
                              : "Seleccione una fecha",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () => _seleccionarFechaEvaluacion(context),
                      child: InputDecorator(
                        decoration:
                            InputDecoration(labelText: "Fecha de Evaluación"),
                        child: Text(
                          _fechaEvaluacion != null
                              ? DateFormat('dd/MM/yyyy')
                                  .format(_fechaEvaluacion!)
                              : "Seleccione una fecha",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              InputDecorator(
                decoration: InputDecoration(labelText: "Edad"),
                child: Text("$_edad años"),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _motivoConsultaController,
                maxLines: 3,
                decoration: InputDecoration(labelText: "Motivo de Consulta"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el motivo de la consulta';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _estadoEmocionalController,
                decoration: InputDecoration(labelText: "Estado Emocional"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el estado emocional';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _estresAnsiedadController,
                decoration:
                    InputDecoration(labelText: "Niveles de Estrés y Ansiedad"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese los niveles de estrés y ansiedad';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _dinamicaSocialController,
                decoration: InputDecoration(labelText: "Dinámica Social"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la dinámica social';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _intervencionTerapeuticaController,
                maxLines: 3,
                decoration:
                    InputDecoration(labelText: "Intervención Terapéutica"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la intervención terapéutica';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _observacionesController,
                maxLines: 3,
                decoration: InputDecoration(labelText: "Observaciones"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese las observaciones';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}