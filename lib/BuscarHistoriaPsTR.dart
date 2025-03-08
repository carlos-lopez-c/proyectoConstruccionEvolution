import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuscarHistoriaPsTR extends StatefulWidget {
  const BuscarHistoriaPsTR({super.key});

  @override
  _BuscarHistoriaPsTRState createState() => _BuscarHistoriaPsTRState();
}

class _BuscarHistoriaPsTRState extends State<BuscarHistoriaPsTR> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();
  final TextEditingController _evaluationDateController =
      TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _cursoController = TextEditingController();
  final TextEditingController _institucionController = TextEditingController();
  final TextEditingController _nombrePapaController = TextEditingController();
  final TextEditingController _nombreMamaController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _remisionController = TextEditingController();
  final TextEditingController _coberturaController = TextEditingController();
  final TextEditingController _observacionesController =
      TextEditingController();
  final TextEditingController _responsableController = TextEditingController();
  final TextEditingController _motivoConsultaController =
      TextEditingController();
  final TextEditingController _desencadenantesController =
      TextEditingController();
  final TextEditingController _antecedentesGController =
      TextEditingController();
  final TextEditingController _antecedentesEmbarazoController =
      TextEditingController();
  final TextEditingController _antecedentesPsicomotorController =
      TextEditingController();
  final TextEditingController _antecedentesLenguajeController =
      TextEditingController();
  final TextEditingController _antecedentesIntelectualController =
      TextEditingController();
  final TextEditingController _antecedentesSocioAfectivoController =
      TextEditingController();
  final TextEditingController _estructuraFamiliarController =
      TextEditingController();
  final TextEditingController _pruebasController = TextEditingController();
  final TextEditingController _impresionDiagnosticaController =
      TextEditingController();
  final TextEditingController _areasIntervencionController =
      TextEditingController();

  Map<String, dynamic>? _historiaEncontrada;
  bool _busquedaRealizada = false;
  bool _modoEdicion = false; // Variable para controlar el modo de edición
  String?
      _coleccionSeleccionada; // Almacena la colección de donde se encontró el documento

  void _buscarHistoriaPorNombre() async {
    String nombrePaciente = _cedulaController.text.trim();

    if (nombrePaciente.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('INGRESE LA CEDULA')),
      );
      return;
    }

    // Buscamos en la colección 'HistoriaNinos'
    QuerySnapshot<Map<String, dynamic>> resultadoNinos = await FirebaseFirestore
        .instance
        .collection('HistoriaNinos')
        .where('cedula', isEqualTo: nombrePaciente)
        .get();

    // Si no encontramos resultados en 'HistoriaNinos', buscamos en 'HistoriaAdult'
    if (resultadoNinos.docs.isEmpty) {
      QuerySnapshot<Map<String, dynamic>> resultadoAdult =
          await FirebaseFirestore.instance
              .collection('HistoriaAdult')
              .where('cedula', isEqualTo: nombrePaciente)
              .get();

      if (resultadoAdult.docs.isNotEmpty) {
        setState(() {
          _busquedaRealizada = true;
          _historiaEncontrada = resultadoAdult.docs.first.data();
          _historiaEncontrada!['idDocumento'] =
              resultadoAdult.docs.first.id; // Captura el ID del documento
          _coleccionSeleccionada =
              'HistoriaAdult'; // Guardamos la colección seleccionada
          _llenarCamposControllers(); // Llenamos los controladores con los datos obtenidos
        });
      } else {
        // Si no hay resultados en ninguna colección
        setState(() {
          _busquedaRealizada = true;
          _historiaEncontrada = null; // No se encontró historia
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No se encontró ninguna historia clínica.')),
        );
      }
    } else {
      setState(() {
        _busquedaRealizada = true;
        _historiaEncontrada = resultadoNinos.docs.first.data();
        _historiaEncontrada!['idDocumento'] =
            resultadoNinos.docs.first.id; // Captura el ID del documento
        _coleccionSeleccionada =
            'HistoriaNinos'; // Guardamos la colección seleccionada
        _llenarCamposControllers(); // Llenamos los controladores con los datos obtenidos
      });
    }
  }

  // Método para llenar los controladores de texto con los datos obtenidos
  void _llenarCamposControllers() {
    if (_historiaEncontrada != null) {
      _nombreController.text = _historiaEncontrada!['nombres'] ?? '';
      _fechaNacimientoController.text =
          _historiaEncontrada!['fechaNacimiento'] ?? '';
      _edadController.text = _historiaEncontrada!['edad'].toString();
      _cursoController.text = _historiaEncontrada!['curso'] ?? '';
      _institucionController.text = _historiaEncontrada!['institucion'] ?? '';
      _nombreMamaController.text = _historiaEncontrada!['nombreMama'] ?? '';
      _nombrePapaController.text = _historiaEncontrada!['nombrePapa'] ?? '';
      _direccionController.text = _historiaEncontrada!['direccion'] ?? '';
      _telefonoController.text = _historiaEncontrada!['telefono'] ?? '';
      _observacionesController.text =
          _historiaEncontrada!['observaciones'] ?? '';
      _remisionController.text = _historiaEncontrada!['remision'] ?? '';
      _evaluationDateController.text =
          _historiaEncontrada!['fechaEvaluacion'] ?? '';
      _coberturaController.text = _historiaEncontrada!['cobertura'] ?? '';
      _responsableController.text = _historiaEncontrada!['responsable'] ?? '';
      _motivoConsultaController.text =
          _historiaEncontrada!['motivoConsulta'] ?? '';
      _desencadenantesController.text =
          _historiaEncontrada!['desencadenantes'] ?? '';
      _antecedentesGController.text =
          _historiaEncontrada!['antecedenteG'] ?? '';
      _antecedentesEmbarazoController.text =
          _historiaEncontrada!['DatosEmbarazo'] ?? '';
      _antecedentesPsicomotorController.text =
          _historiaEncontrada!['DatosPsicomotor'] ?? '';
      _antecedentesLenguajeController.text =
          _historiaEncontrada!['DatosLenguaje'] ?? '';
      _antecedentesIntelectualController.text =
          _historiaEncontrada!['DatosIntelectual'] ?? '';
      _antecedentesSocioAfectivoController.text =
          _historiaEncontrada!['DatosSocioAfectivo'] ?? '';
      _estructuraFamiliarController.text =
          _historiaEncontrada!['estructuraFamiliar'] ?? '';
      _pruebasController.text = _historiaEncontrada!['pruebas'] ?? '';
      _impresionDiagnosticaController.text =
          _historiaEncontrada!['impresionDiagnostica'] ?? '';
      _areasIntervencionController.text =
          _historiaEncontrada!['areasIntervencion'] ?? '';
    }
  }

  // Método para guardar los cambios editados
  Future<void> _guardarCambios() async {
    if (_historiaEncontrada != null && _coleccionSeleccionada != null) {
      String? idDocumento = _historiaEncontrada!['idDocumento'];

      if (idDocumento == null || idDocumento.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID de documento no encontrado.')),
        );
        return;
      }

      // Mapa con los campos editados
      Map<String, dynamic> nuevosDatos = {
        'nombres': _nombreController.text,
        'fechaNacimiento': _fechaNacimientoController.text,
        'edad': _edadController.text,
        'curso': _cursoController.text,
        'institucion': _institucionController.text,
        'nombreMama': _nombreMamaController.text,
        'nombrePapa': _nombrePapaController.text,
        'direccion': _direccionController.text,
        'telefono': _telefonoController.text,
        'remision': _remisionController.text,
        'observaciones': _observacionesController.text,
        'fechaEvaluacion': _evaluationDateController.text,
        'cobertura': _coberturaController.text,
        'responsable': _responsableController.text,
        'motivoConsulta': _motivoConsultaController.text,
        'desencadenantes': _desencadenantesController.text,
        'antecedenteG': _antecedentesGController.text,
        'DatosEmbarazo': _antecedentesEmbarazoController.text,
        'DatosPsicomotor': _antecedentesPsicomotorController.text,
        'DatosLenguaje': _antecedentesLenguajeController.text,
        'DatosIntelectual': _antecedentesIntelectualController.text,
        'DatosSocioAfectivo': _antecedentesSocioAfectivoController.text,
        'estructuraFamiliar': _estructuraFamiliarController.text,
        'pruebas': _pruebasController.text,
        'impresionDiagnostica': _impresionDiagnosticaController.text,
        'areasIntervencion': _areasIntervencionController.text,
      };

      // Actualiza solo los campos modificados
      try {
        await FirebaseFirestore.instance
            .collection(
                _coleccionSeleccionada!) // Usa la colección seleccionada
            .doc(idDocumento)
            .update(nuevosDatos);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cambios guardados exitosamente')),
        );

        setState(() {
          _modoEdicion = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar cambios: $e')),
        );
      }
    }
  }

  // Método para alternar el modo de edición

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Historias Clínicas Psicologia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo para buscar por nombre del paciente
            _buildCampoConTitulo('Ingrese la cedula', _cedulaController,
                readOnly: false),
            const SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _buscarHistoriaPorNombre,
                  child: const Text('Buscar'),
                ),
                const SizedBox(width: 16.0),
                if (_modoEdicion) const SizedBox(width: 16.0),
                if (_modoEdicion)
                  ElevatedButton(
                    onPressed: _guardarCambios,
                    child: const Text('Guardar'),
                  ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: _busquedaRealizada
                    ? (_historiaEncontrada != null
                        ? _buildHistoriaVista(_historiaEncontrada!)
                        : const Text(
                            'No se ha encontrado ninguna historia clínica.'))
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampoConTitulo(String titulo, TextEditingController controller,
      {bool readOnly = true}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: titulo,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSeccionTitulo(String titulo) {
    return Text(
      titulo,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
    );
  }

  Widget _buildFechaNacimientoYEdad(String? fechaNacimiento, String? edad) {
    return Row(
      children: [
        Expanded(
          flex: 4, // Mayor tamaño para el campo de Fecha de Nacimiento
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Fecha de Nacimiento',
              fillColor: Colors.grey[300], // Color de fondo similar a la imagen
              filled: true, // Activa el color de fondo
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0), // Borde redondeado
              ),
            ),
            readOnly: true,
            controller: TextEditingController(text: fechaNacimiento),
          ),
        ),
        const SizedBox(width: 16.0), // Espacio entre los dos campos
        Expanded(
          flex: 1, // Menor tamaño para el campo de Edad
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Edad',
              fillColor: Colors.grey[300], // Color de fondo
              filled: true, // Activa el color de fondo
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0), // Borde redondeado
              ),
            ),
            enabled: false,
            controller: TextEditingController(text: edad ?? '0'),
          ),
        ),
      ],
    );
  }

  Widget _buildCampoConScroll(String titulo, TextEditingController controller,
      {bool readOnly = true}) {
    return Container(
      height: 150, // Ajusta la altura según lo que necesites
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        maxLines: null, // Permite múltiples líneas
        expands: true, // Hace que el campo use todo el espacio disponible
        decoration: InputDecoration(
          labelText: titulo,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 14,
          ),
          fillColor: Colors.grey[300],
          filled: readOnly,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        keyboardType: TextInputType
            .multiline, // Para que el teclado se adapte a texto largo
        textInputAction: TextInputAction.newline, // Permite saltos de línea
      ),
    );
  }

  // Construye la vista de la historia clínica encontrada
  Widget _buildHistoriaVista(Map<String, dynamic> historia) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey.shade400)],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          _buildSeccionTitulo('DATOS PERSONALES'),
          const Divider(),
          _buildCampoConTitulo(
              'Nombre completo del paciente', _nombreController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 10),
          _buildFechaNacimientoYEdad(
              _fechaNacimientoController.text, _edadController.text),
          const SizedBox(height: 10),
          _buildCampoConTitulo('Curso escolar Actual', _cursoController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 10),
          _buildCampoConTitulo('Institución', _institucionController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 10),
          _buildCampoConTitulo('Nombre de la mamá', _nombreMamaController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 10),
          _buildCampoConTitulo('Nombre del papá', _nombrePapaController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 10),
          _buildCampoConTitulo('Dirección', _direccionController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 10),
          _buildCampoConTitulo('Teléfono', _telefonoController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 10),
          _buildCampoConTitulo('Remisión', _remisionController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 10),
          _buildCampoConTitulo('Fecha de evaluación', _evaluationDateController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 10),
          _buildCampoConTitulo('Final de cobertura', _coberturaController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 10),
          _buildCampoConScroll('Observación', _observacionesController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 10),
          _buildCampoConTitulo('Responsable', _responsableController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 16.0),
          _buildSeccionTitulo('MOTIVO DE CONSULTA'),
          const Divider(),
          _buildCampoConScroll('Motivo de consulta', _motivoConsultaController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 16.0),
          _buildSeccionTitulo('DESENCADENANTES DE MOTIVO DE CONSULTA'),
          const Divider(),
          _buildCampoConScroll(
              'Desencadenante de Consulta', _desencadenantesController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 16.0),
          _buildSeccionTitulo('ANTECEDENTES FAMILIARES'),
          const Divider(),
          _buildCampoConScroll('SOLO SI ES ADULTO', _antecedentesGController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 16.0),
          _buildCampoConTitulo(
              'Datos de embarazo y parto', _antecedentesEmbarazoController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 10.0),
          _buildCampoConTitulo(
              'Datos Psicomotor', _antecedentesPsicomotorController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 10.0),
          _buildCampoConTitulo(
              'Desarrollo del lenguaje', _antecedentesLenguajeController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 10.0),
          _buildCampoConTitulo(
              'Desarrollo intelectual ', _antecedentesIntelectualController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 10.0),
          _buildCampoConTitulo(
              'Desarrollo socio-afectivo', _antecedentesSocioAfectivoController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 16.0),
          _buildSeccionTitulo('ANTECEDENTES Y ESTRUCTURA FAMILIAR'),
          const Divider(),
          _buildCampoConScroll(
              'Descripción de los antecedentes', _estructuraFamiliarController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 16.0),
          _buildSeccionTitulo('PRUEBAS APLICADAS'),
          const Divider(),
          _buildCampoConScroll('Descripción de las pruebas', _pruebasController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 16.0),
          _buildSeccionTitulo('IMPRESIÓN DIAGNÓSTICA'),
          const Divider(),
          _buildCampoConScroll(
              'Impresión diagnóstica', _impresionDiagnosticaController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 16.0),
          _buildSeccionTitulo('ÁREAS DE INTERVENCIÓN'),
          const Divider(),
          _buildCampoConScroll(
              'Descripción de las áreas', _areasIntervencionController,
              readOnly: !_modoEdicion),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _fechaNacimientoController.dispose();
    _edadController.dispose();
    _cursoController.dispose();
    _institucionController.dispose();
    _nombreMamaController.dispose();
    _nombrePapaController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _remisionController.dispose();
    _observacionesController.dispose();
    _evaluationDateController.dispose();
    _coberturaController.dispose();
    _responsableController.dispose();
    _motivoConsultaController.dispose();
    _desencadenantesController.dispose();
    _antecedentesGController.dispose();
    _antecedentesEmbarazoController.dispose();
    _antecedentesPsicomotorController.dispose();
    _antecedentesLenguajeController.dispose();
    _antecedentesIntelectualController.dispose();
    _antecedentesSocioAfectivoController.dispose();
    _estructuraFamiliarController.dispose();
    _pruebasController.dispose();
    _impresionDiagnosticaController.dispose();
    _areasIntervencionController.dispose();
    super.dispose();
  }
}
