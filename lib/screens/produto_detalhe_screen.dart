import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/produtos.dart';

class ProdutoDetalheScreen extends StatelessWidget {
  //final String titulo;

  //ProdutoDetalheScreen(this.titulo);

  static const routeName = '/produto-detalhe';

  @override
  Widget build(BuildContext context) {
    // Recupero o id passado por parametro na rota
    final produtoId = ModalRoute.of(context).settings.arguments as String;
    // Chama o metodo que busca produto por id
    final carregaProduto =
        Provider.of<Produtos>(context, listen: false).selecionaPorId(produtoId);
    return Scaffold(
      appBar: AppBar(
        title: Text(carregaProduto.titulo),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                carregaProduto.imagemUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(),
            Text(
              'R\$${carregaProduto.preco}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                carregaProduto.descricao,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
