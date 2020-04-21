import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stockslog/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("fa", "IR"), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      locale: Locale("fa", "IR"),
      // OR Locale('ar', 'AE') OR Other RTL locales,
      theme: ThemeData(
          fontFamily: 'vazir',
          primaryColor: Colors.orange,
          accentColor: Colors.deepOrangeAccent,
          backgroundColor: Colors.orange.shade100
      ),
      home: HomePage(),
    );
  }
}