import 'package:flutter/material.dart';
import 'dart:async';
import '../../app_router.dart';
import '../../constants/strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final appRouter = new AppRouter();
    return Column(
      children: [
        Text('datadddd ',style: TextStyle(color: Colors.white),),
        Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset('assets/images/logo_1.png', width: 180),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            color: Color(0XFF707070),
                            Icons.location_on_outlined,
                            size: 25.0,
                          ),
                          Text(
                            'التوصيل الى',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(children: [
                        Text('نجاة الشامسي للفواكه',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0XFF7C3425))),
                        Icon(
                          color: Color(0XFF1EB7CD),
                          Icons.keyboard_arrow_down,
                          size: 25.0,
                        )
                      ]),
                      Row(children: [
                        Icon(
                          color: Color(0XFF707070),
                          Icons.access_time,
                          size: 15.0,
                        ),
                        Text('4 ساعة')
                      ]),
                    ],
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Image.asset('assets/images/store1.png', width: 70),
                        SizedBox(width: 10),
                        Image.asset('assets/images/store2.png', width: 70),
                        SizedBox(width: 10),
                        Image.asset('assets/images/store3.png', width: 70),
                        SizedBox(width: 10),
                        Image.asset('assets/images/store4.png', width: 70),
                        SizedBox(width: 10),
                        Image.asset('assets/images/store5.png', width: 70),
                        SizedBox(width: 10),
                        Image.asset('assets/images/store6.png', width: 70),
                        SizedBox(width: 10),
                        Image.asset('assets/images/store2.png', width: 70),
                        SizedBox(width: 10),
                        Image.asset('assets/images/store3.png', width: 70),
                        SizedBox(width: 10),
                        Image.asset('assets/images/store4.png', width: 70),
                        SizedBox(width: 10),
                        Image.asset('assets/images/store5.png', width: 70),
                        SizedBox(width: 10),
                        Image.asset('assets/images/store6.png', width: 70),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                            decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: Icon(Icons.search),
                          hintText: 'البحث عن منتج',
                        )),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Color(0XFF7C3425),
                                width: 2.0,
                                style: BorderStyle.solid),
                            color: Color(0XFF7C3425),
                          ),
                          child: Row(children: [
                            Image.asset('assets/images/ic_cat_1.png', height: 30),
                            SizedBox(
                              width: 10,
                            ),
                            Text('فواكه',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                )),
                          ]),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Color(0XFFD1D1D1),
                                width: 1.0,
                                style: BorderStyle.solid),
                            color: Colors.white,
                          ),
                          child: Row(children: [
                            Image.asset('assets/images/ic_cat_2.png', height: 30),
                            SizedBox(
                              width: 10,
                            ),
                            Text('خضار',
                                style: TextStyle(
                                  color: Color(0XFF909090),
                                  fontSize: 18,
                                )),
                          ]),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Color(0XFFD1D1D1),
                                width: 1.0,
                                style: BorderStyle.solid),
                            color: Colors.white,
                          ),
                          child: Row(children: [
                            Image.asset('assets/images/ic_cat_3.png', height: 30),
                            SizedBox(
                              width: 10,
                            ),
                            Text('ورقيات',
                                style: TextStyle(
                                  color: Color(0XFF909090),
                                  fontSize: 18,
                                )),
                          ]),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Color(0XFFD1D1D1),
                                width: 1.0,
                                style: BorderStyle.solid),
                            color: Colors.white,
                          ),
                          child: Row(children: [
                            Image.asset('assets/images/ic_cat_4.png', height: 30),
                            SizedBox(
                              width: 10,
                            ),
                            Text('حمضيات',
                                style: TextStyle(
                                  color: Color(0XFF909090),
                                  fontSize: 18,
                                )),
                          ]),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Color(0XFFD1D1D1),
                                width: 1.0,
                                style: BorderStyle.solid),
                            color: Colors.white,
                          ),
                          child: Row(children: [
                            Image.asset('assets/images/ic_cat_5.png', height: 30),
                            SizedBox(
                              width: 10,
                            ),
                            Text('استوائة',
                                style: TextStyle(
                                  color: Color(0XFF909090),
                                  fontSize: 18,
                                )),
                          ]),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Color(0XFFD1D1D1),
                                width: 1.0,
                                style: BorderStyle.solid),
                            color: Colors.white,
                          ),
                          child: Row(children: [
                            Image.asset('assets/images/ic_cat_6.png', height: 30),
                            SizedBox(
                              width: 10,
                            ),
                            Text('محليه',
                                style: TextStyle(
                                  color: Color(0XFF909090),
                                  fontSize: 18,
                                )),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 15,bottom: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 0.5, style: BorderStyle.solid,color: Color(0XFF707070)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/pr_1.png', height: 90),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('تفاح',
                                              style: TextStyle(
                                                  color: Color(0XFF5B5B5B),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('9.54 رس',
                                              style: TextStyle(
                                                color: Color(0XFF5B5B5B),
                                                fontSize: 14,
                                              )),
                                          Text('20 كيلو',
                                              style: TextStyle(
                                                color: Color(0XFF5B5B5B),
                                                fontSize: 14,
                                              )),
                                        ],
                                      )
                                    ],
                                  )),
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
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(1),
                                            border: Border.all(
                                                color: Color(0XFFD1D1D1),
                                                width: 1.0,
                                                style: BorderStyle.solid),
                                            color: Colors.white,
                                          ),
                                          child: Text('1',
                                              style: TextStyle(
                                                  color: Color(0XFF5B5B5B),
                                                  fontSize: 20,
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
                              ))
                            ],
                          ),
                        ),
                        Container(
                          
                          padding: EdgeInsets.only(top: 15,bottom: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 0.5, style: BorderStyle.solid,color: Color(0XFF707070)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/pr_2.png', height: 90),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('توت',
                                              style: TextStyle(
                                                  color: Color(0XFF5B5B5B),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('8.25 رس',
                                              style: TextStyle(
                                                color: Color(0XFF5B5B5B),
                                                fontSize: 14,
                                              )),
                                          Text('20 كيلو',
                                              style: TextStyle(
                                                color: Color(0XFF5B5B5B),
                                                fontSize: 14,
                                              )),
                                        ],
                                      )
                                    ],
                                  )),
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
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(1),
                                            border: Border.all(
                                                color: Color(0XFFD1D1D1),
                                                width: 1.0,
                                                style: BorderStyle.solid),
                                            color: Colors.white,
                                          ),
                                          child: Text('1',
                                              style: TextStyle(
                                                  color: Color(0XFF5B5B5B),
                                                  fontSize: 20,
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
                              ))
                            ],
                          ),
                        ),
                        Container(
                          
                          padding: EdgeInsets.only(top: 15,bottom: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 0.5, style: BorderStyle.solid,color: Color(0XFF707070)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/pr_3.png', height: 90),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('مانجو',
                                              style: TextStyle(
                                                  color: Color(0XFF5B5B5B),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('9.54 رس',
                                              style: TextStyle(
                                                color: Color(0XFF5B5B5B),
                                                fontSize: 14,
                                              )),
                                          Text('20 كيلو',
                                              style: TextStyle(
                                                color: Color(0XFF5B5B5B),
                                                fontSize: 14,
                                              )),
                                        ],
                                      )
                                    ],
                                  )),
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
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(1),
                                            border: Border.all(
                                                color: Color(0XFFD1D1D1),
                                                width: 1.0,
                                                style: BorderStyle.solid),
                                            color: Colors.white,
                                          ),
                                          child: Text('1',
                                              style: TextStyle(
                                                  color: Color(0XFF5B5B5B),
                                                  fontSize: 20,
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
                              ))
                            ],
                          ),
                        ),
                        Container(
                          
                          padding: EdgeInsets.only(top: 15,bottom: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 0.5, style: BorderStyle.solid,color: Color(0XFF707070)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/pr_4.png', height: 90),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('عنب',
                                              style: TextStyle(
                                                  color: Color(0XFF5B5B5B),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('9.54 رس',
                                              style: TextStyle(
                                                color: Color(0XFF5B5B5B),
                                                fontSize: 14,
                                              )),
                                          Text('20 كيلو',
                                              style: TextStyle(
                                                color: Color(0XFF5B5B5B),
                                                fontSize: 14,
                                              )),
                                        ],
                                      )
                                    ],
                                  )),
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
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(1),
                                            border: Border.all(
                                                color: Color(0XFFD1D1D1),
                                                width: 1.0,
                                                style: BorderStyle.solid),
                                            color: Colors.white,
                                          ),
                                          child: Text('1',
                                              style: TextStyle(
                                                  color: Color(0XFF5B5B5B),
                                                  fontSize: 20,
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
                              ))
                            ],
                          ),
                        ),
                        Container(
                          
                          padding: EdgeInsets.only(top: 15,bottom: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 0.5, style: BorderStyle.solid,color: Color(0XFF707070)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/pr_5.png', height: 90),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('افوكاد',
                                              style: TextStyle(
                                                  color: Color(0XFF5B5B5B),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('9.54 رس',
                                              style: TextStyle(
                                                color: Color(0XFF5B5B5B),
                                                fontSize: 14,
                                              )),
                                          Text('20 كيلو',
                                              style: TextStyle(
                                                color: Color(0XFF5B5B5B),
                                                fontSize: 14,
                                              )),
                                        ],
                                      )
                                    ],
                                  )),
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
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(1),
                                            border: Border.all(
                                                color: Color(0XFFD1D1D1),
                                                width: 1.0,
                                                style: BorderStyle.solid),
                                            color: Colors.white,
                                          ),
                                          child: Text('1',
                                              style: TextStyle(
                                                  color: Color(0XFF5B5B5B),
                                                  fontSize: 20,
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
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
