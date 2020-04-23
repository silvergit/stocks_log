import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jalali_calendar/jalali_calendar.dart';
import 'package:persian_date/persian_date.dart';
import 'package:stockslog/helpers/dbhelper.dart';
import 'package:stockslog/models/stocks_table.dart';
import 'package:stockslog/pages/home.dart';

class AddNewStock extends StatefulWidget {
  final StocksTable stock;

  const AddNewStock({Key key, this.stock}) : super(key: key);

  @override
  _AddNewStockState createState() => _AddNewStockState();
}

class _AddNewStockState extends State<AddNewStock> {
  TextEditingController _stockNameController;
  TextEditingController _stockBuyPriceController;
  TextEditingController _stockSellPriceController;
  TextEditingController _stockCommentController;
  TextEditingController _stockBuyDateController;
  TextEditingController _stockSellDateController;
  bool _validateName;
  bool _validateSellPrice;
  bool _validateBuyPrice;
  bool _validateSellDate;

  @override
  void initState() {
    super.initState();

    _stockNameController = new TextEditingController();
    _stockCommentController = new TextEditingController();
    _stockBuyPriceController = new TextEditingController();
    _stockSellPriceController = new TextEditingController();
    _stockBuyDateController = new TextEditingController();
    _stockSellDateController = new TextEditingController();

    _stockBuyDateController.text = PersianDate(format: "yyyy/mm/dd").now;
    _stockSellDateController.text = '';

    if (widget.stock != null) {
      _stockNameController.text = widget.stock.name;
      _stockBuyDateController.text = widget.stock.buyDate;
      _stockSellDateController.text = widget.stock.sellDate;
      _stockBuyPriceController.text = widget.stock.buyPrice.toStringAsFixed(1);
      _stockSellPriceController.text = widget.stock.sellPrice == null
          ? null
          : widget.stock.sellPrice.toStringAsFixed(1);
      _stockCommentController.text = widget.stock.comments;
    }

    _validateName = false;
    _validateSellPrice = false;
    _validateBuyPrice = false;
    _validateSellDate = false;
  }

  @override
  void dispose() {
    _stockNameController.dispose();
    _stockCommentController.dispose();
    _stockBuyPriceController.dispose();
    _stockSellPriceController.dispose();
    _stockBuyDateController.dispose();
    _stockSellDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.stock == null ? 'سهم جدید' : 'ویرایش سهم'),
        ),
        body: _buildBody(),
        floatingActionButton: _buildFloatActionButton());
  }

  void _addStockToDB(String name, String comments, String buyDate,
      String sellDate, double buyPrice, double sellPrice) async {
    var db = DBHelper();
    StocksTable stock = StocksTable();
    stock.name = name;
    stock.comments = comments;
    stock.buyDate = buyDate;
    stock.sellDate = sellDate;
    stock.buyPrice = buyPrice;
    stock.sellPrice = sellPrice;

    await db.addStock(stock);
  }

  Future<void> _editStockInDb(String name, String comments, String buyDate,
      String sellDate, double buyPrice, double sellPrice) async {
    var db = DBHelper();
    StocksTable stock = StocksTable();
    stock.id = widget.stock.id;
    stock.name = name;
    stock.comments = comments;
    stock.buyDate = buyDate;
    stock.sellDate = sellDate;
    stock.buyPrice = buyPrice;
    stock.sellPrice = sellPrice;

    await db.updateStock(stock);
  }

  _buildFloatActionButton() {
    return FloatingActionButton(
      onPressed: () {
        _stockNameController.text.isEmpty
            ? setState(() => _validateName = true)
            : setState(() => _validateName = false);

        _stockBuyPriceController.text.isEmpty
            ? setState(() => _validateBuyPrice = true)
            : setState(() => _validateBuyPrice = false);

//        _stockSellPriceController.text.isEmpty
//            ? setState(() => _validateSellPrice = true)
//            : setState(() => _validateSellPrice = false);

        if (_stockSellPriceController.text.isNotEmpty) {
          _stockSellDateController.text.isEmpty
              ? setState(() => _validateSellDate = true)
              : setState(() => _validateSellDate = false);
        }

//        if (_validateName || _validateBuyPrice || _validateSellPrice) {
        if (_validateName || _validateBuyPrice) {
          return;
        }

        if (_stockSellPriceController.text.isNotEmpty) {
          if (_validateSellDate) {
            return;
          }
        }

        if (widget.stock != null) {
          _editStockInDb(
              _stockNameController.text,
              _stockCommentController.text,
              _stockBuyDateController.text,
              _stockSellDateController.text,
              double.tryParse(_stockBuyPriceController.text),
              double.tryParse(_stockSellPriceController.text));
        } else {
          _addStockToDB(
              _stockNameController.text,
              _stockCommentController.text,
              _stockBuyDateController.text,
              _stockSellDateController.text,
              double.tryParse(_stockBuyPriceController.text),
              double.tryParse(_stockSellPriceController.text));
        }
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
      },
      child: Icon(Icons.done),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                _buildName(),
                _buildBuyPrice(),
                _buildBuyDate(),
                SizedBox(
                  height: 10.0,
                ),
                _buildSellPrice(),
                _buildSellDate(),
                _buildComment()
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildName() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'نام سهم',
        errorText: _validateName ? 'نام سهم نمی‌تواند خالی باشد' : null,
      ),
      controller: _stockNameController,
    );
  }

  _buildBuyPrice() {
    return TextField(
      controller: _stockBuyPriceController,
      keyboardType: TextInputType.numberWithOptions(),
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        labelText: 'مجموع خرید',
        errorText: _validateBuyPrice ? 'مجموع خرید نمی‌تواند خالی باشد' : null,
        icon: Icon(
          Icons.add_circle_outline,
          color: Colors.green,
        ),
      ),
    );
  }

  _buildSellPrice() {
    return TextField(
      controller: _stockSellPriceController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        labelText: 'مجموع فروش',
//        errorText: _validateSellPrice ? 'مجموع فروش نمی‌تواند خالی باشد' : null,
        icon: Icon(
          Icons.remove_circle_outline,
          color: Colors.red,
        ),
      ),
    );
  }

  _buildBuyDate() {
    return TextField(
      onTap: () => _selectDate('BUY'),
      controller: _stockBuyDateController,
      keyboardType: TextInputType.numberWithOptions(),
      decoration: InputDecoration(
          labelText: 'تاریخ خرید',
          icon: Icon(
            Icons.calendar_today,
            color: Colors.green,
          )),
    );
  }

  _buildSellDate() {
    return TextField(
      onTap: () => _selectDate('SELL'),
      controller: _stockSellDateController,
      keyboardType: TextInputType.numberWithOptions(),
      decoration: InputDecoration(
        labelText: 'تاریخ فروش',
        icon: Icon(
          Icons.calendar_today,
          color: Colors.red,
        ),
        errorText: _validateSellDate ? 'تاریخ فروش نمی‌تواند خالی باشد' : null,
      ),
    );
  }

  _buildComment() {
    return TextField(
      maxLines: 4,
      decoration: InputDecoration(labelText: 'توضیحات'),
      controller: _stockCommentController,
    );
  }

  Future _selectDate(String position) async {
    String picked = await jalaliCalendarPicker(
        context: context,
        convertToGregorian: false,
        showTimePicker: false,
        selectedFormat: "yyyy/mm/dd",
        hore24Format: true);
    if (picked != null)
      setState(() => position == 'BUY'
          ? _stockBuyDateController.text = picked
          : _stockSellDateController.text = picked);
  }
}
