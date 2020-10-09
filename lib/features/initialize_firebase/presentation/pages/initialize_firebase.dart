import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_brasil_app/features/initialize_firebase/bloc/initialize_firebase_bloc.dart';
import 'package:grocery_brasil_app/features/login/presentation/pages/login.dart';

class InitialiseFirebase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InitializeFirebaseBloc(),
      child: InitialiseFirebaseScreen(),
    );
  }
}

class InitialiseFirebaseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InitializeFirebaseBloc, InitializeFirebaseState>(
      listener: (context, state) {
        if (state is FirebaseError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is InitializeFirebaseInitial) {
          BlocProvider.of<InitializeFirebaseBloc>(context)
              .add(InitalizeFirebase());
          return CircularProgressIndicator();
        } else if (state is FirebaseInitializing) {
          return CircularProgressIndicator();
        }
        //Initialized
        return Login();
      },
    );
  }
}
