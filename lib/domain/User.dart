import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import '../services/LocationServices.dart';
import 'Address.dart';

class UserPreferences {
  int searchRadius;

  UserPreferences({this.searchRadius});

  Map<String, dynamic> toJson() {
    return {'searchRadius': this.searchRadius};
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      UserPreferences(searchRadius: json['searchRadius']);
}

class User extends Equatable {
  String email;
  String userId;
  bool emailVerified;

  Address address;
  UserPreferences preferences;
  User(
      {this.preferences,
      @required this.email,
      this.address,
      @required this.userId,
      this.emailVerified,
      String uid});
  Map<String, dynamic> toJson() {
    return {
      'email': this.email,
      'userId': this.userId,
      'address': this.address.toJson(),
      'preferences': this.preferences.toJson()
    };
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
      userId: json['userId'],
      email: json['email'],
      address: Address.fromJson(json['address']),
      preferences: UserPreferences.fromJson(json['preferences']));

  Future<void> setAddressByRawAddress(String rawAddress) async {
    final Map<String, dynamic> googleAddress =
        await getAddressByRawAddress(rawAddress);
    this.address = Address.fromGoogleapisJson(googleAddress);
  }

  Future<void> setAddressByCurrentPosition() async {
    final Position position = await getPosition();
    final Map<String, dynamic> googleAddress =
        await getAddressByPosition(position);
    this.address = Address.fromGoogleapisJson(googleAddress);
  }

  @override
  List<Object> get props => [email, userId, address, preferences];
}
