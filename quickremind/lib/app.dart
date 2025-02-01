import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/test.dart';
import 'screens/settings_screen.dart';
import 'controller/auth_controller.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;
  String? uid = AuthController().getCurrentUser()?.uid;

  // 各画面に対応するウィジェット
  final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    // TimetableScreen(),
  ];

  // タブのインデックスが変更されたときに呼ばれる
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'ホーム' : 'テスト'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // メニューを開く
              },
            );
          },
        ),
      ),

      body: _widgetOptions[_selectedIndex], // 画面の切り替え

      drawer: Drawer(
          // ハンバーガーメニュー
          child: Column(
        children: [
          Expanded(
              child: ListView(
            children: const [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'QuickRemind',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          )),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('設定'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsScreen(uid: uid!)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('ライセンス情報'),
            onTap: () {},
          ),
        ],
      )),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'テスト',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // アイテムタップ時の処理
      ),
    );
  }
}
