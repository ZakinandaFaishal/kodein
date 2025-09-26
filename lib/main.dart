import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/caesar_cipher_screen.dart';
import 'screens/vigenere_cipher_screen.dart';
import 'screens/aes_screen.dart';
import 'screens/rsa_screen.dart';
import 'screens/super_encrypt_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KodeIn',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    CaesarCipherScreen(),
    VigenereCipherScreen(),
    AesScreen(),
    RsaScreen(),
    SuperEncryptScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KodeIn CryptoSuite'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.vpn_key_outlined),
            label: 'Caesar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.key),
            label: 'Vigenère',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'AES',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_person),
            label: 'RSA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Super',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}