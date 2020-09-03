import 'package:flutter/foundation.dart';

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

// Metodo da class para alterar o status da propriedade isFavorito
  void alteraFavoritostatus() {
    isFavorito = !isFavorito; // Inverte o valor
    notifyListeners(); // Notifica os ouvintes
  }
}
