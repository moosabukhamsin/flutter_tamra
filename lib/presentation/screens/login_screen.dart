import 'package:flutter/material.dart';
import 'package:tamra/presentation/screens/verify_screen.dart';
import 'dart:async';
import '../../app_router.dart';
import '../../constants/strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final appRouter = new AppRouter();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/back_1.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 130,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo_1.png', width: 170),
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('من فضلك ادخل رقم جوالك',
                        style: TextStyle(
                          color: Color(0XFF6A6A6A),
                          fontSize: 20,
                        ))
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: TextField(
                              decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: '',
                          )),
                        ),
                      ),
                    )
                  ],
                ),
                // SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text('هل لديك حساب',
                //         style: TextStyle(
                //             color: Color(0XFF575757),
                //             fontSize: 20,
                //             ))
                //   ],
                // ),
                SizedBox(
                  height: 180,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_ios, size: 18),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyScreen()));
                      },
                      child: Text('التالي',
                          style: TextStyle(
                            color: Color(0XFF575757),
                            fontSize: 18,
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    // return new Timer(
    //     duration,route
    //    );
  }

  route() {
    // Navigator.push(context, MaterialPageRoute(
    //     builder: (context) => LoginScreen()
    //   )
    // );
  }
}
