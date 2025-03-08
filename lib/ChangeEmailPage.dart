import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangeEmailPage extends StatefulWidget {
  @override
  _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _ConfnewEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false; // Variable para controlar la visibilidad

Future<bool> _verifyPassword() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    String password = _passwordController.text.trim();

    AuthCredential credential = EmailAuthProvider.credential(
      email: user!.email!,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);
    return true; // Contraseña correcta
  } on FirebaseAuthException catch (e) {
    if (e.code == 'wrong-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contraseña incorrecta.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al verificar la contraseña: ${e.message}')),
      );
    }
    return false; // Contraseña incorrecta
  }
}


 Future<void> _changeEmail() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    bool isPasswordCorrect = await _verifyPassword(); // Verificar la contraseña

    if (!isPasswordCorrect) {
      setState(() {
        _isLoading = false;
      });
      return; // No continuar si la contraseña es incorrecta
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      String newEmail = _newEmailController.text.trim();
      String confEmail = _ConfnewEmailController.text.trim();

      if (newEmail != confEmail) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Los correos electrónicos no coinciden.')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      await user!.verifyBeforeUpdateEmail(newEmail);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Se ha enviado un correo de verificación al nuevo correo.')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


  @override
  void dispose() {
    _ConfnewEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cambiar Correo Electrónico'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _newEmailController,
                        decoration: InputDecoration(
                          labelText: 'Nuevo Correo Electrónico',
                          border: OutlineInputBorder(),
                        ),
                                                
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa un correo electrónico.';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Por favor, ingresa un correo electrónico válido.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _ConfnewEmailController,
                        decoration: InputDecoration(
                          labelText: 'Confimación del nuevo Correo Electrónico',
                          border: OutlineInputBorder(),
                        ),
                                                
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa un correo electrónico.';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Por favor, ingresa un correo electrónico válido.';
                          }
                          return null;
                        },
                      ),


                      const SizedBox(height: 20),
                      TextFormField(
  controller: _passwordController,
  decoration: InputDecoration(
    labelText: 'Contraseña Actual',
    border: OutlineInputBorder(),
    suffixIcon: IconButton(
      icon: Icon(
        _passwordVisible ? Icons.visibility : Icons.visibility_off,
      ),
      onPressed: () {
        setState(() {
          _passwordVisible = !_passwordVisible; // Cambia el estado
        });
      },
    ),
  ),
  obscureText: !_passwordVisible, // Oculta o muestra la contraseña
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa tu contraseña actual.';
    }
    if (value.length < 12) {
      return 'La contraseña debe tener al menos 12 caracteres.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Debe contener al menos una letra mayúscula.';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Debe contener al menos una letra minúscula.';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Debe contener al menos un número.';
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Debe contener al menos un carácter especial (!@#\$%^&*...).';
    }
    return null; // Si pasa todas las validaciones, no hay error
  },
),                      
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _changeEmail,
                        child: Text('Actualizar Correo'),
                      ),
                    ],
                  ),
                ),
        ));
  }
}
