import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ordens.dart' show Ordens;
import '../widgets/ordem_item.dart';
import '../widgets/app_drawer.dart';

class OrdensScreen extends StatelessWidget {
  static const routeName = '/ordens';
  @override
  Widget build(BuildContext context) {
    final ordemData = Provider.of<Ordens>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: ordemData.ordens.length,
        itemBuilder: (ctx, i) => OrdemItem(ordemData.ordens[i]),
      ),
    );
  }
}
