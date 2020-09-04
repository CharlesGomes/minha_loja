import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/produto.dart';
import '../providers/produtos.dart';

class EditProdutoScreen extends StatefulWidget {
  static const routeName = '/edit-produtos';

  @override
  _EditProdutoScreenState createState() => _EditProdutoScreenState();
}

class _EditProdutoScreenState extends State<EditProdutoScreen> {
  final _precoFocusNode = FocusNode();
  final _descricaoFocusNode = FocusNode();
  final _imagemUrlController = TextEditingController();
  final _imagemFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editProduto = Produto(
    id: null,
    titulo: '',
    descricao: '',
    preco: 0,
    imagemUrl: '',
  ); // Inicia o estado do produto inicial

  var _iniciaValores = {
    'titulo': '',
    'descricao': '',
    'preco': '',
    'imagemUrl': '',
  };

  var _isInit = true;

  @override
  void initState() {
    _imagemFocusNode.addListener(_updateImagemUrl);
    super.initState();
  }

// Executa quando a pagina é aberta
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final produtoId = ModalRoute.of(context).settings.arguments
          as String; // Recupera o id passado por argumento
      if (produtoId != null) {
        // Verifica se id do produto esta nulo
        _editProduto = Provider.of<Produtos>(context, listen: false)
            .selecionaPorId(produtoId);
        _iniciaValores = {
          'titulo': _editProduto.titulo,
          'descricao': _editProduto.descricao,
          'preco': _editProduto.preco.toString(),
          //'imagemUrl': _editProduto.imagemUrl,
        };
        _imagemUrlController.text = _editProduto.imagemUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

// Limpa a memoria para que não haja vazamento com se usa o onfocus
  @override
  void dispose() {
    _imagemFocusNode.removeListener(_updateImagemUrl);
    _precoFocusNode.dispose();
    _descricaoFocusNode.dispose();
    _imagemUrlController.dispose();
    _imagemFocusNode.dispose();
    super.dispose();
  }

// Atualiza a imagem caso insira uma nova url
  void _updateImagemUrl() {
    if (!_imagemFocusNode.hasFocus) {
      setState(() {});
    }
  }

// Salva o formulario
  void _salvaFormulario() {
    final isValida = _form.currentState.validate();
    if (!isValida) {
      return;
    }
    _form.currentState.save();
    if (_editProduto.id != null) {
      Provider.of<Produtos>(context, listen: false)
          .updateProduto(_editProduto.id, _editProduto);
    } else {
      Provider.of<Produtos>(context, listen: false).addProduto(_editProduto);
    }

    // Adiciona a lista de produtos um novo produto
    Navigator.of(context).pop(); // Volta a pagina anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edita Produto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _salvaFormulario,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _iniciaValores['titulo'],
                decoration: InputDecoration(labelText: 'Titulo'),
                // Exibe as mensagens de erro
                validator: (value) {
                  if (value.isEmpty) {
                    // Campo vazio
                    return 'Insira um titulo';
                  }
                  return null;
                },
                textInputAction:
                    TextInputAction.next, // Botão proximo no teclado virtual
                // Ao clicar no botão proximo pula para o campo seguinte
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_precoFocusNode);
                },
                onSaved: (value) {
                  _editProduto = Produto(
                    titulo: value,
                    preco: _editProduto.preco,
                    descricao: _editProduto.descricao,
                    imagemUrl: _editProduto.imagemUrl,
                    id: _editProduto.id,
                    isFavorito: _editProduto.isFavorito,
                  );
                },
              ),
              TextFormField(
                initialValue: _iniciaValores['preco'],
                decoration: InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number, // Aciona o teclado numerico
                focusNode: _precoFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Insira um preço.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Preço inválido.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Preço deve ser maior que zero.';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descricaoFocusNode);
                },
                onSaved: (value) {
                  _editProduto = Produto(
                    titulo: _editProduto.titulo,
                    preco: double.parse(value),
                    descricao: _editProduto.descricao,
                    imagemUrl: _editProduto.imagemUrl,
                    id: _editProduto.id,
                    isFavorito: _editProduto.isFavorito,
                  );
                },
              ),
              TextFormField(
                initialValue: _iniciaValores['descricao'],
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descricaoFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    // Campo vazio
                    return 'Insira uma descrição';
                  }
                  if (value.length < 10) {
                    return 'Insira no minimo 10 caracteres.';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_imagemFocusNode);
                },
                onSaved: (value) {
                  _editProduto = Produto(
                    titulo: _editProduto.titulo,
                    preco: _editProduto.preco,
                    descricao: value,
                    imagemUrl: _editProduto.imagemUrl,
                    id: _editProduto.id,
                    isFavorito: _editProduto.isFavorito,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imagemUrlController.text.isEmpty
                        ? Text('Entre com a url')
                        : FittedBox(
                            child: Image.network(
                              _imagemUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Url Imagem'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imagemUrlController,
                      focusNode: _imagemFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          // Campo vazio
                          return 'Insira a url da imagem.';
                        }
                        if (!value.startsWith('https') &&
                            !value.startsWith('http')) {
                          return 'Url da imagem inválido.';
                        }
                        if (!value.endsWith('jpg') &&
                            !value.endsWith('png') &&
                            !value.endsWith('jpeg')) {
                          return 'Formato da imagem inválido.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        _salvaFormulario();
                      },
                      onSaved: (value) {
                        _editProduto = Produto(
                          titulo: _editProduto.titulo,
                          preco: _editProduto.preco,
                          descricao: _editProduto.descricao,
                          imagemUrl: value,
                          id: _editProduto.id,
                          isFavorito: _editProduto.isFavorito,
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
