import 'package:flutter/material.dart';
import 'dart:async';
import '../../app_router.dart';
import '../../constants/strings.dart';

class ProvidersScreen extends StatefulWidget {
  const ProvidersScreen({Key? key}) : super(key: key);
  @override
  State<ProvidersScreen> createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
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
                      Text('الموردين',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Color(0XFF3D3D3D))),
                    ],
                  ),
                  SizedBox(height: 20,),
                  for (int i = 0; i < 10; i++)
                  Column(
                    children: [
                      Row(
                        children: [
                          for (int i = 0; i < 3 ; i++)
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Image.asset('assets/images/store1.png', height: 70),
                                Text('فاكهة الشربتلي',
                                    style: TextStyle(
                                        color: Color(0XFF5B5B5B),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                Text('489 منتج',
                                    style: TextStyle(
                                        color: Color(0XFF5B5B5B),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          ),
                          
                          
                        ],
                      ),
                      SizedBox(height: 20,)
                    ],
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
