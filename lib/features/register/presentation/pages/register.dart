import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widgets/UserMessaging.dart';
import '../../../../core/widgets/registration_widgets.dart';
import '../../../../injection_container.dart';
import '../../../../screens/common/loading.dart';
import '../bloc/registration_bloc_bloc.dart';

class RegisterScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem vindo."),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<RegistrationBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegistrationBloc>(),
      child: BlocConsumer<RegistrationBloc, RegistrationBlocState>(
        listener: (context, state) {
          if (state is RegistrationBlocFailed) {
            showErrorWidget(failure: state.failure, context: context);
          } else if (state is RegistrationBlocSucceeded) {
            showInformationWidget(
                message:
                    'Você se registrou com sucesso. Por favor verifique seu email',
                context: context);
          }
        },
        builder: (context, state) {
          if (state is RegistrationBlocRunning) {
            return Loading();
          }
          return verticalListView(context);
        },
      ),
    );
  }

  ListView verticalListView(BuildContext context) {
    return ListView(
      children: [
        SvgPicture.asset(
          'images/groceries.svg',
          height: 100,
          width: 100,
        ),
        loginTextField(emailController),
        passwordTextField(passwordController),
        _registerButton(context)
      ],
    );
  }

  Widget _registerButton(BuildContext context) {
    return getTextButton(
        icon: FontAwesomeIcons.registered,
        text: "Register",
        color: Color(0xff5BC0EB),
        onPressed: () => BlocProvider.of<RegistrationBloc>(context).add(
              RegisterWithEmailAndPasswordEvent(
                  email: emailController.text,
                  password: passwordController.text),
            ));
  }
}
