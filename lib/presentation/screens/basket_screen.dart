import 'package:flutter/material.dart';
import 'dart:async';
import '../../app_router.dart';
import '../../constants/strings.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({Key? key}) : super(key: key);
  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  @override
  Widget build(BuildContext context) {
    final appRouter = new AppRouter();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('السلة',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Color(0XFF3D3D3D))),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      color: Color(0XFFF4F6F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(children: [
                      Row(
                        children: [
                          Text('نجاة الشامسي للفواكه فرع الاول',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0XFF7C3425))),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(' اسم العنوان ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0XFF3D3D3D))),
                        ],
                      ),
                      Row(
                        children: [
                          Text('نجاة الشامسي للفواكه فرع الاول',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0XFF3D3D3D))),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text('وصف العنوان',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0XFF3D3D3D))),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                              'الدمام - حي العنود - شارع الخليج - بعد بنك ساب,',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0XFF3D3D3D))),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.white,
                              primary: Color(0Xff7C3425),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 3),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('تغيير العنوان',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.white,
                              primary: Color(0XffA8A8A8),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 0),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('حذف',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Color(0Xff7C3425),
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(0),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add),
                          ],
                        ),
                      ),
                      Text('اضافة عنوان تسليم',
                          style: TextStyle(
                            color: Color(0XFF3D3D3D),
                            fontSize: 15,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text('الاصناف',
                          style: TextStyle(
                            color: Color(0XFF3D3D3D),
                            fontSize: 18,
                          )),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0XFFeeeeee),
                            ),
                            child: Row(
                              children: [
                                Image.asset('assets/images/add_icon.png',
                                    height: 45),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text('200 KG',
                                      style: TextStyle(
                                          color: Color(0XFF5B5B5B),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Image.asset('assets/images/min_icon.png',
                                    height: 45),
                              ],
                            ),
                          ),
                        ],
                      )),
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('تفاح اسباني ',
                                        style: TextStyle(
                                            color: Color(0XFF5B5B5B),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('2،540 رس',
                                        style: TextStyle(
                                          color: Color(0XFF5B5B5B),
                                          fontSize: 16,
                                        )),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0XFFeeeeee),
                            ),
                            child: Row(
                              children: [
                                Image.asset('assets/images/add_icon.png',
                                    height: 45),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text('150 KG',
                                      style: TextStyle(
                                          color: Color(0XFF5B5B5B),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Image.asset('assets/images/min_icon.png',
                                    height: 45),
                              ],
                            ),
                          ),
                        ],
                      )),
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('موز شربتلي ',
                                        style: TextStyle(
                                            color: Color(0XFF5B5B5B),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('3,540 رس',
                                        style: TextStyle(
                                          color: Color(0XFF5B5B5B),
                                          fontSize: 16,
                                        )),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text('التوصيل',
                              style: TextStyle(
                                  color: Color(0XFF5B5B5B),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600))),
                      Text('240 رس',
                          style: TextStyle(
                              color: Color(0XFF5B5B5B),
                              fontSize: 18,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text('الاجمالي',
                              style: TextStyle(
                                  color: Color(0XFF5B5B5B),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600))),
                      Text('850 رس',
                          style: TextStyle(
                              color: Color(0XFF5B5B5B),
                              fontSize: 18,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Color(0Xff7C3425),
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 80,
                            ),
                            Icon(
                              color: Colors.white,
                              Icons.arrow_back_ios,
                              size: 18.0,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('الدفع',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                )),
                            SizedBox(
                              width: 80,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
