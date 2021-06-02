import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widgets/UserMessaging.dart';
import '../../../../core/widgets/registration_widgets.dart';
import '../../../../injection_container.dart';
import '../../../../screens/common/loading.dart';
import '../../../../screens/dashboard.dart';
import '../../../register/presentation/pages/register.dart';
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
              showErrorWidget(failure: state.failure, context: context);
            } else if (state is CreateUserFailure) {
              showErrorWidget(failure: state.failure, context: context);
            } else if (state is ResetPasswordSuccess) {
              showInformationWidget(
                  message:
                      "Enviamos um email com um link para que você possa resetar sua password",
                  context: context);
            } else if (state is ResetPasswordFailure) {
              //TODO: ADD PROPER ERROR MESSAGE
              showErrorWidget(failure: state.failure, context: context);
            }
          },
          builder: (context, state) {
            if (state is LoginRunning || state is UserCreating) {
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
          (() {
            if (Platform.isIOS) {
              return _loginWithApple(context);
            } else {
              return Container();
            }
          })(),
          getDefaultContainer(
              child: Divider(
            color: Colors.black,
          )),
          getTextButton(
              color: Colors.grey,
              icon: FontAwesomeIcons.envelope,
              text: "Iniciar sessão com a email e password",
              onPressed: null),
          loginTextField(emailController),
          passwordTextField(passwordController),
          _loginButton(context),
          _recoverPassword(context),
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
    return getTextButton(
      icon: FontAwesomeIcons.facebookSquare,
      text: "Iniciar sessão com o Facebook",
      color: Color(0xff263C68),
      onPressed: () => BlocProvider.of<LoginBloc>(context).add(
        LoginWithFacebookEvent(),
      ),
    );
  }

  Widget _loginWithGoogle(BuildContext context) {
    return getTextButton(
      icon: FontAwesomeIcons.google,
      text: "Iniciar sessão com o Google",
      color: Color(0xffEA4335),
      onPressed: () => BlocProvider.of<LoginBloc>(context).add(
        LoginWithGoogleEvent(),
      ),
    );
  }

  Widget _loginWithApple(BuildContext context) {
    return getTextButton(
      icon: FontAwesomeIcons.apple,
      text: "Iniciar sessão com a Apple",
      color: Colors.black87,
      onPressed: () => BlocProvider.of<LoginBloc>(context).add(
        LoginWithAppleEvent(),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return getTextButton(
      icon: FontAwesomeIcons.doorOpen,
      text: "Login",
      color: Color(0xff5BC0EB),
      onPressed: () => BlocProvider.of<LoginBloc>(context).add(
        LoginWithUsernameAndPasswordEvent(
            email: emailController.text, password: passwordController.text),
      ),
    );
  }

  Widget _recoverPassword(BuildContext context) {
    return getTextButton(
      icon: FontAwesomeIcons.syncAlt,
      text: "Esqueci a password",
      color: Colors.blue,
      onPressed: () {
        if (emailController.text.isEmpty) {
          showInformationWidget(
              message: "Por favor digite o email de sua conta",
              context: context);
          return;
        }
        BlocProvider.of<LoginBloc>(context)
            .add(ResetPasswordEvent(email: emailController.text));
      },
    );
  }

  Widget _registerButton(BuildContext context) {
    return getTextButton(
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
