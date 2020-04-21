import 'package:flutter/material.dart';
import 'package:stockslog/widgets/backup_widget.dart';
import 'package:stockslog/widgets/restore_widget.dart';
import 'package:stockslog/widgets/side_drawer.dart';

class BackupRestore extends StatefulWidget {
  final int initSelect;

  BackupRestore(this.initSelect);

  @override
  State<StatefulWidget> createState() {
    return _BackupRestoreState();
  }
}

class _BackupRestoreState extends State<BackupRestore> {
  int _selectedIndex;
  static List<Widget> _widgetOptions = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initSelect;
    _widgetOptions = <Widget>[
      BackupWidget(),
      RestoreWidget(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('پشتیبان/بازگردانی'),
      ),
      drawer: SideDrawer(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.backup),
            title: Text('پشتیبان'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restore),
            title: Text('بازگردانی'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
