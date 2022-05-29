import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geminos_group/Helper/NotificationHelper.dart';
import 'package:geminos_group/Model/NotificationObject.dart';
import 'package:geminos_group/NotificationBadge.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geminos_group/Theme.dart';
import 'package:geminos_group/Widgets/SolidButton.dart';
import 'package:geminos_group/mixins/loading.dart';
import 'package:overlay_support/overlay_support.dart';

class HomePage extends StatefulWidget {
  const HomePage(this.user, {Key? key}) : super(key: key);

  final UserCredential user;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with LoadingStateMixin{
  late final FirebaseMessaging _messaging;
  late PushNotification _notificationInfo = PushNotification();
  String token = "";
  final fs = FirebaseFirestore.instance;



  @override
  void initState() {
    registerNotification();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
      });
    });

    checkForInitialMessage();
    super.initState();
  }

  Future<bool> addToken() async {
    await fs.collection("notifications").add({
      'email': widget.user.user!.email,
      'time': DateTime.now(),
      'token': token,
    });
    return true;
  }


  checkForInitialMessage() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
      });
    }
  }


  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  void registerNotification() async {
    await Firebase.initializeApp();

    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(message);
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          _notificationInfo = notification;
        });

        if (_notificationInfo != null) {
          showSimpleNotification(
            Text(_notificationInfo.title!, style: titleNormalBoldStyle.copyWith(fontSize: 16, fontStyle: FontStyle.italic)),
            leading: Image.asset('assets/images/logo_geminos.png', width: 80, height: 50,),
            subtitle: Text(_notificationInfo.body!,style: normalTextStyle.copyWith(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic)),
            background: Colors.white,
            duration: Duration(seconds: 4),
          );
        }

      });
    } else {
      print('User has not accepted permission');
    }

    _messaging.subscribeToTopic('all');
    token  = await _messaging.getToken() as String;
    addToken();

    print(token);
  }

  void showSnackBar(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white,),
      ),
      backgroundColor: Colors.black,
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: appTheme.accentColor,
        disabledTextColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }

  Future<bool> sendNotification() async {
    showSnackBar("Try test notification from firebase or Need to add server key to access this");
    await NotificationHelper().sendNotification(token, context).then((data)
    async {
      setState(()
      {
        showSnackBar("Notification Sent Successfully");
      });

    }).catchError((error)
    {
      print(error);
      // showSnackBar(error);
    });
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 200.0,
            color : appTheme.primaryColorDark,
          ),
          Column(
            children: <Widget>[
              AppBar(
                elevation: 0,
                title: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('My Home'),
                ),
                backgroundColor: appTheme.primaryColorDark,
              ),
              Container(
                height: 130,
                margin: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: borderColor),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      // spreadRadius: 5,
                      offset: Offset(-2, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  Row(
                        children: [
                          Container(
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                              image: widget.user.user!.photoURL!.isNotEmpty && widget.user.user!.photoURL != null ? DecorationImage(
                                  image: NetworkImage(widget.user.user!.photoURL.toString()),
                                  fit: BoxFit.contain
                              ) :  const DecorationImage(
                                  image: AssetImage('assets/images/seekmy_logo.png'),
                                  fit: BoxFit.contain
                              ),
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(padding: EdgeInsets.only(top: 16,bottom: 16 ),
                              child :  Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.user.user!.displayName!.isNotEmpty ? widget.user.user!.displayName.toString() : "-", maxLines: 1,
                              overflow: TextOverflow.ellipsis,style: normalTextStyle.copyWith(fontWeight: FontWeight.w500),),
                                  Text(widget.user.user!.email.toString().isNotEmpty ? widget.user.user!.email.toString() : "-", maxLines: 1,
                                      overflow: TextOverflow.ellipsis,style: normalStyle.copyWith(color: const Color(0xFF575757)),)

                                ],
                              ))
                        ],
                      )
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: GestureDetector(
                  onTap: (){
                    showSimpleNotification(
                      Text("In-App Notication", style: titleNormalBoldStyle.copyWith(fontSize: 16, fontStyle: FontStyle.italic),),
                      leading: Image.asset('assets/images/logo_geminos.png', width: 80, height: 50,),
                      subtitle: Text("In-App Notication sent successfully!", style: normalTextStyle.copyWith(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic),),
                      background: Colors.white,
                      duration: const Duration(seconds: 3),
                    );
                  },
                    child: SolidButton(title : "IN APP NOTIFICATION", loading: loading, width: MediaQuery.of(context).size.width/1.7, solid: true,onTap: (){},)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: GestureDetector(
                    onTap: (){
                      sendNotification();
                    },
                    child: SolidButton(title : "CLOUD NOTIFICATION", loading: loading, width: MediaQuery.of(context).size.width/1.7, solid: true,onTap: (){},)),
              )
            ],
          ),
        ],
      ),
    );
  }
}

