import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
  double highestOrderAmount = 0;
  DateTime highestOrderDate;

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
    graphValue.forEach(
      (data) => {
        if (data.amount >= highestOrderAmount)
          {
            highestOrderAmount = data.amount,
            highestOrderDate = data.dateTime,
          }
      },
    );
    seriesList = _createRandomData();
  }

  List<charts.Series<GraphValue, DateTime>> _createRandomData() {
    final orderData = graphValue;
    // print(orderData.toString());

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
      animate: true,
      animationDuration: Duration(seconds: 1),
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Divider(),
              Container(
                height: 350,
                child: barChart(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: Text(
                  'Highest you have spent on single order is',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'INR $highestOrderAmount',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 8), child: Text('on')),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      '${DateFormat('dd/MM/yyyy hh:mm').format(highestOrderDate)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GraphValue {
  final double amount;
  final DateTime dateTime;

  GraphValue(this.amount, this.dateTime);
}
