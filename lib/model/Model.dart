import 'package:flutter/cupertino.dart';

class Product {
  String name;
  String eanCode;
  String ncmCode;
  Unity unity;
  bool normalized;
  String thumbnail;
  Product(
      {this.name,
      this.eanCode,
      this.ncmCode,
      this.unity,
      this.normalized,
      this.thumbnail});
  factory Product.fromJson(Map<String, dynamic> json) => Product(
      name: json['name'],
      eanCode: json['eanCode'],
      ncmCode: json['ncmCode'],
      normalized: json['normalized'],
      thumbnail: json['thumbnail'],
      unity: Unity.fromJson(json['unity']));

  @override
  String toString() {
    return 'name:$name, '
        'eanCode: $eanCode, '
        'ncmCode: $ncmCode, '
        'unity: ${unity.toString()}, '
        'normalized: $normalized, '
        'thumbnail: $thumbnail';
  }
}

class Unity {
  String name;
  Unity(this.name);
  factory Unity.fromJson(Map<String, dynamic> json) => Unity(json['name']);
  @override
  String toString() {
    return 'name:$name';
  }
}

class Address {
  String rawAddress;
  String street;
  String number;
  String complement;
  String poCode;
  String county;
  City city;
  State state;
  Country country;
  double lat;
  double lon;

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
      this.lat,
      this.lon});

  factory Address.fromGoogleapisJson(Map<String, dynamic> json) {
    List addressComponents = json['results'][0]['address_components'];

    print('addressComponents: $addressComponents');

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
    return Address(
        rawAddress: json['results'][0]['formatted_address'],
        city: City.fromJson(cityJson),
        complement: '',
        country: Country.fromJson(countryJson),
        county: countyJson['long_name'],
        number: numberJson['long_name'],
        lat: json['results'][0]['geometry']['location']['lat'],
        lon: json['results'][0]['geometry']['location']['lng'],
        poCode: poCodeJson['long_name'],
        state: State.fromJson(stateJson),
        street: streetJson['long_name']);
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
      'lat': this.lat,
      'lon': this.lon
    };
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
        'lat: $lat, '
        'lon: $lon }';
  }
}

class City {
  String name;
  City({this.name});
  factory City.fromJson(Map<String, dynamic> json) =>
      City(name: json['long_name']);
  @override
  String toString() {
    return 'city: { name: $name}';
  }

  Map<String, dynamic> toJson() {
    return {'name': this.name};
  }
}

class State {
  String name;
  String acronym;
  State({this.name, this.acronym});
  factory State.fromJson(Map<String, dynamic> json) =>
      State(name: json['long_name'], acronym: json['short_name']);
  @override
  String toString() {
    return 'state: { name: $name, acronym: $acronym}';
  }

  Map<String, dynamic> toJson() {
    return {'name': this.name, 'acronym': this.acronym};
  }
}

class Country {
  String name;
  Country({this.name});
  factory Country.fromJson(Map<String, dynamic> json) =>
      Country(name: json['long_name']);
  @override
  String toString() {
    return 'country: { name: $name}';
  }

  Map<String, dynamic> toJson() {
    return {'name': this.name};
  }
}

class UserPreferences {
  int searchRadius;

  UserPreferences({this.searchRadius});

  Map<String, dynamic> toJson() {
    return {'searchRadius': this.searchRadius};
  }
}

class User {
  String email;
  String userId;
  Address address;
  UserPreferences preferences;
  User({this.preferences, this.email, this.address, this.userId});
  Map<String, dynamic> toJson() {
    return {
      'email': this.email,
      'userId': this.userId,
      'address': this.address.toJson(),
//      'preferences': this.preferences ?? this.preferences.toJson()
    };
  }
}
