import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/produtos_overview_screen.dart';
import './screens/produto_detalhe_screen.dart';
import './providers/produtos.dart';
import './providers/carrinho.dart';
import './screens/carrinho_screen.dart';
import './providers/ordens.dart';
import './providers/auth.dart';
import './screens/ordens_screen.dart';
import './screens/usuario_produto_screen.dart';
import './screens/edit_produto_screen.dart';
import './screens/auth_screen.dart';
import 'providers/produtos.dart';
import 'screens/produtos_overview_screen.dart';
import './widgets/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MultiProvider - permite agrupar varios providers
    return MultiProvider(
        // Lista de providers
        providers: [
          // Provider autenticação
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          // Provider de Produtos
          ChangeNotifierProxyProvider<Auth, Produtos>(
            update: (ctx, auth, anteriorProdutos) => Produtos(
              auth.token,
              auth.userId,
              anteriorProdutos == null ? [] : anteriorProdutos.itens,
            ),
          ),
          // Provider carrinho de compras
          ChangeNotifierProvider(
            create: (ctx) => Carrinho(),
          ),
          // Provider ordem
          ChangeNotifierProxyProvider<Auth, Ordens>(
            update: (ctx, auth, anteriorOrdens) => Ordens(
              auth.token,
              auth.userId,
              anteriorOrdens == null ? [] : anteriorOrdens.ordens,
            ),
          ),
        ], // Reconstroi o material sempre que muda o estatus da autenticação
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Minha Loja',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            // Seleciona a tela caso usuario logado ou não
            home: auth.isAuth // Verifica se estamos autenticados
                ? ProdutosOverviewScreen()
                : FutureBuilder(
                    future: auth
                        .verificaAutoLogin(), // Verifica se usuario esta com login valido
                    builder: (ctx, authResultSnapshot) => authResultSnapshot
                                .connectionState ==
                            ConnectionState.waiting
                        ? SplashScreen() // Enquanto aguarda resulatdo mostrar uma tela(Widget) de espera
                        : AuthScreen(), // Quando terminar a espera mostra a tela de autenticação
                  ),
            // Rotas da aplicação
            routes: {
              ProdutoDetalheScreen.routeName: (ctx) => ProdutoDetalheScreen(),
              CarrinhoScreen.routeName: (ctx) => CarrinhoScreen(),
              OrdensScreen.routeName: (ctx) => OrdensScreen(),
              UsuarioProdutoScreen.routeName: (ctx) => UsuarioProdutoScreen(),
              EditProdutoScreen.routeName: (ctx) => EditProdutoScreen(),
            },
          ),
        ));
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
