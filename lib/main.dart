import 'package:flutter/material.dart';
import 'app_router.dart';
void main() {
  runApp( MyApp(
    appRouter: AppRouter(),
  ));
}



class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({super.key,required this.appRouter});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'IBMPlex'),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
    );

  }
}