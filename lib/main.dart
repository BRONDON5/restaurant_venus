import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'menu_page.dart'; // Page Menu
import 'panier_page.dart'; // Page Panier
import 'dashboard_page.dart'; // Page Tableau de bord (Dashboard)
import 'gestion_plateforme_page.dart' as gestion;

// Méthode pour configurer Firebase Messaging (notifications push)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // Initialisation de Firebase
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialisation Firebase
  FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler); // Gestion des notifications en arrière-plan
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false; // Gérer le mode sombre

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  // Méthode pour configurer Firebase Messaging (notifications push)
  void _setupFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Demander la permission de l'utilisateur
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('Permission de notification: ${settings.authorizationStatus}');

    // Gérer les notifications en premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message reçu en premier plan: ${message.notification?.title}');
      // Afficher une notification dans l'application ou gérer l'affichage
      if (message.notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${message.notification!.title}: ${message.notification!.body}'),
          ),
        );
      }
    });

    // Gérer les notifications lorsqu'elles sont ouvertes depuis une notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification ouverte: ${message.notification?.title}');
      // Ajouter des actions, par exemple, rediriger vers la page des commandes
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Venus',
      theme: _isDarkMode ? darkTheme : lightTheme, // Basculer entre les thèmes
      home: HomePage(
        toggleTheme:
            _toggleTheme, // Transmettre la fonction pour changer de thème
        isDarkMode: _isDarkMode, // Transmettre l'état du thème actuel
      ),
      routes: {
        '/menu': (context) => MenuPage(),
        '/panier': (context) => PanierPage(panier: []),
        '/dashboard': (context) => DashboardPage(),
        '/gestion_utilisateurs': (context) => gestion.UserManagementPage(),
      },
    );
  }
}

// Définir les thèmes clair et sombre
final lightTheme = ThemeData(
  primarySwatch: Colors.red,
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

final darkTheme = ThemeData(
  primarySwatch: Colors.red,
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

// HomePage et autres classes inchangées, elles restent comme dans ton code initial.

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  HomePage({required this.toggleTheme, required this.isDarkMode});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showForm = false;
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _toggleAuthMode(String mode) {
    setState(() {
      _isLogin = (mode == 'Connexion');
      _showForm = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/menu_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  Text(
                    'Bienvenue chez Restaurant Venus!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    _isLogin ? 'Connexion' : 'Inscription',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_showForm) _buildAuthForm(context),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    _toggleAuthMode('Connexion');
                  },
                  color: Colors.white,
                  tooltip: 'Connexion',
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.person_add),
                  onPressed: () {
                    _toggleAuthMode('Inscription');
                  },
                  color: Colors.white,
                  tooltip: 'Inscription',
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.pushNamed(context, '/panier');
                  },
                  color: Colors.white,
                  tooltip: 'Panier',
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.dashboard),
                  onPressed: () {
                    Navigator.pushNamed(context, '/dashboard');
                  },
                  color: Colors.white,
                  tooltip: 'Tableau de bord',
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(
                      widget.isDarkMode ? Icons.brightness_2 : Icons.wb_sunny),
                  onPressed: widget.toggleTheme, // Utiliser toggleTheme ici
                  color: Colors.white,
                  tooltip: 'Mode sombre',
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.pushNamed(context, '/gestion_utilisateurs');
                  },
                  color: Colors.white,
                  tooltip: 'Gestion des utilisateurs',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthForm(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(30),
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(66, 248, 92, 2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (!_isLogin)
              _buildTextField('Nom', Icons.person, _nameController),
            if (!_isLogin) SizedBox(height: 10),
            if (!_isLogin)
              _buildTextField('Prénom', Icons.person, _firstNameController),
            if (!_isLogin) SizedBox(height: 10),
            _buildTextField('Email', Icons.email, _emailController,
                isEmail: true),
            SizedBox(height: 10),
            _buildTextField('Mot de passe', Icons.lock, _passwordController,
                isPassword: true),
            if (!_isLogin) SizedBox(height: 10),
            if (!_isLogin)
              _buildTextField('Confirmer le mot de passe', Icons.lock,
                  _confirmPasswordController,
                  isPassword: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_isLogin) {
                    // Si connexion réussie, rediriger vers la page MenuPage
                    Navigator.pushNamed(context, '/menu');
                  } else {
                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("Les mots de passe ne correspondent pas."),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Inscription réussie!"),
                      ));
                      _nameController.clear();
                      _firstNameController.clear();
                      _emailController.clear();
                      _passwordController.clear();
                      _confirmPasswordController.clear();
                      setState(() {
                        _isLogin = true;
                        _showForm = false;
                      });
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Couleur du bouton
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(_isLogin ? 'Se connecter' : 'S’inscrire'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller,
      {bool isEmail = false, bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ ne peut pas être vide.';
        }
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Veuillez entrer un email valide.';
        }
        if (isPassword && value.length < 6) {
          return 'Le mot de passe doit comporter au moins 6 caractères.';
        }
        return null;
      },
    );
  }
}
