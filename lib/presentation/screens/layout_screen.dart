import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tamra/presentation/screens/Providers_screen.dart';
import 'package:tamra/presentation/screens/account_screen.dart';
import 'package:tamra/presentation/screens/basket_screen.dart';
import 'package:tamra/presentation/screens/home_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/app_colors.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);
  @override
  State<LayoutScreen> createState() => _LayoutScreenState();

  // Helper method to access the state from child widgets
  static _LayoutScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<_LayoutScreenState>();
  }
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;
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

  // Method to navigate to home screen (for external access)
  void navigateToHome() {
    _onItemTapped(0);
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.background,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            selectedLabelStyle:
                TextStyle(color: AppColors.primary, fontSize: 15, fontFamily: 'IBMPlex'),
            unselectedItemColor: AppColors.textSecondary,
            unselectedLabelStyle:
                TextStyle(color: AppColors.textSecondary, fontSize: 15, fontFamily: 'IBMPlex'),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: AppLocalizations.of(context)?.home ?? 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: AppLocalizations.of(context)?.basket ?? 'السلة',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.store),
                label: AppLocalizations.of(context)?.providers ?? 'الموردين',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.manage_accounts),
                label: AppLocalizations.of(context)?.myAccount ?? 'حسابي',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
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
