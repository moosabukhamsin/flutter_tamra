import 'package:flutter/material.dart';
import 'dart:async';
import '../../app_router.dart';
import '../../constants/strings.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({Key? key}) : super(key: key);
  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

enum SingingCharacter { english, arabic }

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
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
                Text(' اختر اللغة',
                    style: TextStyle(
                      color: Color(0XFF3D3D3D),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ),
          body: Directionality(
            textDirection: TextDirection.ltr,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ListTile(
                    title: Text('English',
                        style: TextStyle(
                          color: Color(0XFF3D3D3D),
                          fontSize: 18,
                        )),
                    leading: Radio<SingingCharacter>(
                      value: SingingCharacter.english,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                  Divider(color: Color(0XFF707070),height:0.5,thickness: 0.5,),
                  ListTile(
                    title: const Text('العربية',
                        style: TextStyle(
                          color: Color(0XFF3D3D3D),
                          fontSize: 18,
                        )),
                    leading: Radio<SingingCharacter>(
                      value: SingingCharacter.arabic,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        setState(() {
                          _character = value;
                        });
                      },
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
