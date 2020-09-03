import 'package:flutter/material.dart';
import '../screens/usuario_produto_screen.dart';
import '../screens/ordens_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Olá amigo!'),
            automaticallyImplyLeading:
                false, // Nunca adicionara botão de voltar no menu superior
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.shop),
              title: Text("Loja"),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/'); // Volta a raiz
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.payment),
              title: Text("Pedidos"),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                    OrdensScreen.routeName); // Volta a raiz
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.edit),
              title: Text("Gerir Produtos"),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                    UsuarioProdutoScreen.routeName); // Volta a raiz
              }),
        ],
      ),
    );
  }
}
