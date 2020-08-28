import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_brasil_app/services/authentication/userRepository.dart';
import 'package:provider/provider.dart';
import 'common/registration_widgets.dart';

class RegisterScreen extends StatefulWidget {
  static const route = '/register';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        color: Color(0xffFDF7C5),
        child: Scaffold(
            body: MediaQuery.of(context).size.width > 800
                ? horizontalListView()
                : verticalListView()),
      ),
    );
  }

  Widget horizontalListView() {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        ListView(
          children: [
            loginTextField(emailController),
            passwordTextField(passwordController),
            _registerButton()
          ],
        ),
        SvgPicture.asset(
          'images/groceries.svg',
          height: 100,
          width: 100,
        ),
      ],
    );
  }

  ListView verticalListView() {
    return ListView(
      children: [
        SvgPicture.asset(
          'images/groceries.svg',
          height: 100,
          width: 100,
        ),
        loginTextField(emailController),
        passwordTextField(passwordController),
        _registerButton()
      ],
    );
  }

  Widget _registerButton() {
    return getFlatButton(
        icon: FontAwesomeIcons.registered,
        text: "Register",
        color: Color(0xff5BC0EB),
        onPressed: () async {
          await Provider.of<UserRepository>(context, listen: false).register(
              email: emailController.text.trim(),
              password: passwordController.text);
          Navigator.of(context).pop();
        });
  }
}
