import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './produto.dart';
import '../models/http_exception.dart';

class Produtos with ChangeNotifier {
  // Lista privada, somente poderar se acessa dentro dessa class
  List<Produto> _itens = [];

  // var _mostraFavorito = false;

// Retorna uma copia da lista de produtos
  List<Produto> get itens {
    // Retorna a lista de favoritos para os produtos marcados com favorito
    // if (_mostraFavorito) {
    //   return _itens.where((prodItem) => prodItem.isFavorito).toList();
    // }
    // Retorna todos os produtos
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

// Atribui true a propriedade _mostraFavorito
  // void mostraFavoritos() {
  //   _mostraFavorito = true;
  //   notifyListeners();
  // }

// Atribui false a propriedade _mostraFavorito
  // void mostraTodos() {
  //   _mostraFavorito = false;
  //   notifyListeners();
  // }

// Adiciona um novo produto
  Future<void> addProduto(Produto produto) async {
    const url =
        'https://flutter-update-ef19b.firebaseio.com/produtos.json'; // Url de comunicação com a API
    try {
      final resposta = await http.post(
        url,
        body: json.encode({
          'titulo': produto.titulo,
          'descricao': produto.descricao,
          'preco': produto.preco,
          'imagemUrl': produto.imagemUrl,
          'isFavorito': produto.isFavorito,
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

  Future<void> buscaProdutos() async {
    const url =
        'https://flutter-update-ef19b.firebaseio.com/produtos.json'; // Url de comunicação com a API
    try {
      final resposta = await http.get(url); // Busca produtos na API
      final extrairDados = json.decode(resposta.body)
          as Map<String, dynamic>; // Extrai os daods da requisição get
      final List<Produto> carregaProdutos = [];
      extrairDados.forEach((prodId, prodDado) {
        carregaProdutos.add(Produto(
          id: prodId,
          titulo: prodDado['titulo'],
          preco: prodDado['preco'],
          descricao: prodDado['descricao'],
          imagemUrl: prodDado['imagemUrl'],
          isFavorito: prodDado['isFavorito'],
        ));
      });
      _itens = carregaProdutos;
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
          'https://flutter-update-ef19b.firebaseio.com/produtos/$id.json';

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
    final url = 'https://flutter-update-ef19b.firebaseio.com/produtos/$id.json';
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
