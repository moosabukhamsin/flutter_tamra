import 'package:flutter/material.dart';
import 'dart:async';
import '../../app_router.dart';
import '../../constants/strings.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

enum SingingCharacter { english, arabic }

class _ContactScreenState extends State<ContactScreen> {
  SingingCharacter? _character = SingingCharacter.english;

  @override
  Widget build(BuildContext context) {
    final appRouter = new AppRouter();

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            //  shape:Border.n
            bottomOpacity: 0.0,
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            leadingWidth: 300,
            leading: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                Icon(
                  color: Color(0XFF575757),
                  Icons.arrow_back,
                  size: 30.0,
                ),
                SizedBox(width: 20),
                Text('تواصل معنا',
                    style: TextStyle(
                      color: Color(0XFF3D3D3D),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo_1.png', width: 200),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('info@tamra.sa',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0XFF3D3D3D))),
                    ],
                  ),
                   SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('00966543435252',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0XFF3D3D3D))),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/social.png', width: 300)
                    ],
                  ),
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0XFF888888),
                                minimumSize: const Size(110, 70),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                              onPressed: () {},
                              child: Image.asset('assets/images/con_tel.png', width: 40),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0XFF888888),
                                minimumSize: const Size(110, 70),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                              onPressed: () {},
                              child: Image.asset('assets/images/con_wat.png', width: 40),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0XFF888888),
                                minimumSize: const Size(110, 70),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                              onPressed: () {},
                              child: Image.asset('assets/images/con_let.png', width: 40),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
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
