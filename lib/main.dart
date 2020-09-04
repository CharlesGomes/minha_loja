import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/produtos_overview_screen.dart';
import './screens/produto_detalhe_screen.dart';
import './providers/produtos.dart';
import './providers/carrinho.dart';
import './screens/carrinho_screen.dart';
import './providers/ordens.dart';
import './screens/ordens_screen.dart';
import './screens/usuario_produto_screen.dart';
import './screens/edit_produto_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MultiProvider - permite agrupar varios providers
    return MultiProvider(
      // Lista de providers
      providers: [
        // Provider de Produtos
        ChangeNotifierProvider(
          create: (ctx) => Produtos(),
        ),
        // Provider carrinho de compras
        ChangeNotifierProvider(
          create: (ctx) => Carrinho(),
        ),
        // Provider ordem
        ChangeNotifierProvider(
          create: (ctx) => Ordens(),
        ),
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProdutosOverviewScreen(),
        // Rotas da aplicação
        routes: {
          ProdutoDetalheScreen.routeName: (ctx) => ProdutoDetalheScreen(),
          CarrinhoScreen.routeName: (ctx) => CarrinhoScreen(),
          OrdensScreen.routeName: (ctx) => OrdensScreen(),
          UsuarioProdutoScreen.routeName: (ctx) => UsuarioProdutoScreen(),
          EditProdutoScreen.routeName: (ctx) => EditProdutoScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
      ),
      body: Center(
        child: Text('Vamos construir uma loja!'),
      ),
    );
  }
}
