import 'package:flutter/foundation.dart';
import './carrinho.dart';

class OrdemItem {
  final String id;
  final double montante;
  final List<CarrinhoItem> produtos;
  final DateTime dataTime;

  OrdemItem({
    @required this.id,
    @required this.montante,
    @required this.produtos,
    @required this.dataTime,
  });
}

class Ordens with ChangeNotifier {
  List<OrdemItem> _ordens = [];

  List<OrdemItem> get ordens {
    return [..._ordens];
  }

// Adiciona carrinho a ordem de pedido
  void addOrdem(List<CarrinhoItem> carrinhoProdutos, double total) {
    _ordens.insert(
        0,
        OrdemItem(
          id: DateTime.now().toString(),
          montante: total,
          produtos: carrinhoProdutos,
          dataTime: DateTime.now(),
        ));
    notifyListeners();
  }
}
