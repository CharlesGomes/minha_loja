import 'package:flutter/material.dart';

class EditProdutoScreen extends StatefulWidget {
  @override
  _EditProdutoScreenState createState() => _EditProdutoScreenState();
}

class _EditProdutoScreenState extends State<EditProdutoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edita Produto'),
      ),
    );
  }
}
