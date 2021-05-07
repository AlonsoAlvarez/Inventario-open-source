/// Example of a stacked area chart.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ChartHome extends StatelessWidget {
  final String title;
  final List<charts.Series<dynamic, num>> seriesList;
  final bool animate;

  const ChartHome(
      {Key key,
      @required this.title,
      @required this.seriesList,
      @required this.animate})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            '$title',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          ),
          Container(
            height: 300,
            child: StackedAreaLineChart(
              seriesList,
              animate: animate,
            ),
          )
        ],
      ),
    );
  }
}

class StackedAreaLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedAreaLineChart(this.seriesList, {this.animate});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new charts.LineChart(seriesList,
          defaultRenderer:
              new charts.LineRendererConfig(includeArea: true, stacked: true),
          animate: animate),
    );
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
