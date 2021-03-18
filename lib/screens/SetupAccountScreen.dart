import 'dart:developer' as dartDeveloper;
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/user_cubit.dart';
import '../domain/User.dart';
import '../services/LocationServices.dart';
import '../services/UserRepository.dart';
import 'UserAddress.dart';
import 'common/CommonWidgets.dart';
import 'common/loading.dart';

class AccountSetupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.signOut();
    return BlocProvider(
      create: (context) => UserCubit(UserRepository()),
      child: UserDetailsForm(),
    );
  }
}

class UserDetailsForm extends StatefulWidget {
  @override
  _UserDetailsFormState createState() => _UserDetailsFormState();
}

class UserForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final User _user;
  UserForm(this._user);

  static void saveUser(BuildContext context, User user) {
    final userCubit = context.read<UserCubit>();
    userCubit.updateUser(user);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller =
        TextEditingController(text: _user.address.rawAddress);
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            ApplicationFormField(
                controller: _controller,
                keyboardType: TextInputType.multiline,
                hint: 'Endereço',
                labelText: 'Endereço',
                onTap: () async {
                  GeolocationSuggestion newAddress = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UserAddressScreen(_controller.text)),
                  );
                  _controller.text = newAddress.description;
                  // await _user.setAddressByRawAddress(newAddress.description);
                  saveUser(context, _user);
                }),
            TextRaisedButton(
              onLongPress: () {},
              onPressed: () async {
                // await _user.setAddressByCurrentPosition();
                saveUser(context, _user);
              },
              label: 'Usar Posição atual',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  border: Border.all(color: Colors.black45),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Distância máxima para procurar os produtos: ${_user.preferences.searchRadius}m',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    AppSlider(
                      initialValue:
                          log(_user.preferences.searchRadius.toDouble()) /
                              log(10),
                      onChangeEnd: (value) {
                        saveUser(context, _user);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final _userId = FirebaseAuth.instance.currentUser.uid;

  Widget userInitial() {
    return Loading();
  }

  Widget userLoading() {
    return Loading();
  }

  Widget userSaving() {
    return Loading();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser
        .getIdToken(true)
        .then((jwt) => dartDeveloper.log(jwt));

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is UserInitial) {
          final userCubit = context.read<UserCubit>();
          userCubit.getUser(_userId);
          return userInitial();
        } else if (state is UserLoading) {
          return userLoading();
        } else if (state is UserLoaded) {
          return UserForm(state.user);
        } else if (state is UserSaving) {
          return userSaving();
        } else {
          return userInitial();
        }
      },
    );
  }
}
