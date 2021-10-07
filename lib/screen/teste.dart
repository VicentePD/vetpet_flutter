import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetpet/database/dao/aviso_dao.dart';
import 'package:vetpet/database/dao/notificacao_dao.dart';

import 'package:vetpet/helpers/NotificacaoPlugin.dart';
import 'package:vetpet/screen/petscreen.dart';

class LocalNotificationScreen extends StatefulWidget {
  @override
  _LocalNotificationScreenState createState() =>
      _LocalNotificationScreenState();
}

class _LocalNotificationScreenState extends State<LocalNotificationScreen> {
  //

  int count = 0;

  @override
  void initState() {
    super.initState();
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
  }

  @override
  Widget build(BuildContext context) {
    printScreenInformation();
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
      ),
      body:  Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("asset/images/_MG_9521.jpg"),
              fit: BoxFit.cover,)),
          child: ListView( padding: const EdgeInsets.all(8),
              children: <Widget>[Text('  Atenção',
                                        style: TextStyle(
                                                fontSize: ScreenUtil().setSp(24),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange,),
                                      ),Text('      O aplicativo não salva as informações fora do dispositivo.',
                  style: TextStyle(
                    color: Colors.orange,
                  )),
                                    Column(
        children: [Row(children:[]),Text('Device width:${ScreenUtil().screenWidth}dp',
            style: TextStyle(  color: Colors.orange, )
        ),
        Text('Device height:${ScreenUtil().screenHeight}dp',
            style: TextStyle(  color: Colors.orange, )),
        Text('Device pixel density:${ScreenUtil().pixelRatio}',
            style: TextStyle(  color: Colors.orange, )),
        Text('Bottom safe zone distance:${ScreenUtil().bottomBarHeight}dp',
            style: TextStyle(  color: Colors.orange, )),
        Text('Status bar height:${ScreenUtil().statusBarHeight}dp',
            style: TextStyle(  color: Colors.orange, )),
        Text(
          'The ratio of actual width to UI design:${ScreenUtil().scaleWidth}',
          textAlign: TextAlign.center,
            style: TextStyle(  color: Colors.orange, )
        ),
        Text(
          'The ratio of actual height to UI design:${ScreenUtil().scaleHeight}',
          textAlign: TextAlign.center,
            style: TextStyle(  color: Colors.orange, )
        ),
        SizedBox(
          height: 10.h,
        ),
        Text('System font scaling factor:${ScreenUtil().textScaleFactor}',
            style: TextStyle(  color: Colors.orange, )),
        SizedBox(height: 5),
        Text(
          '16sp, will not change with the system.',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 16.sp,
          ),
          textScaleFactor: 1.0,
        ),
        Text(
          '16sp,if data is not set in MediaQuery,my font size will change with the system.',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 16.sp,
          ),
        ),
          Row(children: [FlatButton(
          onPressed: () async {
            NotificacaoDao.verificaNotificacao();
            await notificationPlugin.getPendingNotificationCount();
            //  await notificationPlugin.scheduleNotification();
            //await notificationPlugin.showNotificationWithAttachment();
            // await notificationPlugin.repeatNotification();
            //await notificationPlugin.showDailyAtTime();
            // await notificationPlugin.showWeeklyAtDayTime();
            // count = await notificationPlugin.getPendingNotificationCount();
            // print('Count $count');
            // await notificationPlugin.cancelNotification();
            // count = await notificationPlugin.getPendingNotificationCount();
            // print('Count $count');
          },
          child: Text('Send Notification'),
        )]),Row(children:[FlatButton(
          onPressed: () async {

            await notificationPlugin.getPendingNotificationCount();
          },
          child: Text('Qtd Notification'),
        ),]),Row(children:[FlatButton(
    onPressed: () async {

    await notificationPlugin.cancelAllNotification();
    },
    child: Text('cancela todas Notification'),
    ),]) ],)])

      ));
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
    Navigator.push(context, MaterialPageRoute(builder: (coontext) {
      return PetScreen(  );
    }));
  }
  void printScreenInformation() {
    print('Device width dp:${1.sw}dp');
    print('Device height dp:${1.sh}dp');
    print('Device pixel density:${ScreenUtil().pixelRatio}');
    print('Bottom safe zone distance dp:${ScreenUtil().bottomBarHeight}dp');
    print('Status bar height dp:${ScreenUtil().statusBarHeight}dp');
    print('The ratio of actual width to UI design:${ScreenUtil().scaleWidth}');
    print(
        'The ratio of actual height to UI design:${ScreenUtil().scaleHeight}');
    print('System font scaling:${ScreenUtil().textScaleFactor}');
    print('0.5 times the screen width:${0.5.sw}dp');
    print('0.5 times the screen height:${0.5.sh}dp');
    print('Screen orientation:${ScreenUtil().orientation}');
  }
}
