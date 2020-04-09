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

  double highestOrderAmount = 0.0;
  DateTime highestOrderDate;
  double _totalOrderAmount = 0.0;

  DateTime _datetimenow;
  double _prevMonthOrderAmount = 0;
  double _currentMonthOrderAmount = 0;

  double _percentageChange;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final List<OrderItem> graphData =
        Provider.of<Orders>(context, listen: false).orders;
    // graphData
    //     .forEach((order) => print('${order.amount} and ${order.dateTime}'));
    graphData.forEach(
      (data) => {
        graphValue.add(
          new GraphValue(data.amount, data.dateTime),
        ),
      },
    );
    graphValue.forEach(
      (data) => {
        _totalOrderAmount += data.amount,
        if (data.amount >= highestOrderAmount)
          {
            highestOrderAmount = data.amount,
            highestOrderDate = data.dateTime,
          }
      },
    );

    _datetimenow = DateTime.now();

    int _prevMonth = int.parse(DateFormat('MM').format(_datetimenow)) - 1;

    graphValue.forEach((data) => {
          if (DateFormat('MM/yyyy').format(data.dateTime) ==
              DateFormat('MM/yyyy').format(_datetimenow))
            {
              _currentMonthOrderAmount += data.amount,
            }
          else if (int.parse(DateFormat('MM').format(data.dateTime)) ==
              _prevMonth)
            {
              _prevMonthOrderAmount += data.amount,
            }
        });

    _percentageChange =
        ((_currentMonthOrderAmount - _prevMonthOrderAmount) * 100) /
            (_prevMonthOrderAmount);

    // print('Percentage Change: ${_percentageChange.toStringAsFixed(2)}');
    // print('Total Order Amount: $_totalOrderAmount');
    // print('Prev Month Order Total: $_prevMonthOrderAmount');
    // print('Current Month Order Total: $_currentMonthOrderAmount');

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
              Container(
                height: 350,
                child: barChart(),
              ),
              Card(
                margin: EdgeInsets.all(5),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'THIS MONTH',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'INR $_currentMonthOrderAmount',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              // color: (_percentageChange < 0)
                              //     ? Colors.green
                              //     : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 1,
                        child: (_percentageChange < 0)
                            ? Icon(
                                Icons.arrow_downward,
                                color: Colors.green,
                              )
                            : Icon(
                                Icons.arrow_upward,
                                color: Colors.red,
                              ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'OVER LAST MONTH',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          _percentageChange.toStringAsFixed(2) == 'Infinity' ? Text(
                            'NO ORDERS',
                            style: TextStyle(
                              color: (_percentageChange < 0)
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ) : Text(
                            '${_percentageChange.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: (_percentageChange < 0)
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.all(5),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: 70,
                            width: MediaQuery.of(context).size.width / 2.8,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'HIGHEST SPENT ON SINGLE ORDER',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Text(
                            'INR $highestOrderAmount',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(5),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: 70,
                            width: MediaQuery.of(context).size.width / 2.8,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'TOTAL SPENT \n TILL NOW',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Text(
                            'INR $_totalOrderAmount',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Padding(
              //   padding: EdgeInsets.only(top: 25),
              //   child: Text(
              //     'Highest you have spent on single order is',
              //     style: TextStyle(fontSize: 18),
              //   ),
              // ),
              // Column(
              //   children: <Widget>[
              //     Padding(
              //       padding: EdgeInsets.only(top: 8),
              //       child: Text(
              //         'INR $highestOrderAmount',
              //         style: TextStyle(
              //           fontSize: 24,
              //           fontWeight: FontWeight.bold,
              //         ),
              //         textAlign: TextAlign.center,
              //       ),
              //     ),
              //     Padding(padding: EdgeInsets.only(top: 8), child: Text('on')),
              //     Padding(
              //       padding: EdgeInsets.only(top: 8),
              //       child: Text(
              //         '${DateFormat('dd/MM/yyyy hh:mm').format(highestOrderDate)}',
              //         style: TextStyle(
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold,
              //         ),
              //         textAlign: TextAlign.center,
              //       ),
              //     ),
              //     Divider(),
              //   ],
              // ),
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
