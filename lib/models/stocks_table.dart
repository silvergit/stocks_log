class StocksTable {
  static const String TABLE_NAME = "stocks_table";

// database table and column names
  static const String ID          = "id";
  static const String NAME        = "name";
  static const String BUY_DATE    = "buy_date";
  static const String SELL_DATE   = "sell_date";
  static const String BUY_PRICE   = "buy_price";
  static const String SELL_PRICE  = "sell_price";
  static const String COMMENTS    = "comments";

// Query for create table players
  static const String CREATE_TABLE = "CREATE TABLE " +
      TABLE_NAME +
      "(" +
      ID +
      " INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE," +
      NAME +
      " TEXT NOT NULL," +
      BUY_DATE +
      " TEXT NOT NULL," +
      SELL_DATE +
      " TEXT NOT NULL," +
      BUY_PRICE +
      " REAL NOT NULL," +
      SELL_PRICE +
      " REAL NOT NULL," +
      COMMENTS +
      " TEXT " +
      ")";

  int id;
  String name;
  String buyDate;
  String sellDate;
  double buyPrice;
  double sellPrice;
  String comments;

  StocksTable();

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[NAME]       = name;
    map[COMMENTS]   = comments;
    map[BUY_PRICE]  = buyPrice;
    map[SELL_PRICE] = sellPrice;
    map[BUY_DATE]   = buyDate;
    map[SELL_DATE]  = sellDate;

    if (id != null) {
      map[ID] = id;
    }

    return map;
  }

  StocksTable.fromMap(Map<String, dynamic> map) {
    id        = map[ID];
    name      = map[NAME];
    comments  = map[COMMENTS];
    buyPrice  = map[BUY_PRICE];
    sellPrice = map[SELL_PRICE];
    buyDate   = map[BUY_DATE];
    sellDate  = map[SELL_DATE];
  }

  @override
  String toString() {
    return super.toString() + 'id: $id, name: $name, buyprice: $buyPrice, sellprice: $sellPrice, buyDate: $buyDate, selldate: $sellDate, comment: $comments';
  }
}
