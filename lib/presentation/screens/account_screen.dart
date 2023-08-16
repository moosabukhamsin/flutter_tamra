import 'package:flutter/material.dart';
import 'dart:async';
import '../../app_router.dart';
import '../../constants/strings.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo_1.png', width: 170),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset('assets/images/acc.png', width: 30,height: 30),
                      ),
                      SizedBox(width: 10,),
                      Text('حسابي',
                          style: TextStyle(
                              color: Color(0XFF3D3D3D),
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                              
                    ],
                  ),
                  Divider(color: Color(0XFF707070),height:0.7,thickness: 0.7,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset('assets/images/ord.png', width: 30,height: 30),
                      ),
                      SizedBox(width: 10,),
                      Text('طلباتي',
                          style: TextStyle(
                              color: Color(0XFF3D3D3D),
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                              
                    ],
                  ),
                  Divider(color: Color(0XFF707070),height:0.7,thickness: 0.7,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset('assets/images/lang.png', width: 30,height: 30),
                      ),
                      SizedBox(width: 10,),
                      Text('اللغة',
                          style: TextStyle(
                              color: Color(0XFF3D3D3D),
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                              
                    ],
                  ),
                  Divider(color: Color(0XFF707070),height:0.7,thickness: 0.7,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset('assets/images/addr.png', width: 30,height: 30),
                      ),
                      SizedBox(width: 10,),
                      Text('عناويني',
                          style: TextStyle(
                              color: Color(0XFF3D3D3D),
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                              
                    ],
                  ),
                  Divider(color: Color(0XFF707070),height:0.7,thickness: 0.7,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset('assets/images/poli.png', width: 30,height: 30),
                      ),
                      SizedBox(width: 10,),
                      Text('سياسة الخصوصية',
                          style: TextStyle(
                              color: Color(0XFF3D3D3D),
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                              
                    ],
                  ),
                  Divider(color: Color(0XFF707070),height:0.7,thickness: 0.7,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset('assets/images/prpoli.png', width: 30,height: 30),
                      ),
                      SizedBox(width: 10,),
                      Text('سياسة الاستخدام',
                          style: TextStyle(
                              color: Color(0XFF3D3D3D),
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                              
                    ],
                  ),
                  Divider(color: Color(0XFF707070),height:0.7,thickness: 0.7,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset('assets/images/cont.png', width: 30,height: 30),
                      ),
                      SizedBox(width: 10,),
                      Text('تواصل معنا',
                          style: TextStyle(
                              color: Color(0XFF3D3D3D),
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                              
                    ],
                  ),
                  Divider(color: Color(0XFF707070),height:0.7,thickness: 0.7,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset('assets/images/share.png', width: 30,height: 30),
                      ),
                      SizedBox(width: 10,),
                      Text('شارك التطبيق',
                          style: TextStyle(
                              color: Color(0XFF3D3D3D),
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                              
                    ],
                  ),
                  Divider(color: Color(0XFF707070),height:0.7,thickness: 0.7,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset('assets/images/log.png', width: 30,height: 30),
                      ),
                      SizedBox(width: 10,),
                      Text('تسجيل الخروج',
                          style: TextStyle(
                              color: Color(0XFF3D3D3D),
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                              
                    ],
                  ),
                  
                  
                  
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
