import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  static const authDataKey = 'authData';
  static const apiKey = '?key=AIzaSyCCZrB4cUxYue1WNE7s8xjrgn0j32rogmk';
  static const signUpUrlSegment = 'signUp';
  static const signInUrlSegment = 'signInWithPassword';
  static const authenticateUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:';

  String? _token;
  DateTime? _expiryDate;
  late String _userId;
  Timer? _authTimer;

  bool get isAuthenticated => token != null;

  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) return _token;

    return null;
  }

  String? get userId => _userId;

  Future<void> _authenticate({
    required String email,
    required String password,
    required String urlSegment,
  }) async {
    try {
      final response = await post(
        Uri.parse('$authenticateUrl$urlSegment$apiKey'),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseBody = json.decode(response.body);

      if (responseBody['error'] != null) {
        // What's the idea behind throwing an exception here?
        // We can of course now manage or handle that exception in the AuthScreen
        // which is where we're in the widget and where we can present something
        // to the user, show an alert to the user for example.
        final String error = responseBody['error']['message'];
        var errorMessage = 'Authentication failed!';

        if (error.contains('EMAIL_EXISTS')) {
          errorMessage = 'This email address is already in use!';
        } else if (error.contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Could not find a user with that email.';
        } else if (error.contains('INVALID_EMAIL')) {
          errorMessage = 'This is not a valid email address.';
        } else if (error.contains('INVALID_PASSWORD')) {
          errorMessage = 'Invalid password!';
        } else if (error.contains('WEAK_PASSWORD')) {
          errorMessage = 'This password is too weak.';
        }

        throw HttpException(message: errorMessage);
      }

      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.tryParse(responseBody['expiresIn']) ?? 0));
      _autoSignOut();
      _storeAuthData();
      notifyListeners();
    } on HttpException {
      rethrow;
    } catch (error) {
      throw HttpException(
        message: 'Could not authenticate you. Please try again later!',
      );
    }
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

  Future<bool> autoSignIn() async {
    final authData = await _retrieveAuthData();

    print('Auto SignIn $authData');

    if (authData == null) return false;

    // Here, If we reach here that means we have a valid token because the expiry
    // date now is in the future and this is now when we want to reinitialize
    // all auth properties up there.
    _token = authData['token'];
    _userId = authData['userId'] ?? '';
    _expiryDate = DateTime.tryParse(authData['expiryDate']!);
    // call autoSignOut to set that timer again.
    _autoSignOut();
    notifyListeners();
    // Important to return true.
    return true;
  }

  // So, here in signOut(), I also get access to SharedPreferences by awaiting.
  // For that, we have to turn this into an async function which means it will
  // return a future that yields nothing.
  Future<void> signOut() async {
    _token = null;
    _expiryDate = null;

    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }

    notifyListeners();
    _clearAuthData();
  }

  void _autoSignOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }

    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), signOut);
  }

  // Store User Authentication data on the device in the SharedPreferences Storage.
  Future<void> _storeAuthData() async {
    final prefs = await SharedPreferences.getInstance();

    // We complex data by the way, wo we use json.encode and encode a map into
    // JSON because JSON is always a String.
    final String authData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate?.toIso8601String(),
    });

    prefs.setString(authDataKey, authData);
  }

  Future<Map<String, dynamic>?> _retrieveAuthData() async {
    // Access the SharedPreferences.
    final prefs = await SharedPreferences.getInstance();

    // If the SharedPreferences doesn't contain the auth data, then there is no data stored.
    if (!prefs.containsKey(authDataKey)) return null;

    // If we do have that auth data key, we know that we can at least get a token
    // It might still be an invalid token which already expired in the meantime,
    // but we can get some data.
    final authData =
        json.decode(prefs.getString(authDataKey)!) as Map<String, dynamic>;

    // From the extracted auth data, we can get the expiry date because we want to
    // check that date and see whether it still is valid or not.
    // By using DateTime.parse() which works because we stored the date as an
    // ISO8601String to get DateTime Object.
    final expiryDate = DateTime.parse(authData['expiryDate']!);

    // Check if expiry date is before the time now, we know the token is not valid
    // and we can return false here and we don't need to continue, we certainly
    // have no valid token because the expiry date is in the past.
    if (expiryDate.isBefore(DateTime.now())) return null;

    return authData;
  }

  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    // We can call remove() and pass in the key what we want to remove.
    // This will be good if we storing multiple things in the SharedPreferences,
    // which we don't all want to delete if we're logging out.
    //! prefs.remove('userData');

    // But if I know I only store the auth data there, I can also just call clear().
    // This will delete all your app's data from the SharedPreferences.
    prefs.clear();
  }
}
