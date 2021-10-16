
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vetpet/screen/petscreen.dart';
import 'package:vetpet/screen/teste.dart';

import 'package:vetpet/screen/vacinascreen.dart';

import 'listaavisos.dart';
import 'package:vetpet/database/dao/aviso_dao.dart';

const _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = true;

class HomePage extends StatefulWidget {
  const HomePage({key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int _selectedIndex = 3;
  late Future<void> _initializeFlutterFireFuture;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final   List<Widget> _widgetOptions = [
    PetScreen(),
    VacinaScreen("Vacinas"),
    AvisoScreen("Vacinas"),
    LocalNotificationScreen()
      ];
  Future<void> _testAsyncErrorOnInit() async {
    Future<void>.delayed(const Duration(seconds: 2), () {
      final List<int> list = <int>[];
      print(list[100]);
    });
  }
// Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize

    if (_kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FirebaseCrashlytics.instance
          .log('This is a log example _kTestingCrashlytics _initializeFlutterFire');
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    if (_kShouldTestAsyncErrorOnInit) {
      await _testAsyncErrorOnInit();
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeFlutterFireFuture = _initializeFlutterFire();
  }

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
