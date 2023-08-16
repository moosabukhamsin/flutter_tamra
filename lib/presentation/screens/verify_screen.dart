import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tamra/presentation/screens/add_address_screen.dart';
import '../../app_router.dart';
import '../../constants/strings.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  @override
  Widget build(BuildContext context) {
    final appRouter = new AppRouter();
    TextEditingController textEditingController = TextEditingController();
    StreamController<ErrorAnimationType>? errorController;
    return SafeArea(
      child: Scaffold(
        
        body: SingleChildScrollView(
          child: Directionality(
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
                      Text('ادخل كود التفعيل',
                          style: TextStyle(
                              color: Color(0XFF6A6A6A),
                              fontSize: 20,
                              fontFamily: 'IBMPlex'))
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
                            child: PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: TextStyle(
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                              length: 4,
                              obscureText: false,
                              blinkWhenObscuring: true,
                              animationType: AnimationType.fade,
                              validator: (v) {
                                if (v!.length < 3) {
                                  return "";
                                } else {
                                  return null;
                                }
                              },
                              pinTheme: PinTheme(
                                activeColor: Color(0XffBE6F47),
                                inactiveColor: Colors.grey,
                                shape: PinCodeFieldShape.underline,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 70,
                                fieldWidth: 70,
                                activeFillColor: Colors.white,
                                inactiveFillColor: Colors.white,
                                selectedFillColor: Colors.white,
                              ),
                              cursorColor: Colors.black,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              enableActiveFill: true,
                              errorAnimationController: errorController,
                              controller: textEditingController,
                              keyboardType: TextInputType.number,
                              boxShadows: const [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black12,
                                  blurRadius: 10,
                                )
                              ],
                              onCompleted: (v) {},
                              onChanged: (value) {},
                              beforeTextPaste: (text) {
                                debugPrint("Allowing to paste $text");
                                return true;
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('لم تستلم الكود بعد؟',
                          style: TextStyle(
                              color: Color(0XFF6A6A6A),
                              fontSize: 20,
                              fontFamily: 'IBMPlex'))
                    ],
                  ), 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('اعادة ارسال',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color(0XFF6A6A6A),
                              fontSize: 18,
                              fontFamily: 'IBMPlex'))
                    ],
                  ),
                  SizedBox(
                    height: 130,
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
                                builder: (context) => AddAddressScreen()));
                      },
                        child: Text('التالي',
                            style: TextStyle(
                                color: Color(0XFF6A6A6A),
                                fontSize: 18,
                                fontFamily: 'IBMPlex')),
                      )
                    ],
                  ),
                ],
              ),
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
