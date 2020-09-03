import 'package:flutter/material.dart';

class UsuarioProdutoItem extends StatelessWidget {
  final String titulo;
  final String imagemUrl;

  UsuarioProdutoItem(this.titulo, this.imagemUrl);

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
              onPressed: () {},
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
