import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetpet/screen/home.dart';
import 'database/dao/aviso_dao.dart';
import 'database/dao/notificacao_dao.dart';
import 'database/dao/pet_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:cron/cron.dart';
import 'dart:developer' as developer;


main()  async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    final cron = Cron();
    cron.schedule(Schedule.parse('25 * * * *'), () async {
      NotificacaoDao.verificaNotificacao();
    });

    runApp( MyApp()  );

  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}


class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Init.instance.initialize(),
    builder: (context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return MaterialApp(home: Splash());
    } else {
        return  ScreenUtilInit(
            //sdesignSize: Size(360, 690),
      builder: () => MaterialApp(
      title: 'VetPet',
      theme: ThemeData(
        primaryColor: Colors.orange,
        accentColor: Colors.orange[700],
        colorScheme: ColorScheme.light(primary: Colors.orange,
        error: Colors.red,
        secondary: Colors.orange),
        bottomAppBarColor: Colors.orange,

        //highlightColor: Colors.grey[400],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.orange[400],

          textTheme: ButtonTextTheme.primary,
        ),
      //  textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.grey),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      home: HomePage(),
    ));}});
  }
}
class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor: lightMode
          ? Colors.black87
          : Color(0x042a49).withOpacity(1.0),
      body: Center(
          child: lightMode
              ? Image.asset('asset/images/_MG_9521.jpg')
              : Image.asset('asset/images/_MG_9521.jpg')),
    );
  }
}


class Init {
  Init._();
  static final instance = Init._();
  Future initialize() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    await Future.delayed(const Duration(seconds: 3));
  }
}

