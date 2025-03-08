import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hc_ps_bueno/BuscarHistoriaPsTR.dart';
import 'package:hc_ps_bueno/SearchHistoriaPage.dart';
import 'package:hc_ps_bueno/SearchHistoriaTP.dart';
import 'package:hc_ps_bueno/firebase_options.dart';

import 'Historia.dart';
import 'HistoriaAdult.dart';
import 'HistoriaT.dart';
import 'LoginPage.dart';
import 'BuscarHistoriaPs.dart';
import 'ChangeEmailPage.dart';
import 'ChangePasswordPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

// Clase principal que recibe el rol del usuario
class MyHomePage extends StatelessWidget {
  final String userRol;

  // Constructor que recibe el rol del usuario
  MyHomePage({required this.userRol});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _calculateTabLength(
          userRol), // Determina la cantidad de pestañas según el rol
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          bottom: TabBar(
            indicatorColor: Color.fromARGB(213, 56, 123, 232),
            tabs: _buildTabs(userRol), // Construir pestañas según el rol
          ),
        ),
        body: TabBarView(
          children: _buildTabViews(
              userRol), // Construir el contenido de las pestañas según el rol
        ),
      ),
    );
  }

  // Función que calcula la cantidad de pestañas según el rol
  int _calculateTabLength(String userRol) {
    int length = 2; // Incluye 'Inicio' y 'Cerrar sesión'
    if (userRol == 'Psicología') length++;
    if (userRol == 'Terapia' || userRol == 'admin') length++;
    return length;
  }

  // Función que retorna las pestañas según el rol
  List<Widget> _buildTabs(String userRol) {
    List<Widget> tabs = [
      Tab(icon: Icon(Icons.home), text: 'Inicio'),
    ];

    if (userRol == 'Psicología') {
      tabs.add(Tab(icon: Icon(Icons.psychology), text: 'Psicología'));
    }

    if (userRol == 'Terapia' || userRol == 'admin') {
      tabs.add(Tab(icon: Icon(Icons.healing), text: 'Terapia'));
    }

    tabs.add(Tab(icon: Icon(Icons.logout), text: 'Cerrar sesión'));
    return tabs;
  }

  // Función que retorna el contenido de las pestañas según el rol
  List<Widget> _buildTabViews(String userRol) {
    List<Widget> tabViews = [
      InicioTab(),
    ];

    if (userRol == 'Psicología') {
      tabViews.add(PsicologiaTab());
    }

    if (userRol == 'Terapia' || userRol == 'admin') {
      tabViews.add(TerapiaTab());
    }

    tabViews.add(CerrarSesionTab());
    return tabViews;
  }
}

// Nueva clase para la pestaña de cerrar sesión
class CerrarSesionTab extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // Se cierra la sesión inmediatamente al seleccionar la pestaña
    Future.delayed(Duration.zero, () async {
      try {
        await _auth.signOut();
        print('Sesión cerrada correctamente');

        // Redirigir a la página de inicio de sesión
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        print('Error al cerrar sesión: $e');
      }
    });

    // Mientras se redirige, muestra un indicador de progreso
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

// Pestaña de Terapias
class TerapiaTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 50),
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
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
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
                      'Historias clínicas área de Terapias',
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
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoriaT()),
                  );
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/imagenes/historia-clinica.png',
                      width: 140,
                      height: 150,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Historia Clínica General',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 30),
            ],
          ),
          SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchHistoriaPage()),
                  );
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/imagenes/buscar.png',
                      width: 140,
                      height: 150,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Buscar Terapia Psicologica',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BuscarHistoriaPsTR()),
                  );
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/imagenes/buscar.png',
                      width: 140,
                      height: 150,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Buscar HC psicologia',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 30),
            ],
          ),
        ],
      ),
    );
  }
}

// Pestaña de Psicología
class PsicologiaTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 100),
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
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
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
                    Text(
                      'Acuerdo Ministerial 078-08',
                      style: TextStyle(fontSize: 17, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Historias clínicas área de psicológica',
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
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Historia()),
                  );
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/imagenes/nino.png',
                      width: 140,
                      height: 150,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Historia Clínica de niños',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoriaAdult()),
                  );
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/imagenes/adult.png',
                      width: 140,
                      height: 150,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Historia Clínica de adultos',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 35),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BuscarHistoriaPs()),
                  );
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/imagenes/buscar.png',
                      width: 140,
                      height: 150,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Buscar Historia Clinica',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 40),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchHistoriaPageTP()),
                  );
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/imagenes/buscar.png',
                      width: 140,
                      height: 150,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Buscar Terapia Psicologica',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
}

class InicioTab extends StatefulWidget {
  @override
  _InicioTabState createState() => _InicioTabState();
}

class _InicioTabState extends State<InicioTab> {
  String fullName = 'Usuario';

  @override
  void initState() {
    super.initState();
    _getUserFullName();
  }

  Future<void> _getUserFullName() async {
    // Obtén el ID del usuario autenticado
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      // Accede a Firestore y obtén los datos del usuario
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          fullName = userDoc.data()?['full_name'] ??
              'Usuario'; // Actualiza el nombre si existe
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Center(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Fundación ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '"UNA MIRADA FELIZ"',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bienvenida con el nombre del usuario
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bienvenido/a ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangeEmailPage()),
                      );
                    },
                    child: Text('Cambiar correo'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePasswordPage()),
                      );
                    },
                    child: Text('Cambiar contraseña'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Imagen del ángel
              Image.asset(
                'assets/imagenes/san-miguel.png', // Ruta de la imagen
                width: 350,
                height: 350,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Pie de página con el crédito de desarrollo
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '© Desarrollado por ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'Carlos Eduardo López Candelejo',
              style: TextStyle(
                fontSize: 13,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
