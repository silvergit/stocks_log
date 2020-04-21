import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockslog/helpers/dbhelper.dart';
import 'package:stockslog/helpers/statics.dart';

class BackupWidget extends StatefulWidget {
  @override
  _BackupWidgetState createState() => _BackupWidgetState();
}

class _BackupWidgetState extends State<BackupWidget> {
  _deleteSharedPreferences(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  copyDataBaseToBackupFolder(BuildContext context) async {
    String backUpName = DateTime.now().year.toString() +
        '-' +
        DateTime.now().month.toString() +
        '-' +
        DateTime.now().day.toString() +
        '_' +
        DateTime.now().hour.toString() +
        '-' +
        DateTime.now().minute.toString() +
        '-' +
        DateTime.now().second.toString() +
        '_backup.db';
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, Statics.DB_FOLDER, Statics.DB_NAME);
    String backupPath =
        join(dir.path, Statics.DB_BACKUP_FOLDER, backUpName);

    File dbFile = File(dbPath);

    if (!await Directory(dir.path + '/' + Statics.DB_BACKUP_FOLDER + '/')
        .exists()) {
      Directory(dir.path + '/' + Statics.DB_BACKUP_FOLDER + '/').create()
          // The created directory is returned as a Future.
          .then((Directory directory) {
        print(directory.path);
      });
    }

    if (await dbFile.exists()) {
      final File backupFile = await dbFile.copy(backupPath);

      if (await backupFile.exists()) {
        showSnackBar(context, 'فایل پشتیبان با موفقیت ساخته شد');
      } else {
        showSnackBar(context, 'خطا در ساخت فایل پشتیبان');
      }
    } else {
      showSnackBar(context, 'فایل پشتیبان وجود ندارد');
    }
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future _restoreDatabase(BuildContext appContext) async {
    showDialog(
        context: appContext,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                child: Text('تایید'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteDatabase(appContext);
                  _deleteSharedPreferences(context);
                },
              ),
              FlatButton(
                child: Text('انصراف'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
            content: Text('اطلاعات برنامه را حذف می‌کنید؟'),
          );
        });
  }

  _deleteDatabase(BuildContext context) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, Statics.DB_FOLDER, Statics.DB_NAME);

    File dbFile = File(dbPath);

    if (await dbFile.exists()) {
      dbFile.delete();
      showSnackBar(context, 'اطلاعات برنامه با موفقیت حذف شدند');
    } else {
      showSnackBar(context, 'خطا در حذف اطلاعات برنامه');
    }

    DBHelper().setDB();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? Column(
                children: <Widget>[
                  _buildBackupCard(context),
                  _buildRemoveDbCard(context)
                ],
              )
            : Row(
                children: <Widget>[
                  _buildBackupCard(context),
                  _buildRemoveDbCard(context)
                ],
              );
      },
    );
  }

  Widget _buildRemoveDbCard(BuildContext context) {
    bool portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    double width = MediaQuery.of(context).size.width;

    return Card(
      color: Theme.of(context).cardColor,
      child: Container(
        width: portrait ? double.infinity : width / 2 - 25,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              'حذف تمام اطلاعات',
              style: Theme.of(context).textTheme.body2,
            ),
            portrait
                ? Text(
                    'تمام اطلاعات شما حذف خواهند شد. از داشتن فایل پشتیبان مطمعن شوید.')
                : Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                          'تمام اطلاعات شما حذف خواهند شد. از داشتن فایل پشتیبان مطمعن شوید.'),
                    ),
                  ),
            OutlineButton(
              onPressed: () => _restoreDatabase(context),
              child: Text('حذف اطلاعات'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupCard(BuildContext context) {
    bool portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    double width = MediaQuery.of(context).size.width;

    return Card(
      color: Theme.of(context).cardColor,
      child: Container(
        width: portrait ? double.infinity : width / 2 - 25,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              'تهیه نسخه پشتیبان در حافظه دستگاه',
              style: Theme.of(context).textTheme.body2,
            ),
            portrait
                ? Text(
                    'شما می‌توانید از فایل پشتیبان در بقیه دستگاه‌ها هم استفاده کنید')
                : Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                          'شما می‌توانید از فایل پشتیبان در بقیه دستگاه‌ها هم استفاده کنید'),
                    ),
                  ),
            SizedBox(
              height: 15.0,
            ),
            OutlineButton(
              child: Text('حالا پشتیبان بگیر'),
              onPressed: () {
                copyDataBaseToBackupFolder(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
