import 'package:flutter/material.dart';
import 'package:tamra/presentation/screens/home_screen.dart';
import 'package:tamra/presentation/screens/layout_screen.dart';
import 'dart:async';
import '../../app_router.dart';
import '../../constants/strings.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({Key? key}) : super(key: key);
  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

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
                Text('عنوان جديد',
                    style: TextStyle(
                      color: Color(0XFF3D3D3D),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color(0XFF7C3425),
            selectedLabelStyle:
                TextStyle(color: Color(0XFF7C3425), fontSize: 15),
            unselectedItemColor: Color(0XFF707070),
            unselectedLabelStyle:
                TextStyle(color: Color(0XFF707070), fontSize: 15),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'السلة',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.store),
                label: 'الموردين',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.manage_accounts),
                label: 'حسابي',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
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
                      Text('اسم العنوان', style: TextStyle(fontSize: 18)),
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
                          hintText: 'نجاة الشامسي للفواكه فرع الاول',
                        )),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text('وصف العنوان', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                            minLines: 4,
                            maxLines: 5,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintText:
                                  'الدمام - حي العنود - شارع الخليج - بعد بنك ساب',
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
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
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              color: Colors.white,
                              Icons.location_on_outlined,
                              size: 25.0,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('العنوان على الخريطة',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 150),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LayoutScreen()));
                        },
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
