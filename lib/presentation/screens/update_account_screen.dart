import 'package:flutter/material.dart';
import 'dart:async';
import '../../app_router.dart';
import '../../constants/strings.dart';

class UpdateAccountScreen extends StatefulWidget {
  const UpdateAccountScreen({Key? key}) : super(key: key);
  @override
  State<UpdateAccountScreen> createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {



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
                Text(' بياناتي',
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
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('الاسم الكامل', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                            decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'ادخل اسمك هنا',
                        )),
                      ),
                    ],
                  ),
                
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('الايميل ', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                            decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'ادخل بريك الالكتروني هنا',
                        )),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('رقم الجوال ', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                            decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'ادخل رقم الجوال هنا',
                        )),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                 
                  
                    
                  
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
                            Text('حفظ',
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
                  )
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
