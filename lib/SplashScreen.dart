import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geminos_group/PhoneLogin.dart';
import 'Theme.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginWithPhone()));
    });
  }


  initScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/logo (2).png', width: 50, height: 50, ),
              SizedBox(width: 8,),
              Image.asset('assets/images/name.png', width: 140, height: 140, ),
              SizedBox(width: 100,),
              const Align(
                alignment: Alignment.centerRight,
                child: SpinKitThreeBounce(
                  color: Colors.white,
                  size: 20,
                ),
              ),

            ],
          ),
        ),
        backgroundColor: appTheme.primaryColorDark,

      ),
        backgroundColor: appTheme.canvasColor,
        key: _scaffoldKey,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage ('assets/images/wall.jpg',
              )
            ),
             ),
        ));
  }


}
