import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _projectVersion = '';

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
      projectVersion = 'خطا در دریافت نسخه برنامه';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _projectVersion = projectVersion;
    });
  }

  Widget _buildBackground(BuildContext context) {
    return new Container(
      color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );
  }

  Future<void> _launched;
  final String _phone = 'tel:+989134324132';
  final String _mailAddress =
      'mailto:pazhouhesh.ali@gmail.com?subject=StockNotes%20feedback';
  final String _message = 'sms:+989134324132';

  Future<void> _urlLauncher(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'آدرس دریافت نشد: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('درباره سهم‌بان'),
        elevation: 0,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return new Stack(
            children: <Widget>[
              _buildBackground(context),
              Center(
                child: new Container(
                  width: width,
                  padding: EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                    left: 16,
                    right: 16,
                  ),
                  margin:
                      EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: _buildContent(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _buildContent(BuildContext context) {
    bool portrait = MediaQuery.of(context).orientation == Orientation.portrait;

    Text _appName = Text(
      'سهم‌بان',
      style: TextStyle(fontSize: 24.0),
    );

    Text _version = Text('نسخه: $_projectVersion');

    Text _morfaceSoft = Text(
      'Morface Soft | مورفیس سافت',
      style: TextStyle(fontSize: 18.0),
    );

    Text _description = Text('محاسبه میانگین سود خرید و فروش سهم‌ها');

    Text _developer = Text('برنامه نویس: علیرضا پژوهش');

    Column _contact = Column(
      children: <Widget>[
        Text('تماس با ما'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.call),
              onPressed: () => setState(() {
                _launched = _urlLauncher(_phone);
              }),
            ),
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () => setState(() {
                _launched = _urlLauncher(_message);
              }),
            ),
            IconButton(
              icon: Icon(Icons.mail),
              onPressed: () => setState(() {
                _launched = _urlLauncher(_mailAddress);
              }),
            )
          ],
        ),
      ],
    );

    SizedBox _spaceH20 = SizedBox(
      height: 20.0,
    );

    SizedBox _spaceH30 = SizedBox(
      height: 30.0,
    );

    return portrait
        ? Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/icon.png',
                    height: 48.0,
                    width: 48.0,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  _appName,
                ],
              ),
              _version,
              _spaceH20,
              _morfaceSoft,
              _spaceH30,
              _description,
              _spaceH20,
              _developer,
              _spaceH30,
              _contact
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/icon.png',
                        height: portrait ? 48.0 : 96.0,
                        width: portrait ? 48.0 : 96.0,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Column(
                        children: <Widget>[
                          _appName,
                          _version,
                        ],
                      ),
                    ],
                  ),
                  _spaceH20,
                  _morfaceSoft,
                  _description,
                ],
              ),
              Column(
                children: <Widget>[
                  _spaceH20,
                  _developer,
                  _spaceH30,
                  _contact,
                ],
              ),
            ],
          );
  }
}
