import 'package:flutter/material.dart';
import 'package:tamra/presentation/screens/login_screen.dart';
import 'dart:async';
import '../../app_router.dart';
import '../../constants/strings.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = new AppRouter();
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/intro_back.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Image.asset('assets/images/logo_white.png', width: 170),
      ),
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 2);
    return new Timer(
        duration,route
       );
  }

  route() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => LoginScreen()
      )
    );
  }
}
