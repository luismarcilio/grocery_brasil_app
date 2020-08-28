import 'package:flutter/material.dart';
import 'package:grocery_brasil_app/screens/dashboard.dart';
import 'package:grocery_brasil_app/screens/loading.dart';
import 'package:grocery_brasil_app/screens/login_screen.dart';
import 'package:grocery_brasil_app/screens/register_screen.dart';
import 'package:grocery_brasil_app/services/authentication/userRepository.dart';
import 'package:grocery_brasil_app/styles/AppTheme.dart' as AppTheme;
import 'package:provider/provider.dart';

class InitialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserRepository.instance(),
      child: MaterialApp(
          theme: AppTheme.style,
          routes: {
            LoginScreen.route: (context) => LoginScreen(),
            RegisterScreen.route: (context) => RegisterScreen(),
            Dashboard.route: (context) => Dashboard()
          },
          home: Consumer(builder: (context, UserRepository user, _) {
            print('user.status: ${user.status}');
            switch (user.status) {
              case Status.Uninitialized:
                return Loading();
              case Status.Unauthenticated:
              case Status.Unverified:
                return LoginScreen();
              case Status.Authenticating:
                return loading;
              case Status.Authenticated:
                return Dashboard();
            }
            return Loading();
          })),
    );
  }

  Widget _app(BuildContext context) {
    return new MaterialApp(
      theme: AppTheme.style,
      initialRoute: Dashboard.route,
      routes: {
        LoginScreen.route: (context) => LoginScreen(),
        RegisterScreen.route: (context) => RegisterScreen(),
        Dashboard.route: (context) => Dashboard()
      },
    );
  }

  final _dashboard = MaterialApp(theme: AppTheme.style, home: Dashboard());
  final _loginScreen = MaterialApp(
    theme: AppTheme.style,
    home: LoginScreen(),
  );

  final loading = MaterialApp(theme: AppTheme.style, home: Loading());
}
