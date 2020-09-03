import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';

import '../providers/produtos.dart';
import '../widgets/usuario_produto_item.dart';

class UsuarioProdutoScreen extends StatelessWidget {
  static const routeName = '/usuario-produtos';

  @override
  Widget build(BuildContext context) {
    final produtosData = Provider.of<Produtos>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Produtos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: produtosData.itens.length,
          itemBuilder: (_, i) => Column(
            children: [
              UsuarioProdutoItem(
                produtosData.itens[i].titulo,
                produtosData.itens[i].imagemUrl,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
