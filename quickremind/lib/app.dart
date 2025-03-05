import 'package:flutter/material.dart';
import 'controller/auth_controller.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/timetable_screen.dart';
import 'screens/license_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = AuthController().getCurrentUser()?.uid;
  }

  // 各画面に対応するウィジェットを取得
  List<Widget> get _widgetOptions {
    if (uid == null) {
      return [
        HomeScreen(
          uid: uid!,
        ),
        const Center(child: CircularProgressIndicator())
      ];
    }
    return [
      HomeScreen(
        uid: uid!,
      ),
      TimetableScreen(uid: uid!)
    ];
  }

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
        title: Text(_selectedIndex == 0 ? 'ホーム' : '時間割'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
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
              if (uid != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsScreen(uid: uid!)));
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('ライセンス情報'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LicenseScreen()),
              );
            },
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
            icon: Icon(Icons.schedule),
            label: '時間割',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // アイテムタップ時の処理
      ),
    );
  }
}
