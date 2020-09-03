import 'dart:math';
import 'package:flutter/material.dart';
import '../providers/ordens.dart' as ord;
import 'package:intl/intl.dart';

class OrdemItem extends StatefulWidget {
  final ord.OrdemItem ordem;

  OrdemItem(this.ordem);

  @override
  _OrdemItemState createState() => _OrdemItemState();
}

class _OrdemItemState extends State<OrdemItem> {
  var _expande = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('R\$${widget.ordem.montante}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.ordem.dataTime),
            ),
            trailing: IconButton(
                icon: Icon(_expande ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expande = !_expande;
                  });
                }),
          ),
          if (_expande)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.ordem.produtos.length * 20.0 + 10, 100),
              child: ListView(
                children: widget.ordem.produtos
                    .map(
                      (prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            prod.titulo,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${prod.quantidade}XR\$${prod.preco}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
