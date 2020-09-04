import 'package:flutter/material.dart';
import 'package:minha_loja/providers/produtos.dart';
import 'package:provider/provider.dart';
import '../screens/edit_produto_screen.dart';

class UsuarioProdutoItem extends StatelessWidget {
  final String id;
  final String titulo;
  final String imagemUrl;

  UsuarioProdutoItem(this.id, this.titulo, this.imagemUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(titulo),
      leading: CircleAvatar(
        backgroundImage:
            NetworkImage(imagemUrl), // Insere a imagem dentro do avatar
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProdutoScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Listen false - não ouve as alterações
                Provider.of<Produtos>(context, listen: false).deletaProduto(id);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
