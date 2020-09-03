import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './carrinho_screen.dart';
import '../widgets/produtos_grid.dart';
import '../widgets/badge.dart';
import '../providers/carrinho.dart';
import '../widgets/app_drawer.dart';

enum FiltrosOpcoes {
  Favoritos,
  Todos,
}

class ProdutosOverviewScreen extends StatefulWidget {
  @override
  _ProdutosOverviewScreenState createState() => _ProdutosOverviewScreenState();
}

class _ProdutosOverviewScreenState extends State<ProdutosOverviewScreen> {
  var _mostraFavoritos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FiltrosOpcoes valorSelecinado) {
              setState(() {
                // Faz a verificação das opções para filtrar os produtos
                if (valorSelecinado == FiltrosOpcoes.Favoritos) {
                  _mostraFavoritos = true;
                } else {
                  _mostraFavoritos = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Meus Favoritos'),
                value: FiltrosOpcoes.Favoritos,
              ),
              PopupMenuItem(
                child: Text('Mostrar Todos'),
                value: FiltrosOpcoes.Todos,
              ),
            ],
          ),
          // Mostra icone de carrinho no menu superior AppBar
          Consumer<Carrinho>(
            builder: (_, carrinho, ch) => Badge(
              child: ch,
              value: carrinho.itemCount
                  .toString(), // Chama a função que conta os itens do carrinho
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CarrinhoScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProdutosGrid(_mostraFavoritos),
    );
  }
}
