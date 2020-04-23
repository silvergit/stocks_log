import 'package:flutter/material.dart';
import 'package:flutter_slidable_list_view/flutter_slidable_list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockslog/helpers/dbhelper.dart';
import 'package:stockslog/models/stocks_table.dart';
import 'package:stockslog/pages/add_new_stock.dart';
import 'package:stockslog/widgets/persian_textview.dart';

class StocksList extends StatefulWidget {
  List<StocksTable> data;
  int listType;

  StocksList(this.data, this.listType);

  @override
  _StocksListState createState() => _StocksListState();

}

class _StocksListState extends State<StocksList> {
  List<StocksTable> stocks;

  int _gridIndex;
  double _commission = 1.42;

  @override
  void initState() {
    super.initState();

    stocks = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return widget.listType == 0 ? _buildListView() : _buildGridView();
  }

  _buildListItems(int index) {
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                stocks[index].name,
                softWrap: false,
                maxLines: 1,
              ),
            ),
          ),
          SizedBox(
            width: 8.0,
          ),
          Column(
            children: <Widget>[
              Text(
                stocks[index].buyDate,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.0),
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                stocks[index].sellDate,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        ],
      ),
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: _getAvatarBgColor(index),
        foregroundColor: Colors.white,
        child: TextFa(
          _getAvatarText(index),
          fontSize: 12.0,
        ),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 5 * 1 - 20,
                    child: Text(
                      'خرید',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width / 5 * 2 - 20,
                    child: SingleChildScrollView(
                      child: TextFa(
                        stocks[index].buyPrice.toStringAsFixed(1),
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width / 5 * 2 - 20,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextFa(
                              stocks[index].sellPrice == null
                                  ? ""
                                  : (stocks[index].sellPrice -
                                          stocks[index].buyPrice)
                                      .toStringAsFixed(2),
                              fontSize: 12.0,
                            ),
                            Tooltip(
                              message: 'سود یا ضرر بدون احتساب کمیسیون',
                              child: Icon(
                                Icons.help,
                                size: 14.0,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 5 * 1 - 20,
                    child: Text(
                      'فروش',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width / 5 * 2 - 20,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: TextFa(
                        stocks[index].sellPrice == null
                            ? ""
                            : stocks[index].sellPrice.toStringAsFixed(1),
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width / 5 * 2 - 20,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextFa(
                            stocks[index].sellPrice == null
                                ? ""
                                : _calculateCommission(stocks[index].buyPrice,
                                        stocks[index].sellPrice)
                                    .toStringAsFixed(2),
                            fontSize: 12.0,
                          ),
                          Tooltip(
                            message: 'سود یا ضرر با احتساب کمیسیون',
                            child: Icon(
                              Icons.help,
                              size: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              stocks[index].comments == ''
                  ? Container()
                  : Container(
                      child: Row(
                        children: <Widget>[
                          Text('توضیح', style: TextStyle(fontSize: 12.0)),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            stocks[index].comments,
                            style: TextStyle(fontSize: 12.0),
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  _buildGridItems(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _gridIndex = index;
        });
      },
      child: Card(
          color: _gridIndex == index ? Theme.of(context).backgroundColor : null,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(
                    radius: 25.0,
                    backgroundColor: _getAvatarBgColor(index),
                    foregroundColor: Colors.white,
                    child: TextFa(
                      _getAvatarText(index),
                      fontSize: 12.0,
                    ),
                  ),
                  Text(stocks[index].name),
                ],
              ),
            ),
          )),
    );
  }

  _calculateCommission(double buy, double sell) {
    double sub = sell - buy;
    if (sub == 0) {
      return (buy * -_commission) / 100;
    }

    return sub > 0
        ? sub - (sub * _commission / 100)
        : sub + (sub * _commission / 100);
  }

  double _calculatePercent(double buy, double profit) {
    return (profit * 100) / buy;
  }

  _deleteItem(int index) async {
    var db = DBHelper();
    await db.deleteStock(stocks[index]);

    setState(() {
      stocks.remove(stocks[index]);
    });
  }

  _editItem(int index) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AddNewStock(
          stock: stocks[index],
        ),
      ),
    );
  }

  _buildTopGridCard() {
    int index = _gridIndex;

    return index == null
        ? Card(
            child: Container(
              width: double.infinity,
              height: 150.0,
              child: Center(child: Text('نمایش اطلاعات سهم')),
            ),
          )
        : Card(
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15.0),
//                  color: Theme.of(context).backgroundColor,
                  child: Center(
                      child: Text(
                    stocks[index].name,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  )),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
//                  color: Theme.of(context).backgroundColor,
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 150.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'خرید',
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                Text(
                                  stocks[index].buyDate,
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: SingleChildScrollView(
                                child: TextFa(
                                  stocks[index].buyPrice.toStringAsFixed(1),
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 150.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'فروش',
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                Text(
                                  stocks[index].sellDate,
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: SingleChildScrollView(
                                child: TextFa(
                                  stocks[index].sellPrice == null
                                      ? ""
                                      : stocks[index]
                                          .sellPrice
                                          .toStringAsFixed(1),
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Theme.of(context).backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'سود و ضرر بدون احتساب کمیسیون',
                              style: TextStyle(fontSize: 10.0),
                            ),
                            TextFa(
                              stocks[index].sellPrice == null
                                  ? ""
                                  : (stocks[index].sellPrice -
                                          stocks[index].buyPrice)
                                      .toStringAsFixed(2),
                              fontSize: 12.0,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'سود و ضرر با احتساب کمیسیون',
                              style: TextStyle(fontSize: 10.0),
                            ),
                            TextFa(
                              stocks[index].sellPrice == null
                                  ? ""
                                  : _calculateCommission(stocks[index].buyPrice,
                                          stocks[index].sellPrice)
                                      .toStringAsFixed(2),
                              fontSize: 12.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                stocks[index].comments == ''
                    ? Container()
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Row(
                          children: <Widget>[
                            Text('توضیح', style: TextStyle(fontSize: 12.0)),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              stocks[index].comments,
                              style: TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
              ],
            ),
          );
  }

  _buildListView() {
    return SlideListView(
      itemBuilder: (bc, index) {
        return _buildListItems(index);
      },
      actionWidgetDelegate: ActionWidgetDelegate(2, (actionIndex, listIndex) {
        if (actionIndex == 0) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              )
            ],
          );
        } else if (actionIndex == 1) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.edit,
                color: Colors.white,
              )
            ],
          );
        } else {
          return null;
        }
      }, (int indexInList, int index, BaseSlideItem item) {
        if (index == 0) {
          _deleteItem(indexInList);
          item.close();
        } else if (index == 1) {
          _editItem(indexInList);
          item.close();
        } else {
          item.close();
        }
      }, [Colors.red.shade300, Colors.blue.shade300]),
      dataList: stocks,
      refreshCallback: () async {
        await Future.delayed(Duration(seconds: 2));

        return;
      },
      refreshWidgetBuilder: (Widget content, RefreshCallback callback) {
        return RefreshIndicator(
          child: content,
          onRefresh: callback,
        );
      },
    );
  }

  _buildGridView() {
    return Column(
      children: <Widget>[
        _buildTopGridCard(),
        Expanded(
          child: GridView.builder(
              itemCount: stocks.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                return _buildGridItems(index);
              }),
        ),
      ],
    );
  }

  Color _getAvatarBgColor(int index) {
    if (stocks[index].sellPrice == null) {
      return Colors.grey;
    }

    if (_calculatePercent(
            stocks[index].buyPrice,
            _calculateCommission(
                stocks[index].buyPrice, stocks[index].sellPrice)) >
        0) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  String _getAvatarText(int index) {
    if (stocks[index].sellPrice == null) {
      return "";
    }

    return _calculatePercent(
                stocks[index].buyPrice,
                _calculateCommission(
                    stocks[index].buyPrice, stocks[index].sellPrice))
            .toStringAsFixed(1) +
        '%';
  }
}
