import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Produto with ChangeNotifier {
  final String id;
  final String titulo;
  final String descricao;
  final double preco;
  final String imagemUrl;
  bool isFavorito;

  Produto({
    @required this.id,
    @required this.titulo,
    @required this.descricao,
    @required this.preco,
    @required this.imagemUrl,
    this.isFavorito = false,
  });

  void _setFavValue(bool novoValor) {
    isFavorito = novoValor;
    notifyListeners(); // Notifica os ouvintes
  }

// Metodo da class para alterar o status da propriedade isFavorito
  Future<void> alteraFavoritoStatus(String token, String userId) async {
    final statusAnteiror = isFavorito;
    isFavorito = !isFavorito; // Inverte o valor
    notifyListeners(); // Notifica os ouvintes
    final url =
        'https://flutter-update-ef19b.firebaseio.com/userFavoritos/$userId/$id.json?auth=$token'; // Url de comunicação com a API
    try {
      final resposta = await http.put(
        url,
        body: json.encode(
          isFavorito,
        ),
      );
      if (resposta.statusCode >= 400) {
        _setFavValue(statusAnteiror);
      }
    } catch (erro) {
      // Caso ocorra um erro ao salvar dados no servidor reverte ao valor anterior
      _setFavValue(statusAnteiror);
    }
  }
}
