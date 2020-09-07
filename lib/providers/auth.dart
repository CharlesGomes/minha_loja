import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

// Retorna o token se ele for valido
  bool get isAuth {
    return token != null;
  }

// Verifica se o token é valido
  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

// Metodo para autenticar usuario
  Future<void> _autenticar(
      String email, String password, String urlSegment) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyBWs-SO5t4Rbi-kg3cjldltEmlyxJk05IE';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final respostaData = json.decode(response.body);
      if (respostaData['error'] != null) {
        throw HttpException(respostaData['error']['message']);
      }
      _token = respostaData['idToken']; // Recebe o token caso não haja erro
      _userId = respostaData['localId']; // Recebe o id
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            respostaData['expiresIn'],
          ), // Tempo para exprirar o token
        ),
      );
      _autoLogout(); // Chama o metodo que desloga caso token expire
      notifyListeners();
      // Vai ler e escrevar dados no dispositivo
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

// Metodo para inscrever usuario
  Future<void> signup(String email, String password) async {
    return _autenticar(email, password, 'signupNewUser');
  }

// Metodo para logar usuario
  Future<void> login(String email, String password) async {
    return _autenticar(email, password, 'verifyPassword');
  }

// Verifica se temos um login ativo valido
  Future<bool> verificaAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    // Verifica se existe dados de login validos
    if (!prefs.containsKey('userData')) {
      return false;
    }
    // Extrai os dados de login de usuario armazenados
    final extrairUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extrairUserData['expiryDate']);

// Verifica se o token é valido verificando o tempo do token
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extrairUserData['token'];
    _userId = extrairUserData['userId'];
    _expiryDate = expiryDate;
    _autoLogout();
    notifyListeners();
    return true;
  }

// Desloga usuario
  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    // Limpa os dados de login de usuario
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

// Desloga usuario automaticamente caso tempo expire
  void _autoLogout() {
    // Se cronometro existir cancela o cronometro existente
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final tempoExpiracao = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: tempoExpiracao), logout);
  }
}
