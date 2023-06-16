import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class Auth with ChangeNotifier {
  static const apiKey = '?key=AIzaSyCCZrB4cUxYue1WNE7s8xjrgn0j32rogmk';
  static const signUpUrlSegment = 'signUp';
  static const signInUrlSegment = 'signInWithPassword';
  static const authenticateUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:';

  late String _token;
  late DateTime _expiryDate;
  late String _userId;

  Future<void> _authenticate({
    required String email,
    required String password,
    required String urlSegment,
  }) async {
    final response = await post(
      Uri.parse('$authenticateUrl$urlSegment$apiKey'),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    print(response.body);
  }

  // We return this future because this is the future which actually wraps our
  // HTTP request and waits for it to complete.
  // So, in order to have our loading spinner work correctly, we want to return
  // the future which actually does the work.
  // Without return, we would also return a future but this wouldn't wait for
  // the future of authenticate to do its job.
  Future<void> signUp({
    required String email,
    required String password,
  }) async =>
      _authenticate(
        email: email,
        password: password,
        urlSegment: signUpUrlSegment,
      );

  Future<void> signIn({
    required String email,
    required String password,
  }) async =>
      _authenticate(
        email: email,
        password: password,
        urlSegment: signInUrlSegment,
      );
}
