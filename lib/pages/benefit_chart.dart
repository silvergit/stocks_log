import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:stockslog/helpers/bar_label_decorator_work_around.dart';
import 'package:stockslog/models/stocks_table.dart';

class BenefitChart extends StatefulWidget {
  final List<StocksTable> stocks;

  BenefitChart(this.stocks);

  @override
  _BenefitChartState createState() => _BenefitChartState();
}

class _BenefitChartState extends State<BenefitChart> {
  List<StocksTable> stocks;

  var yearData;
  var yearSeries;
  var yearChart;
  var yearChartWidget;

  var monthData;
  var monthSeries;
  var monthChart;
  var monthChartWidget;

  int _datePicked;

  List<Color> chartColors;

  double _commission = 1.42;

  @override
  void initState() {
    super.initState();
    stocks = widget.stocks;

    for(var item in stocks) {
      print(item.sellPrice.toString());
    }

    _datePicked = stocks.length < 2
        ? _getYearsList()[0]
        : _getYearsList()[(_getYearsList().length / 2).round()];

    chartColors = [
      Colors.red,
      Colors.yellow,
      Colors.blue,
      Colors.brown,
      Colors.deepOrange,
      Colors.deepPurple,
      Colors.pink,
      Colors.indigo,
      Colors.tealAccent,
      Colors.blueGrey,
      Colors.black54,
      Colors.orange,
      Colors.deepPurple,
      Colors.pink,
    ];

    yearData = _makeYearData();
    yearSeries = _makeSeries('YEAR');
    yearChart = _makeChart('YEAR');
    yearChartWidget = _makeChartWidget('YEAR');
  }

