import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';


import '../widgets/app_drawer.dart';
import '../providers/orders.dart';

class AnalysisScreen extends StatefulWidget {
  static const routeName = '/analysis';

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  List<charts.Series> seriesList;

  List<OrderItem> graphData = [];
  List<GraphValue> graphValue = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final List<OrderItem> graphData =
        Provider.of<Orders>(context, listen: false).orders;
    graphData
        .forEach((order) => print('${order.amount} and ${order.dateTime}'));
    graphData.forEach(
      (data) => {
        graphValue.add(
          new GraphValue(data.amount, data.dateTime),
        ),
      },
    );
    seriesList = _createRandomData();
  }

  List<charts.Series<GraphValue, DateTime>> _createRandomData() {
    final orderData = graphValue;
    print(orderData.toString());

    return [
      charts.Series<GraphValue, DateTime>(
        id: 'Your Orders',
        domainFn: (GraphValue gv, _) => gv.dateTime,
        measureFn: (GraphValue gv, _) => gv.amount,
        data: orderData,
      )
    ];
  }

  barChart() {
    return charts.TimeSeriesChart(
      seriesList,
      animate: false,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis'),
      ),
      drawer: AppDrawer(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: barChart(),
      ),
    );
  }
}

class GraphValue {
  final double amount;
  final DateTime dateTime;

  GraphValue(this.amount, this.dateTime);
}
