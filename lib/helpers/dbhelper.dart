import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stockslog/helpers/statics.dart';
import 'package:stockslog/models/stocks_table.dart';

class DBHelper {
  static const dbName = Statics.DB_NAME;
  static final DBHelper _instance = new DBHelper.internal();

  DBHelper.internal();

  factory DBHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await setDB();
    return _db;
  }

  setDB() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, Statics.DB_FOLDER, dbName);

    var dB = await openDatabase(path,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return dB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(StocksTable.CREATE_TABLE);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute("DROP TABLE IF EXISTS ${StocksTable.TABLE_NAME}");

    _onCreate(db, newVersion);
  }

  //INSERT
  Future<int> addStock(StocksTable stock) async {
    var dbClient = await db;
    int res = await dbClient.insert(StocksTable.TABLE_NAME, stock.toMap());
    return res;
  }

  //GET
  Future<StocksTable> getStock({int id, String name}) async {
    var dbClient = await db;
    List<Map> stocks;

    if (id != null && name == null) {
      stocks = await dbClient.query(StocksTable.TABLE_NAME,
          where: StocksTable.ID + '=?', whereArgs: [id]);
    } else if (id == null && name != null) {
      stocks = await dbClient.query(StocksTable.TABLE_NAME,
          where: StocksTable.NAME + '=?', whereArgs: [name]);
    }

    if (stocks.length > 0) {
      return new StocksTable.fromMap(stocks.first);
    }
    return null;
  }

  //GET ALL
  Future<List<StocksTable>> getStocks() async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.query(StocksTable.TABLE_NAME, orderBy: StocksTable.NAME);
    List<StocksTable> stocks = new List();

    for (var node in list) {
      var stock = new StocksTable();
      stock.name = node[StocksTable.NAME];
      stock.buyDate = node[StocksTable.BUY_DATE];
      stock.sellDate = node[StocksTable.SELL_DATE];
      stock.buyPrice = node[StocksTable.BUY_PRICE];
      stock.sellPrice = node[StocksTable.SELL_PRICE];
      stock.comments = node[StocksTable.COMMENTS];
      stock.id = node[StocksTable.ID];
      stocks.add(stock);
    }

    return stocks;
  }

  //UPDATE
  Future<bool> updateStock(StocksTable stock) async {
    var dbClient = await db;
    var res = await dbClient.update(StocksTable.TABLE_NAME, stock.toMap(),
        where: StocksTable.ID + "=?", whereArgs: <int>[stock.id]);
    return res > 0 ? true : false;
  }

  //DELETE
  Future<int> deleteStock(StocksTable stock) async {
    var dbClient = await db;
    var res = await dbClient.delete(StocksTable.TABLE_NAME,
        where: StocksTable.ID + "=?", whereArgs: [stock.id]);
    return res;
  }
}