  @override
  Widget build(BuildContext context) {
    monthData = _makeMonthData();
    monthSeries = _makeSeries('MONTH');
    monthChart = _makeChart('MONTH');
    monthChartWidget = _makeChartWidget('MONTH');

    return ListView(
      children: <Widget>[
        Center(
          child: Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('میانگین درصد سود سالانه', style: TextStyle(fontSize: 18.0),),
                ),
                yearChartWidget,
              ],
            ),
          ),
        ),
        Center(
          child: Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('میانگین درصد سود ماهانه', style: TextStyle(fontSize: 18.0),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 8.0),
                  child: FluidSlider(
                    value: _datePicked * 1.0,
                    onChanged: (double newValue) {
                      setState(
                            () {
                          _datePicked = newValue.round();
                        },
                      );
                    },
                    min: _getYearsList()[0] * 1.0,
                    max: _getYearsList()[_getYearsList().length - 1] * 1.0,
                    labelsTextStyle: TextStyle(fontSize: 12.0),
                    valueTextStyle: TextStyle(fontSize: 12.0),
                    showDecimalValue: false,
                    sliderColor: Theme.of(context).accentColor,
                  ),
                ),
                monthChartWidget,
              ],
            ),
          ),
        )
      ],
    );
  }

  _calculateCommission(double buy, double sell) {
    double sub = sell - buy;
    if (sub == 0) {
      return (buy * -_commission / 100) * -1;
    }

    return sub > 0 ? sub - (sub * _commission / 100) : sub + (sub * 1.5 / 100);
  }

  double _calculatePercent(double buy, double profit) {
    return (profit * 100) / buy;
  }

  List<dynamic> _getYearsList() {
    int endYear = int.tryParse(stocks[0].buyDate.substring(0, 4));
    int startYear = int.tryParse(stocks[0].buyDate.substring(0, 4));

    for (var item in stocks) {
      int year = int.tryParse(item.buyDate.substring(0, 4));
      if (startYear > year) startYear = year;
    }

    for (var item in stocks) {
      int year = int.tryParse(item.buyDate.substring(0, 4));
      if (endYear < year) endYear = year;
    }

    List years =
    List.generate(endYear + 1 - startYear, (index) => startYear + index);

    return years;
  }

  _makeYearData() {
    Random rnd = Random();

    List years = _getYearsList();

    final List data = <BenefitsPerDate>[];

    for (var i = 0; i < years.length; i++) {
      double sumPercent = 0;
      int counter = 0;

      for (var item in stocks) {
        if (item.buyDate.substring(0, 4) == years[i].toString()) {
          sumPercent += _calculatePercent(item.buyPrice,
              _calculateCommission(item.buyPrice, item.sellPrice));
          counter++;
        }
      }

      data.add(new BenefitsPerDate(
          years[i].toString(),
          counter == 0 ? 0 : sumPercent / counter,
          chartColors[rnd.nextInt(chartColors.length)]));
    }

    return data;
  }

  _makeMonthData() {
    List month = [
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12'
    ];

    final List data = <BenefitsPerDate>[];

    for (var mon in month) {
      double sumPercent = 0;
      int counter = 0;

      for (var item in stocks) {
        if (item.buyDate.substring(0, 4) == _datePicked.toString()) {
          if (item.buyDate.substring(5, 7) == mon) {
            sumPercent += _calculatePercent(item.buyPrice,
                _calculateCommission(item.buyPrice, item.sellPrice));
            counter++;
          }
        }
      }

      data.add(new BenefitsPerDate(
          _getMonthName(mon),
          counter == 0 ? 0 : sumPercent / counter,
          Colors.primaries[Random().nextInt(Colors.primaries.length)]));
    }

    for (var item in data)
      print(item.date + ' ' + item.benefit.toString());

    return data;
  }

  double roundDouble(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  _makeSeries(String type) {
    var _series = [
      charts.Series<BenefitsPerDate, String>(
          domainFn: type == 'YEAR'
              ? (BenefitsPerDate clickData, _) => clickData.date
              : (BenefitsPerDate clickData, _) => '.      ' + clickData.date,
          measureFn: (BenefitsPerDate clickData, _) => clickData.benefit,
          colorFn: (BenefitsPerDate clickData, _) => clickData.color,
          id: 'Clicks',
          data: type == 'YEAR' ? yearData : monthData,
          labelAccessorFn: (BenefitsPerDate benefitsPerDate, _) =>

          '${benefitsPerDate.benefit.toStringAsFixed(1)}%')
    ];

    return _series;
  }

  _makeChart(String type) {
    var _chart = charts.BarChart(
      type == 'YEAR' ? yearSeries : monthSeries,
      animate: true,
      barRendererDecorator: BarLabelDecoratorWorkAround(),
      vertical: type == 'YEAR' ? true : false,
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
              minimumPaddingBetweenLabelsPx: 0,
              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 14, // size in Pts.
                  color: charts.MaterialPalette.black),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(
            // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 18, // size in Pts.
                  color: charts.MaterialPalette.black),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))),
    );
    return _chart;
  }

  _makeChartWidget(String type) {
    var _chartWidget = Padding(
      padding: EdgeInsets.all(12.0),
      child: SizedBox(
        height: type == 'YEAR' ? 200.0 : 300.0,
        child: type == 'YEAR' ? yearChart : monthChart,
      ),
    );

    return _chartWidget;
  }
}

String _getMonthName(String monthNumber) {
  switch (monthNumber) {
    case '01':
      return 'فروردین';
      break;
    case '02':
      return 'اردیبهشت';
      break;
    case '03':
      return 'خرداد';
      break;
    case '04':
      return 'تیر';
      break;
    case '05':
      return 'مرداد';
      break;
    case '06':
      return 'شهریور';
      break;
    case '07':
      return 'مهر';
      break;
    case '08':
      return 'آبان';
      break;
    case '09':
      return 'آذر';
      break;
    case '10':
      return 'دی';
      break;
    case '11':
      return 'بهمن';
      break;
    case '12':
      return 'اسفند';
      break;
  }
}

class BenefitsPerDate {
  final String date;
  final double benefit;
  final charts.Color color;

  BenefitsPerDate(this.date, this.benefit, Color color)
      : this.color = charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
