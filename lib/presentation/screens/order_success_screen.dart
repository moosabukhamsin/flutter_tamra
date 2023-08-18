import 'package:flutter/material.dart';
import 'dart:async';
import '../../app_router.dart';
import '../../constants/strings.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({Key? key}) : super(key: key);
  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

enum SingingCharacter { english, arabic }

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
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
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(
                    color: Color(0XFF575757),
                    Icons.arrow_back,
                    size: 30.0,
                  ),
                ),
                SizedBox(width: 20),
                Text('حالة الطلب',
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
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 60),
                    decoration: BoxDecoration(
                      color: Color(0XFFF4F6F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Color(0XFF7C3425),
                              size: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('تم استلام الطلب',
                                style: TextStyle(
                                  color: Color(0XFF2E2E2E),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('سيتم تجهيز و توصيل طلبك في غضون 4 ساعات',
                        textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0XFF888888),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            )),
                           
                       
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Color(0XFFF4F6F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Color(0XFF6C7B8A),
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('نجاة الشامسي للفواكه فرع الاول',
                            style: TextStyle(
                              color: Color(0XFF7C3425),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text('الاصناف',
                          style: TextStyle(
                            color: Color(0XFF3D3D3D),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Divider(
                      color: Color(0XFF707070),
                      height: 0.7,
                      thickness: 0.7,
                    ),
                  ),
                  Row(
                    children: [
                      Text('تفاح اسباني ',
                          style: TextStyle(
                            color: Color(0XFF3D3D3D),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          )),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('200 كيلو ',
                            style: TextStyle(
                              color: Color(0XFF3D3D3D),
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            )),
                            Text('100 رس ',
                            style: TextStyle(
                              color: Color(0XFF3D3D3D),
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            )),
                              ],
                            ),
                          )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Divider(
                      color: Color(0XFF707070),
                      height: 0.7,
                      thickness: 0.7,
                    ),
                  ),
                  Row(
                    children: [
                      Text('موز شربتلي',
                          style: TextStyle(
                            color: Color(0XFF3D3D3D),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          )),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('300 كيلو ',
                            style: TextStyle(
                              color: Color(0XFF3D3D3D),
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            )),
                            Text('150 رس ',
                            style: TextStyle(
                              color: Color(0XFF3D3D3D),
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            )),
                              ],
                            ),
                          )
                    ],
                  ),
                   Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Divider(
                      color: Color(0XFF707070),
                      height: 0.7,
                      thickness: 0.7,
                    ),
                  ),
                  Row(
                    children: [
                      Text('التوصيل',
                          style: TextStyle(
                            color: Color(0XFF3D3D3D),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          )),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('80 رس',
                            style: TextStyle(
                              color: Color(0XFF3D3D3D),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            )),
                            
                              ],
                            ),
                          )
                    ],
                  ),
                  Row(
                    children: [
                      Text('الاجمالي',
                          style: TextStyle(
                            color: Color(0XFF3D3D3D),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          )),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('450 رس',
                            style: TextStyle(
                              color: Color(0XFF3D3D3D),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            )),
                            
                              ],
                            ),
                          )
                    ],
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
