import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vetpet/screen/home.dart';
import 'database/dao/aviso_dao.dart';
import 'database/dao/notificacao_dao.dart';
import 'database/dao/pet_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:cron/cron.dart';
import 'dart:developer' as developer;
 main()  {

   //FirebaseApp defaultApp = Firebase.app();
   //print('Message data: ${defaultApp.options.appId.toString()}');

  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  final cron = Cron();
  cron.schedule(Schedule.parse('25 * * * *'), () async {
    developer.log('TESTE Schedule');
    NotificacaoDao.verificaNotificacao();
  });
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => PetDao(),
      ),
    ],
    child: MyApp(),
  ));
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

