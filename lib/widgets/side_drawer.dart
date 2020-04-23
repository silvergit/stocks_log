import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:stockslog/pages/about_page.dart';
import 'package:stockslog/pages/backup_restore.dart';
import 'package:url_launcher/url_launcher.dart';

class SideDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SideDrawerState();
  }
}

class _SideDrawerState extends State<SideDrawer> {
  String _projectVersion = '';

  Future<void> _launched;
  String _bzrMoreAppsByMorface = 'https://cafebazaar.ir/developer/morface';
  String _mktMoreAppsByMorface = 'https://myket.ir/developer/dev-30540';
  String _bzrShelemShomarAddress = 'https://cafebazaar.ir/app/com.morface.shelem_shomar';
  String _mktShelemShomarAddress = 'https://myket.ir/app/com.morface.shelem_shomar';


  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    String projectVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'خطا در دریافت نسخه برنامه.';
    }

    if (!mounted) return;

    setState(() {
      _projectVersion = projectVersion;
    });
  }

  Widget _headerPart() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 20.0),
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/icon.png',
            width: 150.0,
            height: 150.0,
            // color: null,
          ),
          Center(
            child: Text(
              'سهم‌بان',
              style: TextStyle(fontSize: 24.0, color: Colors.white),
            ),
          ),
          Center(
            child: Text(
              'نسخه: $_projectVersion',
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backupPart() {
    return ListTile(
      title: Text('پشتیبان'),
      leading: Icon(Icons.backup),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => BackupRestore(0)));
      },
    );
  }

  Widget _restorePart() {
    return ListTile(
      title: Text('بازگردانی'),
      leading: Icon(Icons.restore),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => BackupRestore(1)));
      },
    );
  }

  Widget _aboutPart() {
    return ListTile(
      leading: Icon(Icons.question_answer),
      title: Text('درباره'),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => AboutPage()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          children: <Widget>[
            _headerPart(),
            _backupPart(),
            _restorePart(),
            _aboutPart(),
            _othersAppPart(),
            _shelemShomarPart(),
          ],
        ),
      ),
    );
  }

  _shelemShomarPart() {
    return
      ListTile(
        leading: Image.asset('assets/ss.png',width: 30,),
        title: Text('دانلود شلم شمار پیشرفته'),
        onTap: () {
          _launched = _launchInBrowser(_mktShelemShomarAddress);
        },
      );
  }

  _othersAppPart() {
    return
      ListTile(
        leading: Icon(Icons.apps),
        title: Text('برنامه‌های دیگر ما'),
        onTap: () {
          _launched = _launchInBrowser(_mktMoreAppsByMorface);
        },
      );
  }


  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

}