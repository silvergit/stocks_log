import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:stockslog/helpers/filesize.dart';
import 'package:stockslog/helpers/statics.dart';
import 'package:stockslog/widgets/empty_db_pages.dart';

class RestoreWidget extends StatefulWidget {
  @override
  _RestoreWidgetState createState() => _RestoreWidgetState();
}

class _RestoreWidgetState extends State<RestoreWidget> {
  List<String> backupFiles = [];

  @override
  void initState() {
    super.initState();
    _getDirectoryFiles();
  }

  _getBackupDirectory() async {
    Directory dir = await getApplicationDocumentsDirectory();
    return dir;
  }

  _getDirectoryFiles() async {
    List<String> files = [];
    Directory dir = await _getBackupDirectory();
    Directory backupDir = Directory(dir.path + '/' + Statics.DB_BACKUP_FOLDER);

    print('backupdir: ' + backupDir.path);

    List contents = backupDir.listSync();
    for (var fileOrDir in contents) {
      if (fileOrDir is File) {
        files.add(fileOrDir.path);
      }
    }

    setState(() {
      backupFiles = files.reversed.toList();
    });
  }

  _copyDataBaseToBackupFolder(BuildContext context, String backupPath) async {
    String dbName = Statics.DB_NAME;
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path,Statics.DB_FOLDER , dbName);

    File dbFileBackup = File(backupPath);

    bool exists = await Directory(dir.path + Statics.DB_FOLDER).exists();

    if (!exists) {
      new Directory(dir.path + '/'+ Statics.DB_FOLDER +'/').create(recursive: true)
          // The created directory is returned as a Future.
          .then((Directory directory) {
        print(directory.path);
      });
    }
    if (await dbFileBackup.exists()) {
      final File restoreFile = await dbFileBackup.copy(dbPath);

      if (await restoreFile.exists()) {
        showSnackBar(context, 'اطلاعات با موفقیت بازنشانی شدند');
      } else {
        showSnackBar(context, 'خطا در بازنشانی اطلاعات');
      }
    } else {
      showSnackBar(context, 'فایل پایگاه داده موجود نیست');
    }
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  String _getBackupFileSize(String path) {
    var _file = File(path);
    int _fileSize = _file.lengthSync();
    String readableSize = fileSize(_fileSize);
    return readableSize;
  }

  String _getBackupLastModified(String path) {
    var _file = File(path);
    DateTime _fileDate = _file.lastModifiedSync();
    String date = _fileDate.year.toString() +
        '/' +
        _fileDate.month.toString() +
        '/' +
        _fileDate.day.toString();
    return date;
  }

  _shareBackupFile(String backupFile) async {
    File testFile = new File(backupFile);
    if (!await testFile.exists()) {
      await testFile.create(recursive: true);
      testFile.writeAsStringSync("test for share documents file");
    }
    ShareExtend.share(testFile.path, "file");
  }

  _deleteBackupFile(BuildContext pContext, int index) async {
    File dbFile = File(backupFiles[index]);

    if (await dbFile.exists()) {
      showDialog(
        context: pContext,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('فایل پستیبان را حذف می‌کنید؟'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    dbFile.delete();
                    showSnackBar(pContext, 'فایل پشتیبان با موفقیت حذف شد');

                    setState(() {
                      backupFiles.removeAt(index);
                    });
                  },
                  child: Text('بله')),
              FlatButton(
                  onPressed: () => Navigator.of(pContext).pop(),
                  child: Text('نه')),
            ],
          );
        },
      );
    } else {
      showSnackBar(pContext, 'خطا در حذف فایل پشتیبان');
    }
  }

  _selectBackUpFromInternalMemory(BuildContext context) async {
    String filePath;

    // Will filter and only let you pick files with svg extension
    filePath = await FilePicker.getFilePath(type: FileType.any);

    String fileExt = filePath.split('.').last;

    print(filePath);
    print(fileExt);

    if (fileExt != 'db') {
      showSnackBar(context, 'نوع فایل انتخاب شده درست نیست');
      return;
    } else {
      _copyDataBaseToBackupFolder(context, filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    String languageCode = Localizations.localeOf(context).languageCode;

    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? Column(
                children: <Widget>[
                  _buildTopCard(context),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildListView(context, languageCode),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildBottomCard(context),
                ],
              )
            : Row(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _buildTopCard(context),
                        SizedBox(
                          height: 2.0,
                        ),
                        _buildBottomCard(context),
                      ],
                    ),
                  ),
                  _buildListView(context, languageCode),
                ],
              );
      },
    );
  }

  Widget _buildListView(BuildContext context, String languageCode) {
    return backupFiles.length == 0
        ? Expanded(
            child: EmptyDbPages(
              text: 'هیچ فایل پشتیبانی موجود نیست',
            ),
          )
        : Expanded(
            child: ListView.builder(
              itemCount: backupFiles.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(basename(backupFiles[index]))),
                      subtitle: Column(
                        children: <Widget>[
                          Text('اندازه: ' +
                              _getBackupFileSize(backupFiles[index])),
                          Text('تاریخ: ' +
                              _getBackupLastModified(backupFiles[index])),
                        ],
                      ),
                      trailing: Container(
                        width: 100.0,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.share,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                _shareBackupFile(backupFiles[index]);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _deleteBackupFile(context, index);
                              },
                            ),
                          ],
                        ),
                      ),
                      onTap: () => _copyDataBaseToBackupFolder(
                          context, backupFiles[index]),
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          );
  }

  Widget _buildBottomCard(BuildContext context) {
    bool portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    double width = MediaQuery.of(context).size.width;

    return Card(
      child: Container(
        width: portrait ? double.infinity : width / 2 - 30,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              'یا از حافظه دستگاه انتخاب کنید',
              style: Theme.of(context).textTheme.body2,
            ),
            OutlineButton(
              child: Text('انتخاب فایل پشتیبان'),
              onPressed: () => _selectBackUpFromInternalMemory(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCard(BuildContext context) {
    bool portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    double width = MediaQuery.of(context).size.width;

    return Card(
      child: Container(
          width: portrait ? double.infinity : width / 2 - 30,
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(8.0),
          child: portrait
              ? Column(
                  children: <Widget>[
                    Text(
                      'یک نسخه پشتیبان را برای بازگردانی انتخاب کنید',
                      style: Theme.of(context).textTheme.body2,
                    ),
                    Text('بعد از بازگردانی تمام اطلاعات فعلی برنامه حذف خواهند شد')
                  ],
                )
              : Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'لطفا یک نسخه پشتیبان برای بازگردانی انتخاب کنید',
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ),
                    Container(
                      width: 40.0,
                      child: Tooltip(
                        message: 'بعد از بازگردانی تمام اطلاعات فعلی برنامه حذف خواهند شد',
                        child: IconButton(
                          icon: Icon(Icons.help),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }
}
