import 'package:flutter_tienda_real/pages/home.dart';
import 'package:flutter_tienda_real/pages/login.dart';
import 'package:flutter_tienda_real/pages/splash.dart';
import 'package:flutter_tienda_real/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/user_provider.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: UserProvider.initialize()),
    ChangeNotifierProvider.value(value: AppProvider())
  ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.deepOrange
        ),
        home: ScreensController(),
      )));
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch(user.status){
      case Status.Uninitialized:
        return Splash();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return Login();
      case Status.Authenticated:
        return HomePage();
      default: return Login();
    }
  }
}