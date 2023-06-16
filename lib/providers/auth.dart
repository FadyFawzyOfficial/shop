import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class Auth with ChangeNotifier {
  static const apiKey = 'AIzaSyCCZrB4cUxYue1WNE7s8xjrgn0j32rogmk';
  static const signUpUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=';
  static const signInUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=';

  late String _token;
  late DateTime _expiryDate;
  late String _userId;

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    final response = await post(
      Uri.parse('$signUpUrl$apiKey'),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    print(response.body);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final response = await post(
      Uri.parse('$signInUrl$apiKey'),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    print(response.body);
  }
}
