import 'package:flutter/material.dart';
import 'dart:async';
import '../../app_router.dart';
import '../../constants/strings.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

enum SingingCharacter { english, arabic }

class _OrdersScreenState extends State<OrdersScreen> {
  SingingCharacter? _character = SingingCharacter.english;

  @override
  Widget build(BuildContext context) {
    final appRouter = new AppRouter();

    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
            // resizeToAvoidBottomInset: false,
            appBar: AppBar(
              //  shape:Border.n
              // bottomOpacity: 0.0,
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
                  Text('طلباتي',
                      style: TextStyle(
                        color: Color(0XFF3D3D3D),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
              bottom: const TabBar(
                indicatorColor: Color(0XFF707070),
                tabs: [
                  Tab(
                    icon: Text('حالية',
                        style: TextStyle(
                          color: Color(0XFF3D3D3D),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                  Tab(
                    icon: Text('ملغية',
                        style: TextStyle(
                          color: Color(0XFF3D3D3D),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                  Tab(
                    icon: Text('تم التسليم',
                        style: TextStyle(
                          color: Color(0XFF3D3D3D),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                      children: [
                        SizedBox(height: 15,),
                        for (int i = 0; i < 10; i++)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text('#159651',
                                      style: TextStyle(
                                        color: Color(0XFF3D3D3D),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('تم الدفع',
                                      style: TextStyle(
                                        color: Color(0XFF3D3D3D),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text('25 sep 2023',
                                      style: TextStyle(
                                        color: Color(0XFF3D3D3D),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      onPrimary: Colors.white,
                                      primary: Color(0Xff7C3425),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('تفاصيل',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Divider(
                                color: Color(0XFF707070),
                                height: 0.7,
                                thickness: 0.7,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Icon(Icons.add),
                Icon(Icons.add),
              ],
            )),
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
