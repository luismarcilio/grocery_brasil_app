import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_brasil_app/features/register/presentation/pages/register.dart';

import '../../../../core/widgets/registration_widgets.dart';
import '../../../../injection_container.dart';
import '../../../../screens/common/loading.dart';
import '../../../../screens/dashboard.dart';
import '../bloc/login_bloc.dart';

class Login extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: buildBody(context),
      ),
    );
  }

  BlocProvider<LoginBloc> buildBody(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<LoginBloc>(),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            print('state: $state');
            if (state is LoginDone) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Dashboard(),
                ),
              );
            } else if (state is LoginError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failure.message),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is LoginRunning) {
              return Loading();
            }
            //state is LogoutDone or LoginInitial
            return verticalListView(context);
          },
        ));
  }

  Widget verticalListView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 0.0),
      child: ListView(
        children: [
          SvgPicture.asset(
            'images/groceries.svg',
            height: 100,
            width: 100,
          ),
          _loginWithFacebook(context),
          _loginWithGoogle(context),
          getDefaultContainer(
              child: Divider(
            color: Colors.black,
          )),
          getFlatButton(
              color: Colors.grey,
              icon: FontAwesomeIcons.envelope,
              text: "Entre com email e password",
              onPressed: null),
          loginTextField(emailController),
          passwordTextField(passwordController),
          _loginButton(context),
          getDefaultContainer(
              child: Divider(
            color: Colors.black,
          )),
          _registerButton(context)
        ],
      ),
    );
  }

  Widget _loginWithFacebook(BuildContext context) {
    return getFlatButton(
      icon: FontAwesomeIcons.facebookSquare,
      text: "Entre com Facebook",
      color: Color(0xff263C68),
      onPressed: () => BlocProvider.of<LoginBloc>(context).add(
        LoginWithFacebookEvent(),
      ),
    );
  }

  Widget _loginWithGoogle(BuildContext context) {
    return getFlatButton(
      icon: FontAwesomeIcons.google,
      text: "Entre com Google",
      color: Color(0xffEA4335),
      onPressed: () => BlocProvider.of<LoginBloc>(context).add(
        LoginWithGoogleEvent(),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return getFlatButton(
      icon: FontAwesomeIcons.doorOpen,
      text: "Login",
      color: Color(0xff5BC0EB),
      onPressed: () => BlocProvider.of<LoginBloc>(context).add(
        LoginWithUsernameAndPasswordEvent(
            email: emailController.text, password: passwordController.text),
      ),
    );
  }

  Widget _registerButton(BuildContext context) {
    return getFlatButton(
        icon: Icons.add_box,
        text: "ou Registre-se",
        color: Colors.blue,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RegisterScreen(),
            ),
          );
        });
  }
}
