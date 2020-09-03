import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './produto_item.dart';
import '../providers/produtos.dart';

class ProdutosGrid extends StatelessWidget {
  final bool mostraFavs;

  ProdutosGrid(this.mostraFavs);

  @override
  Widget build(BuildContext context) {
    // Faz a comunicação com o provider da classe produtos para ter acesso a lista de produtos
    final produtosData = Provider.of<Produtos>(context);
    // Se produto marcado como favorito exibe na tela favorito senão não exibe
    final produtos =
        mostraFavs ? produtosData.favoritoItens : produtosData.itens;
    return GridView.builder(
      padding: const EdgeInsets.all(
          10.0), // Garante que haja um preenchimento ao redor da grade
      itemCount: produtos.length, // Quantidade de produtos carregados
      // Provedor de notificações
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: produtos[i],
        child: ProdutoItem(
            // produtos[i].id,
            // produtos[i].titulo,
            // produtos[i].imagemUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Quantidade de colunas
          childAspectRatio: 3 / 2, // altura / largura
          crossAxisSpacing: 10, // Espaçamento entre as colunas
          mainAxisSpacing: 10 // Espaço entre as linhas
          ),
    );
  }
}
