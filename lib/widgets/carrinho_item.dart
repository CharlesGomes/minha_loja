import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/carrinho.dart';

class CarrinhoItem extends StatelessWidget {
  final String id;
  final String produtoId;
  final double preco;
  final int quantidade;
  final String titulo;

  CarrinhoItem(
    this.id,
    this.produtoId,
    this.titulo,
    this.preco,
    this.quantidade,
  );

  @override
  Widget build(BuildContext context) {
    // Widget descartavel
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart, // Direcão que permite apagar item
      // Exibe mensagem de confirmação de exclusão de item
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Deseja revomer o item?'),
            content: Text('Deseja remover o item do carrinho?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Não'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text('Sim'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        // Chama a função para remover o item do carrinho
        Provider.of<Carrinho>(context, listen: false).removeItem(produtoId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('R\$$preco'),
                ),
              ),
            ),
            title: Text(titulo),
            subtitle: Text('Total: R\$${preco * quantidade}'),
            trailing: Text('$quantidade X'),
          ),
        ),
      ),
    );
  }
}
