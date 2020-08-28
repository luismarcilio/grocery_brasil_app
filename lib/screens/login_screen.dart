import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_brasil_app/services/authentication/userRepository.dart';
import 'package:provider/provider.dart';

import 'common/dialog.dart';
import 'common/registration_widgets.dart';

class LoginScreen extends StatefulWidget {
  static const route = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget _loginWithFacebook() {
    return getFlatButton(
        icon: FontAwesomeIcons.facebookSquare,
        text: "Entre com Facebook",
        color: Color(0xff263C68),
        onPressed: () => Provider.of<UserRepository>(context, listen: false)
            .signInWithFacebook());
  }

  Widget _loginWithGoogle() {
    return getFlatButton(
      icon: FontAwesomeIcons.google,
      text: "Entre com Google",
      color: Color(0xffEA4335),
      onPressed: () => Provider.of<UserRepository>(context, listen: false)
          .signInWithGoogle(),
    );
  }

  Widget _loginButton() {
    return getFlatButton(
        icon: FontAwesomeIcons.doorOpen,
        text: "Login",
        color: Color(0xff5BC0EB),
        onPressed: () async {
          try {
            UserCredential userCredential =
                await Provider.of<UserRepository>(context, listen: false)
                    .signInWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text);

            if (!userCredential.user.emailVerified) {
              dialog(
                  context: context,
                  title: "Atenção",
                  text:
                      "Por favor verifique seu email em sua caixa de mensagens: ${userCredential.user.email}",
                  actions: List.from([
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Ok"))
                  ]));
            }
          } catch (e) {
            throw e;
            dialog(
                context: context,
                title: "Error",
                text: e.toString(),
                actions: List.from([
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Ok"))
                ]));
          }
        });
  }

  Widget _registerButton() {
    return getFlatButton(
        icon: Icons.add_box,
        text: "ou Registre-se",
        color: Colors.blue,
        onPressed: () => Navigator.pushNamed(context, '/register'));
  }

  @override
  Widget build(BuildContext context) {
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
            _loginButton(),
            getDefaultContainer(
                child: Divider(
              color: Colors.black,
            )),
            _loginWithFacebook(),
            _loginWithGoogle(),
            getDefaultContainer(
                child: Divider(
              color: Colors.black,
            )),
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
        _loginButton(),
        getDefaultContainer(
            child: Divider(
          color: Colors.black,
        )),
        _loginWithFacebook(),
        _loginWithGoogle(),
        getDefaultContainer(
            child: Divider(
          color: Colors.black,
        )),
        _registerButton()
      ],
    );
  }
}
