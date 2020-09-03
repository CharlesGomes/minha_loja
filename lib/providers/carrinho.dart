import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart';

class CarrinhoItem {
  final String id;
  final String titulo;
  final int quantidade;
  final double preco;

  CarrinhoItem({
    @required this.id,
    @required this.titulo,
    @required this.quantidade,
    @required this.preco,
  });
}

class Carrinho with ChangeNotifier {
  Map<String, CarrinhoItem> _itens = {};

  Map<String, CarrinhoItem> get itens {
    return {..._itens};
  }

// Contagem de itens no carrinho
  int get itemCount {
    return _itens.length;
  }

// Calcula valor total dos itens do carrinho
  double get totalMontante {
    var total = 0.0;
    _itens.forEach((key, carItem) {
      total += carItem.preco * carItem.quantidade;
    });
    return total;
  }

  void addItem(String produtoId, double preco, String titulo) {
    if (_itens.containsKey(produtoId)) {
      _itens.update(
        produtoId,
        (existeCarrinhoItem) => CarrinhoItem(
          id: existeCarrinhoItem.id,
          titulo: existeCarrinhoItem.titulo,
          quantidade: existeCarrinhoItem.quantidade + 1,
          preco: existeCarrinhoItem.preco,
        ),
      );
    } else {
      // Insere o produto ao carrinho pela primeira vez
      _itens.putIfAbsent(
        produtoId,
        () => CarrinhoItem(
          id: DateTime.now().toString(),
          titulo: titulo,
          quantidade: 1,
          preco: preco,
        ),
      );
    }
    notifyListeners();
  }

  // Remove itens do carrinho
  void removeItem(String produtoId) {
    _itens.remove(produtoId);
    notifyListeners();
  }

  void limparCarrinho() {
    _itens = {};
    notifyListeners();
  }

// Remove ultimo item adicionado ao carrinho
  void removeUltimoItem(String produtoId) {
    if (!_itens.containsKey(produtoId)) {
      return;
    }
    if (_itens[produtoId].quantidade > 1) {
      _itens.update(
          produtoId,
          (existeCarrinhoItem) => CarrinhoItem(
                id: existeCarrinhoItem.id,
                titulo: existeCarrinhoItem.titulo,
                quantidade: existeCarrinhoItem.quantidade - 1,
                preco: existeCarrinhoItem.preco,
              ));
    } else {
      _itens.remove(produtoId);
    }
    notifyListeners();
  }
}
