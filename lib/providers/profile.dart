import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class Profile with ChangeNotifier {
  final String firstName;
  final String lastName;
  final int age;
  final String address;

  Profile({this.firstName, this.lastName, this.age, this.address});
}

class ProfileDetails with ChangeNotifier {
  Profile _profile = Profile(
    firstName: '',
    lastName: '',
    age: null,
    address: '',
  );
  final String authToken;
  final String userId;

  ProfileDetails(this._profile, this.authToken, this.userId);

  Profile get details {
    return _profile;
  }

  Future<Profile> fetchAndSetProfile() async {
    final url =
        'https://buy-ez-flutter.firebaseio.com/profile/$userId.json?auth=$authToken';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      Profile loadedData;

      if (extractedData == null) {
        return null;
      }

      loadedData = Profile(
        firstName: extractedData['firstName'],
        lastName: extractedData['lastname'],
        age: extractedData['age'],
        address: extractedData['address'],
      );

      _profile = loadedData;
      notifyListeners();
      return details;
    } catch (error) {
      throw error;
    }
  }

  Future<void> saveProfile(Profile profile) async {
    final url =
        'https://buy-ez-flutter.firebaseio.com/profile/$userId.json?auth=$authToken';

    try {
      await http.post(
        url,
        body: json.encode(
          {
            'firstName': profile.firstName,
            'lastname': profile.lastName,
            'age': profile.age,
            'deliveryAddress': profile.address
          },
        ),
      );
      // print('saveProfileFunction = ' + json.decode(response.body));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
  Future<void> updateProfile(Profile profile) async {
    final url =
        'https://buy-ez-flutter.firebaseio.com/profile/$userId.json?auth=$authToken';

    try {
      await http.patch(
        url,
        body: json.encode(
          {
            'firstName': profile.firstName,
            'lastname': profile.lastName,
            'age': profile.age,
            'deliveryAddress': profile.address
          },
        ),
      );
      // print('saveProfileFunction = ' + json.decode(response.body));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
