import 'package:flutter/material.dart';
import 'package:tamra/presentation/screens/providers_screen.dart';
import 'dart:async';
import '../../app_router.dart';
import '../../constants/strings.dart';

class ProviderScreen extends StatefulWidget {
  const ProviderScreen({Key? key}) : super(key: key);
  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  List<int> numbers = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  int selected = 1;
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
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  color: Color(0XFF575757),
                  Icons.arrow_back,
                  size: 30.0,
                ),
              ),
              SizedBox(width: 20),
              Text('فاكهة الشربتلي',
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
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Image.asset('assets/images/store1.png', width: 100),
                    SizedBox(width: 10,),
                    Column(
                      children: [
                        Text('فواكه',
                            style: TextStyle(
                                color: Color(0XFF5B5B5B),
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                        Text('489 منتج',
                            style: TextStyle(
                                color: Color(0XFF5B5B5B),
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    SizedBox(width: 10),
                  ],
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
                      InkWell(
                        onTap: () {
                          setState(() {
                            selected = 1;
                          });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: selected == 1
                                    ? Color(0XFF7C3425)
                                    : Color(0XFFD1D1D1),
                                width: 2.0,
                                style: BorderStyle.solid),
                            color: selected == 1
                                ? Color(0XFF7C3425)
                                : Colors.white,
                          ),
                          child: Row(children: [
                            selected == 1
                                ? Image.asset(
                                    'assets/images/ic_cat_1_light.png',
                                    height: 30)
                                : Image.asset('assets/images/ic_cat_1.png',
                                    height: 30),
                            SizedBox(
                              width: 10,
                            ),
                            Text('فواكه',
                                style: TextStyle(
                                  color: selected == 1
                                      ? Colors.white
                                      : Color(0XFF909090),
                                  fontSize: 18,
                                )),
                          ]),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selected = 2;
                          });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: selected == 2
                                    ? Color(0XFF7C3425)
                                    : Color(0XFFD1D1D1),
                                width: 1.0,
                                style: BorderStyle.solid),
                            color: selected == 2
                                ? Color(0XFF7C3425)
                                : Colors.white,
                          ),
                          child: Row(children: [
                            selected == 2
                                ? Image.asset(
                                    'assets/images/ic_cat_2_light.png',
                                    height: 30)
                                : Image.asset('assets/images/ic_cat_2.png',
                                    height: 30),
                            SizedBox(
                              width: 10,
                            ),
                            Text('خضار',
                                style: TextStyle(
                                  color: selected == 2
                                      ? Colors.white
                                      : Color(0XFF909090),
                                  fontSize: 18,
                                )),
                          ]),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selected = 3;
                          });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: selected == 3
                                    ? Color(0XFF7C3425)
                                    : Color(0XFFD1D1D1),
                                width: 1.0,
                                style: BorderStyle.solid),
                            color: selected == 3
                                ? Color(0XFF7C3425)
                                : Colors.white,
                          ),
                          child: Row(children: [
                            selected == 3
                                ? Image.asset(
                                    'assets/images/ic_cat_3_light.png',
                                    height: 30)
                                : Image.asset('assets/images/ic_cat_3.png',
                                    height: 30),
                            SizedBox(
                              width: 10,
                            ),
                            Text('ورقيات',
                                style: TextStyle(
                                  color: selected == 3
                                      ? Colors.white
                                      : Color(0XFF909090),
                                  fontSize: 18,
                                )),
                          ]),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 3),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 3),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 3),
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
                        padding: EdgeInsets.only(top: 15, bottom: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                width: 0.5,
                                style: BorderStyle.solid,
                                color: Color(0XFF707070)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/pr_1.png',
                                        height: 90),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            numbers[0]++;
                                          });
                                        },
                                        child: Image.asset(
                                            'assets/images/add_icon.png',
                                            height: 45),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(1),
                                          border: Border.all(
                                              color: Color(0XFFD1D1D1),
                                              width: 1.0,
                                              style: BorderStyle.solid),
                                          color: Colors.white,
                                        ),
                                        child: Text(numbers[0].toString(),
                                            style: TextStyle(
                                                color: Color(0XFF5B5B5B),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            numbers[0] > 0
                                                ? numbers[0]--
                                                : null;
                                          });
                                        },
                                        child: Image.asset(
                                            'assets/images/min_icon.png',
                                            height: 45),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 15, bottom: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                width: 0.5,
                                style: BorderStyle.solid,
                                color: Color(0XFF707070)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/pr_2.png',
                                        height: 90),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          borderRadius:
                                              BorderRadius.circular(1),
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
                        padding: EdgeInsets.only(top: 15, bottom: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                width: 0.5,
                                style: BorderStyle.solid,
                                color: Color(0XFF707070)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/pr_3.png',
                                        height: 90),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          borderRadius:
                                              BorderRadius.circular(1),
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
                        padding: EdgeInsets.only(top: 15, bottom: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                width: 0.5,
                                style: BorderStyle.solid,
                                color: Color(0XFF707070)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/pr_4.png',
                                        height: 90),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          borderRadius:
                                              BorderRadius.circular(1),
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
                        padding: EdgeInsets.only(top: 15, bottom: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                width: 0.5,
                                style: BorderStyle.solid,
                                color: Color(0XFF707070)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/pr_5.png',
                                        height: 90),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          borderRadius:
                                              BorderRadius.circular(1),
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
    );
  }
}
