import 'dart:convert';
import 'package:flutter/foundation.dart';
import './carrinho.dart';

import 'package:http/http.dart' as http;

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
  Ordens(this.authToken, this.userId, this._ordens);

  List<OrdemItem> _ordens = [];
  final String authToken;
  final String userId;

  List<OrdemItem> get ordens {
    return [..._ordens];
  }

  Future<void> buscaOrdens() async {
    final url =
        'https://flutter-update-ef19b.firebaseio.com/ordens/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrdemItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrdemItem(
          id: orderId,
          montante: orderData['montante'],
          dataTime: DateTime.parse(orderData['dataTime']),
          produtos: (orderData['produtos'] as List<dynamic>)
              .map(
                (item) => CarrinhoItem(
                  id: item['id'],
                  preco: item['preco'],
                  quantidade: item['quantidade'],
                  titulo: item['titulo'],
                ),
              )
              .toList(),
        ),
      );
    });
    _ordens = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrdem(
      List<CarrinhoItem> carrinhoProdutos, double total) async {
    final url =
        'https://flutter-update-ef19b.firebaseio.com/ordens/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'montante': total,
        'dataTime': timestamp.toIso8601String(),
        'produtos': carrinhoProdutos
            .map((cp) => {
                  'id': cp.id,
                  'titulo': cp.titulo,
                  'quantidade': cp.quantidade,
                  'preco': cp.preco,
                })
            .toList(),
      }),
    );
    _ordens.insert(
      0,
      OrdemItem(
        id: json.decode(response.body)['name'],
        montante: total,
        dataTime: timestamp,
        produtos: carrinhoProdutos,
      ),
    );
    notifyListeners();
  }
}
