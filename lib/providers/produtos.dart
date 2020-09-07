import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './produto.dart';
import '../models/http_exception.dart';

class Produtos with ChangeNotifier {
  // Lista privada, somente poderar se acessa dentro dessa class
  List<Produto> _itens = [];

  // var _mostraFavorito = false;

  final String authToken;
  final String userId;

  Produtos(
    this.authToken,
    this.userId,
    this._itens,
  );

// Retorna uma copia da lista de produtos
  List<Produto> get itens {
    return [..._itens];
  }

// Retorna lista de produto marcado como favorito
  List<Produto> get favoritoItens {
    return _itens.where((prodItem) => prodItem.isFavorito).toList();
  }

// Retorna um produto selecionado pelo id
  Produto selecionaPorId(String id) {
    return _itens.firstWhere((prod) => prod.id == id);
  }

// Adiciona um novo produto
  Future<void> addProduto(Produto produto) async {
    final url =
        'https://flutter-update-ef19b.firebaseio.com/produtos.json?auth=$authToken'; // Url de comunicação com a API
    try {
      final resposta = await http.post(
        url,
        body: json.encode({
          'titulo': produto.titulo,
          'descricao': produto.descricao,
          'preco': produto.preco,
          'imagemUrl': produto.imagemUrl,
          'criadorId': userId,
        }),
      );
      // Resposta do servidor
      final novoProduto = Produto(
        id: DateTime.now().toString(),
        titulo: produto.titulo,
        descricao: produto.descricao,
        preco: produto.preco,
        imagemUrl: produto.imagemUrl,
      );
      _itens.add(novoProduto);

      notifyListeners();
    } catch (erro) {
      throw erro;
    }
  }

  Future<void> buscaProdutos([bool filtroUsuario = false]) async {
    final filtroString =
        filtroUsuario ? 'orderBy="criadorId"&equalTo="$userId"' : '';
    var url =
        'https://flutter-update-ef19b.firebaseio.com/produtos.json?auth=$authToken&$filtroString'; // Url de comunicação com a API
    try {
      final resposta = await http.get(url); // Busca produtos na API
      final extrairDados = json.decode(resposta.body)
          as Map<String, dynamic>; // Extrai os dados da requisição get
      url =
          'https://flutter-update-ef19b.firebaseio.com/userFavoritos/$userId.json?auth=$authToken';
      final favoritoResposta = await http.get(url);
      final favoritoData = json.decode(favoritoResposta
          .body); // Recebe a opção favorito do produto de cada usuario
      final List<Produto> carregaProdutos = [];
      // Verifica se retonar algum dado ou nulo
      if (extrairDados != null) {
        extrairDados.forEach((prodId, prodDado) {
          carregaProdutos.add(Produto(
            id: prodId,
            titulo: prodDado['titulo'],
            preco: prodDado['preco'],
            descricao: prodDado['descricao'],
            imagemUrl: prodDado['imagemUrl'],
            isFavorito:
                favoritoData == null ? false : favoritoData[prodId] ?? false,
          ));
        });
        _itens = carregaProdutos;
      } else {
        _itens = carregaProdutos;
      }

      notifyListeners();
    } catch (erro) {
      throw erro;
    }
  }

// Atualiza produto
  Future<void> updateProduto(String id, Produto novoProduto) async {
    final prodIndex = _itens.indexWhere(
        (prod) => prod.id == id); // Obtem a posição do produto com msm id

// Verifica a posição é valida
    if (prodIndex >= 0) {
      final url =
          'https://flutter-update-ef19b.firebaseio.com/produtos/$id.json?auth=$authToken';

      await http.patch(url,
          body: json.encode({
            'titulo': novoProduto.titulo,
            'preco': novoProduto.preco,
            'descricao': novoProduto.descricao,
            'imagemUrl': novoProduto.imagemUrl,
          }));
      _itens[prodIndex] = novoProduto;
      notifyListeners();
    } else {
      print('...');
    }
  }

// Remove produto
  Future<void> deletaProduto(String id) async {
    final url =
        'https://flutter-update-ef19b.firebaseio.com/produtos/$id.json?auth=$authToken';
    final existeProdutoIndex = _itens.indexWhere((prod) => prod.id == id);
    var existeProduto = _itens[existeProdutoIndex];
    _itens.removeAt(existeProdutoIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _itens.insert(existeProdutoIndex, existeProduto);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existeProduto = null;
  }
}
