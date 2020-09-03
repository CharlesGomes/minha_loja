import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/carrinho.dart' show Carrinho;
import '../widgets/carrinho_item.dart';
import '../providers/ordens.dart';

class CarrinhoScreen extends StatelessWidget {
  static const routeName = '/carrinho';
  @override
  Widget build(BuildContext context) {
    // Configura ouvinte
    final carrinho = Provider.of<Carrinho>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Carrinho'),
      ),
      body: Column(
        children: <Widget>[
          // ₢ard do valor total dos itens do carrinho
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      'R\$${carrinho.totalMontante.toStringAsFixed(2)} ',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text(
                      'FAZER PEDIDO',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      Provider.of<Ordens>(context, listen: false).addOrdem(
                          carrinho.itens.values.toList(),
                          carrinho.totalMontante);
                      carrinho.limparCarrinho();
                    },
                  ),
                ],
              ),
            ),
          ),
          // Itens do carrinho
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: carrinho.itens.length,
              itemBuilder: (ctx, i) => CarrinhoItem(
                carrinho.itens.values.toList()[i].id,
                carrinho.itens.keys.toList()[i],
                carrinho.itens.values.toList()[i].titulo,
                carrinho.itens.values.toList()[i].preco,
                carrinho.itens.values.toList()[i].quantidade,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
