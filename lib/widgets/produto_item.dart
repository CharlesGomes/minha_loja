import 'package:flutter/material.dart';
import '../screens/produto_detalhe_screen.dart';
import 'package:provider/provider.dart';
import '../providers/produto.dart';
import '../providers/carrinho.dart';

class ProdutoItem extends StatelessWidget {
  // final String id;
  // final String titulo;
  // final String imagemUrl;

  // ProdutoItem(this.id, this.titulo, this.imagemUrl);

  @override
  Widget build(BuildContext context) {
    // Extrai os dados para usar nos campos, mais não atualiza quando clico em botão favorito
    // OBS: listen false - não reconstroi o widget caso haja alteração
    final produto = Provider.of<Produto>(context, listen: false);
    final carrinho = Provider.of<Carrinho>(context, listen: false);
    return ClipRRect(
      // Usado para arrendodar as bordas de um retangulo
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          // Detecta toque na imagem
          onTap: () {
            // Ao clicar na imagem direciona para a pagina de detalhes do produto
            Navigator.of(context).pushNamed(
              ProdutoDetalheScreen.routeName,
              arguments: produto.id,
            );
          },
          child: Image.network(
            produto.imagemUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87, // ₢or de fundo do texto
          // Ouvinte alterar somente o icone favorito
          leading: Consumer<Produto>(
            builder: (ctx, produto, _) => IconButton(
              // Adiciona icone de favorito
              icon: Icon(// Marca icone com favorito ou não
                  produto.isFavorito ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                // Chamo a função que alterar estatus de favorito
                produto.alteraFavoritoStatus();
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            produto.titulo,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            // Adiciona icone de carrinho de compras
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Chamo a função que adiciona produto ao carrinho
              carrinho.addItem(produto.id, produto.preco, produto.titulo);
              Scaffold.of(context)
                  .hideCurrentSnackBar(); // Descarta a mensagem anteior e abre nova caso clicada mais de uma vez em seguida
              // Exibe mensagem ao adicionar item ao carrinho
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item adicionado ao carrinho!'),
                  duration: Duration(seconds: 2), // Duração da mensagem
                  action: SnackBarAction(
                    label: 'Desfazer',
                    onPressed: () {
                      carrinho.removeUltimoItem(produto.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
