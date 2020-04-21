import 'package:flutter/material.dart';
import 'package:stockslog/helpers/dbhelper.dart';
import 'package:stockslog/models/stocks_table.dart';
import 'package:stockslog/pages/add_new_stock.dart';
import 'package:stockslog/pages/chart_page.dart';
import 'package:stockslog/pages/stocks_list.dart';
import 'package:stockslog/widgets/side_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int listType = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('سهم‌لاگ'),
        actions: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Icon(Icons.show_chart),
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChartPage())),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Icon(Icons.apps),
                  onTap: () {
                    setState(() {
                      listType == 0 ? listType = 1 : listType = 0;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: SideDrawer(),
      body: _createBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddNewStock()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _createBody() {
    var db = DBHelper();

    return FutureBuilder<List<StocksTable>>(
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
              return Center(child: Text('Error on recived data'));
            }

            if (snapshot.data.isEmpty) {
              return Center(child: Text('شما هنوز هیچ سهمی اضافه نکرده‌اید'));
            }

            return StocksList(snapshot.data, listType);
            break;
        }
        return Center(child: Text('برای شروع یک سهم جدید اضافه کنید'));
      },
    );
  }
}
