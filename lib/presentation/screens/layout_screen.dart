import 'package:flutter/material.dart';
import 'package:tamra/presentation/screens/Providers_screen.dart';
import 'package:tamra/presentation/screens/account_screen.dart';
import 'package:tamra/presentation/screens/basket_screen.dart';
import 'package:tamra/presentation/screens/home_screen.dart';
import 'dart:async';
import '../../app_router.dart';
import '../../constants/strings.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);
  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 1;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    BasketScreen(),
    ProvidersScreen(),
    AccountScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    final appRouter = new AppRouter();
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
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
          body: _widgetOptions.elementAt(_selectedIndex)
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
