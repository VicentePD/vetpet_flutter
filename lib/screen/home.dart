import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vetpet/screen/petscreen.dart';
import 'package:vetpet/screen/teste.dart';
import 'package:vetpet/screen/vacinascreen.dart';


class HomePage extends StatefulWidget {
  const HomePage({key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final   List<Widget> _widgetOptions = [
    PetScreen(),
    VacinaScreen("Vacinas"),
    PetScreen(),
    NewPageScreen("Favoritos")
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //appBar: AppBar(title: Text('VetPet')),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor:  Colors.amberAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Vacinas',
            backgroundColor:  Colors.amberAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            label: 'Alertas',
            backgroundColor:  Colors.amberAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Informações',
            backgroundColor:  Colors.amberAccent,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
