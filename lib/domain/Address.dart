import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Location extends Equatable {
  final double lat;
  final double lon;

  Location({@required this.lat, @required this.lon});

  @override
  List<Object> get props => [lat, lon];

  factory Location.fromJson(Map<String, dynamic> json) =>
      Location(lat: json['lat'], lon: json['lon']);

  factory Location.fromGoogleapisJson(Map<String, dynamic> json) =>
      Location(lat: json['lat'], lon: json['lng']);
  Map<String, dynamic> toJson() => {'lat': lat, 'lon': lon};
}

class Address extends Equatable {
  final String rawAddress;
  final String street;
  final String number;
  final String complement;
  final String poCode;
  final String county;
  final City city;
  final State state;
  final Country country;
  final Location location;

  Address(
      {@required this.rawAddress,
      this.street,
      this.number,
      this.complement,
      this.poCode,
      this.county,
      this.country,
      this.state,
      this.city,
      this.location});

  factory Address.fromGoogleapisJson(Map<String, dynamic> json) {
    List addressComponents = json['results'][0]['address_components'];

    Map streetJson = addressComponents.firstWhere(
        (element) => element['types'].contains('route'),
        orElse: () => {'long_name': ''});
    Map numberJson = addressComponents.firstWhere(
        (element) => element['types'].contains('street_number'),
        orElse: () => {'long_name': ''});
    Map countyJson = addressComponents.firstWhere(
        (element) => element['types'].contains('sublocality_level_1'),
        orElse: () => {'long_name': ''});
    Map cityJson = addressComponents.firstWhere(
        (element) => element['types'].contains('administrative_area_level_2'),
        orElse: () => {'long_name': ''});
    Map stateJson = addressComponents.firstWhere(
        (element) => element['types'].contains('administrative_area_level_1'),
        orElse: () => {'long_name': '', 'short_name': ''});
    Map countryJson = addressComponents.firstWhere(
        (element) => element['types'].contains('country'),
        orElse: () => {'long_name': ''});
    Map poCodeJson = addressComponents.firstWhere(
        (element) => element['types'].contains('postal_code'),
        orElse: () => {'long_name': ''});
    final address = Address(
        rawAddress: json['results'][0]['formatted_address'],
        city: City.fromGoogleapisJson(cityJson),
        complement: '',
        country: Country.fromGoogleapisJson(countryJson),
        county: countyJson['long_name'],
        number: numberJson['long_name'],
        location: Location.fromGoogleapisJson(
            json['results'][0]['geometry']['location']),
        poCode: poCodeJson['long_name'],
        state: State.fromGoogleapisJson(stateJson),
        street: streetJson['long_name']);
    return address;
  }

  Map<String, dynamic> toJson() {
    return {
      'rawAddress': this.rawAddress,
      'street': this.street,
      'number': this.number,
      'complement': this.complement,
      'poCode': this.poCode,
      'county': this.county,
      'country': this.country.toJson(),
      'state': this.state.toJson(),
      'city': this.city.toJson(),
      'location': this.location.toJson()
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        rawAddress: json['rawAddress'],
        street: json['street'],
        state: State.fromJson(json['state']),
        poCode: json['poCode'],
        location: Location.fromJson(json['location']),
        number: json['number'],
        county: json['county'],
        country: Country.fromJson(json['country']),
        complement: json['complement'],
        city: City.fromJson(json['city']));
  }

  @override
  String toString() {
    return 'address: { rawAddress: $rawAddress, '
        'street: $street, '
        'number: $number, '
        'complement: $complement, '
        'poCode: $poCode, '
        'county: $county, '
        'country: $country, '
        'state: $state, '
        'city: $city, '
        'location: $location, ';
  }

  @override
  List<Object> get props => [
        rawAddress,
        street,
        number,
        complement,
        poCode,
        county,
        country,
        state,
        city,
        location
      ];
}

class City extends Equatable {
  final String name;
  City({this.name});
  factory City.fromGoogleapisJson(Map<String, dynamic> json) =>
      City(name: json['long_name']);

  factory City.fromJson(Map<String, dynamic> json) => City(name: json['name']);

  @override
  String toString() {
    return 'city: { name: $name}';
  }

  Map<String, dynamic> toJson() {
    return {'name': this.name};
  }

  @override
  List<Object> get props => [name];
}

class State extends Equatable {
  final String name;
  final String acronym;
  State({this.name, this.acronym});
  factory State.fromGoogleapisJson(Map<String, dynamic> json) =>
      State(name: json['long_name'], acronym: json['short_name']);
  factory State.fromJson(Map<String, dynamic> json) =>
      State(name: json['name'], acronym: json['acronym']);

  @override
  String toString() {
    return 'state: { name: $name, acronym: $acronym}';
  }

  Map<String, dynamic> toJson() {
    return {'name': this.name, 'acronym': this.acronym};
  }

  @override
  List<Object> get props => [name, acronym];
}

class Country extends Equatable {
  final String name;
  Country({this.name});
  factory Country.fromGoogleapisJson(Map<String, dynamic> json) =>
      Country(name: json['long_name']);
  factory Country.fromJson(Map<String, dynamic> json) =>
      Country(name: json['name']);

  @override
  String toString() {
    return 'country: { name: $name}';
  }

  Map<String, dynamic> toJson() {
    return {'name': this.name};
  }

  @override
  List<Object> get props => [name];
}
