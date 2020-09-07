import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/usuario_produto_screen.dart';
import '../screens/ordens_screen.dart';
import '../providers/auth.dart';

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
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/'); // Rota inicial
              // Chama função para deslogar usuario
              Provider.of<Auth>(context, listen: false)
                  .logout(); // Desloga usuario
            },
          ),
        ],
      ),
    );
  }
}
