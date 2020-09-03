import 'package:flutter/material.dart';
import './produto.dart';

class Produtos with ChangeNotifier {
  // Lista privada, somente poderar se acessa dentro dessa class
  List<Produto> _itens = [
    Produto(
      id: 'p1',
      titulo: 'Camiseta vermelha',
      descricao: 'Uma camisa vermelha - é muito vermelha!',
      preco: 29.99,
      imagemUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Produto(
      id: 'p2',
      titulo: 'Calças',
      descricao: 'Um belo par de calças.',
      preco: 59.99,
      imagemUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Produto(
      id: 'p3',
      titulo: 'Lenço Amarelo',
      descricao:
          'Quente e aconchegante - exatamente o que você precisa para o inverno.',
      preco: 19.99,
      imagemUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Produto(
      id: 'p4',
      titulo: 'Uma panela',
      descricao: 'Prepare a refeição que quiser.',
      preco: 49.99,
      imagemUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

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

  void addProduto() {
    notifyListeners();
  }
}
