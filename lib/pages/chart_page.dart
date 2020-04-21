import 'package:flutter/material.dart';
import 'package:stockslog/helpers/dbhelper.dart';
import 'package:stockslog/models/stocks_table.dart';
import 'package:stockslog/pages/benefit_chart.dart';
import 'package:stockslog/widgets/side_drawer.dart';

class ChartPage extends StatelessWidget {
  var db = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('نمودار'),
      ),
      drawer: SideDrawer(),
      body: FutureBuilder<List<StocksTable>>(
        future: db.getStocks(),
        builder:
            (BuildContext context, AsyncSnapshot<List<StocksTable>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('None'));
              break;
            case ConnectionState.waiting:
              return Center(child: Text('Waiting'));
              break;
            case ConnectionState.active:
              return Center(child: Text('Active'));
              break;
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error on recived data'),
                );
              }

              if (snapshot.data.isEmpty) {
                return Center(
                  child: Text('شما هنوز هیچ سهمی اضافه نکرده‌اید'),
                );
              }

              return BenefitChart(snapshot.data);
              break;
          }
          return Center(child: Text('برای شروع یک سهم جدید اضافه کنید'));
        },
      ),
    );
  }
}
