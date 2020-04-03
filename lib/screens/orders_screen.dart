import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Future futureData;

  // @override
  // void initState() {
  //   super.initState();
  //   futureData = _getData();
  // }

  // _getData() async {
  //   return await Provider.of<Orders>(context, listen: false).fetchAndSetOrder();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
          builder: (ctx, dataSnapshot) {
            switch (dataSnapshot.connectionState) {
              case ConnectionState.none:
                return Text('none');
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                if(dataSnapshot.data == null){
                  return Center(
                  child: Text('You don\'t have any order yet...'),
                );
                }
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemBuilder: (ctx, index) =>
                        OrderItem(orderData.orders[index]),
                    itemCount: orderData.orders.length,
                  ),);
              default:
                return Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ));
  }
}
