import 'package:flutter/material.dart';
import 'package:minha_loja/screens/edit_produto_screen.dart';
import 'package:provider/provider.dart';
import '../providers/produtos.dart';
import '../widgets/app_drawer.dart';

import '../providers/produtos.dart';
import '../widgets/usuario_produto_item.dart';

class UsuarioProdutoScreen extends StatelessWidget {
  static const routeName = '/usuario-produtos';

// Função que ira atualizar os produtos na tela
  Future<void> _atualizaProdutos(BuildContext context) async {
    await Provider.of<Produtos>(context, listen: false).buscaProdutos(true);
  }

  @override
  Widget build(BuildContext context) {
    //final produtosData = Provider.of<Produtos>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Produtos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProdutoScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      // Widget para dar refresh(atualizar) pagina
      body: FutureBuilder(
        future: _atualizaProdutos(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _atualizaProdutos(context),
                    child: Consumer<Produtos>(
                      builder: (ctx, produtosData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: produtosData.itens.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UsuarioProdutoItem(
                                produtosData.itens[i].id,
                                produtosData.itens[i].titulo,
                                produtosData.itens[i].imagemUrl,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
