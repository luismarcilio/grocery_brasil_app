import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/ApplicationFormField.dart';
import '../../../../core/widgets/TextElevatedButton.dart';
import '../../../../core/widgets/UserMessaging.dart';
import '../../../../domain/Address.dart';
import '../../../../domain/User.dart';
import '../../../../domain/UserPreferences.dart';
import '../../../../injection_container.dart';
import '../../../../screens/common/loading.dart';
import '../../../addressing/data/AddressingServiceAdapter.dart';
import '../../../addressing/data/GPSServiceAdapter.dart';
import '../bloc/user_bloc.dart';
import '../widgets/UserSlider.dart';
import 'UserAddressScreen.dart';

final addressingServiceAdapter = sl<AddressingServiceAdapter>();
final geolocatorGPSServiceAdapter = sl<GPSServiceAdapter>();

class AccountSetupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UserBloc>(),
      child: UserDetailsForm(),
    );
  }
}

class UserDetailsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(listener: (context, state) {
      if (state is UserError) {
        showErrorWidget(failure: state.failure, context: context);
      }
    }, builder: (context, state) {
      if (state is UserInitial) {
        BlocProvider.of<UserBloc>(context).add(GetUser());
      } else if (state is UserUpdating) {
        return Loading();
      } else if (state is UserReady) {
        return BuildUserDetailsForm(user: state.user);
      }
      return Container();
    });
  }
}

class BuildUserDetailsForm extends StatelessWidget {
  final User user;

  const BuildUserDetailsForm({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller =
        TextEditingController(text: user.address.rawAddress);
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Form(
        child: Column(
          children: [
            ApplicationFormField(
                controller: _controller,
                keyboardType: TextInputType.multiline,
                hint: 'Endereço',
                labelText: 'Endereço',
                onTap: () async {
                  Address newAddress = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserAddressScreen(
                              addressingServiceAdapter:
                                  addressingServiceAdapter,
                              initialAddress: user.address.rawAddress,
                            )),
                  );
                  _controller.text = newAddress.rawAddress;
                  final newUser = User(
                      email: user.email,
                      userId: user.userId,
                      emailVerified: user.emailVerified,
                      address: newAddress,
                      preferences: user.preferences);
                  saveUser(context, newUser);
                }),
            TextElevatedButton(
              onLongPress: () {},
              onPressed: () async {
                final currentLocation =
                    await geolocatorGPSServiceAdapter.getCurrentLocation();
                final newAddress = await addressingServiceAdapter
                    .getAddressFromLocation(currentLocation);
                final newUser = User(
                    email: user.email,
                    userId: user.userId,
                    emailVerified: user.emailVerified,
                    address: newAddress,
                    preferences: user.preferences);
                saveUser(context, newUser);
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
                        'Distância máxima para procurar os produtos: ${user.preferences.searchRadius}m',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    UserSlider(
                      initialValue: user.preferences.searchRadius,
                      onChangeEnd: (double value) {
                        final newUser = User(
                            email: user.email,
                            userId: user.userId,
                            emailVerified: user.emailVerified,
                            address: user.address,
                            preferences:
                                UserPreferences(searchRadius: value.round()));
                        saveUser(context, newUser);
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

  void saveUser(BuildContext context, User newUser) {
    BlocProvider.of<UserBloc>(context).add(UpdateUser(user: newUser));
  }
}
