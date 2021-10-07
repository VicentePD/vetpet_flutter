
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vetpet/screen/petscreen.dart';
import 'package:vetpet/screen/teste.dart';

import 'package:vetpet/screen/vacinascreen.dart';

import 'listaavisos.dart';
import 'package:vetpet/database/dao/aviso_dao.dart';


class HomePage extends StatefulWidget {
  const HomePage({key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int _selectedIndex = 3;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final   List<Widget> _widgetOptions = [
    PetScreen(),
    VacinaScreen("Vacinas"),
    AvisoScreen("Vacinas"),
    LocalNotificationScreen()
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
            backgroundColor:  Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Vacinas',
            backgroundColor:  Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            label: 'Alertas',
            backgroundColor:  Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Informações',
            backgroundColor:  Colors.orange,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellowAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
