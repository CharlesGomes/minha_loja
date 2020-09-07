import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ordens.dart' show Ordens;
import '../widgets/ordem_item.dart';
import '../widgets/app_drawer.dart';

class OrdensScreen extends StatelessWidget {
  static const routeName = '/ordens';

  @override
  Widget build(BuildContext context) {
    print('building orders');
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Seus pedidos'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Ordens>(context, listen: false).buscaOrdens(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return Center(
                child: Text('Um erro ocorreu!'),
              );
            } else {
              return Consumer<Ordens>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.ordens.length,
                  itemBuilder: (ctx, i) => OrdemItem(orderData.ordens[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
