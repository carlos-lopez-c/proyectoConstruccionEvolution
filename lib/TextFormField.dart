import 'package:flutter/material.dart';

class HistoriaT extends StatefulWidget {
  @override
  _HistoriaTState createState() => _HistoriaTState();
}

class _HistoriaTState extends State<HistoriaT> {
  String? _selectedValueLloro; // Para almacenar el valor de "Lloro al nacer"
  String? _selectedValueSufrimiento; // Para almacenar el valor de "Sufrimiento fetal"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulario Historia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Otra parte de tu formulario
            Divider(),

            // QUIERO LOS RADIO BUTTONS AQUI
            _buildRadioButtonGroup(
              "Lloro al nacer:",
              ["SI", "NO"],
              _selectedValueLloro,
              (value) {
                setState(() {
                  _selectedValueLloro = value;
                });
              },
            ),

            Divider(),

            _buildRadioButtonGroup(
              "Sufrimiento fetal:",
              ["SI", "NO"],
              _selectedValueSufrimiento,
              (value) {
                setState(() {
                  _selectedValueSufrimiento = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget de Radio Buttons
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
            runSpacing: 4.0, // Espacio vertical si se envuelven en una nueva línea
            children: options.map((option) {
              return Row(
                mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del Row al contenido
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
}
