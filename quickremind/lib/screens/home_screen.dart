import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:provider/provider.dart';
import '../model/subject_model.dart';
import '../controller/timetable_controller.dart';
import '../controller/subject_controller.dart';
import '../controller/confirm_card_controller.dart';
import '../widgets/confirm_card_widget.dart';
import '../widgets/datetile_widget.dart';
import '../widgets/memo_widget.dart';

// メイン画面、今日の教科を表示。
class HomeScreen extends StatefulWidget {
  final String uid; // ユーザーID

  const HomeScreen({super.key, required this.uid});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ConfirmCardController _confirmCardController; // 確認カードコントローラー
  List<SubjectModel> _subjects = []; // 教科リスト
  bool _isLoading = true; // ローディング状態を管理

  @override
  void initState() {
    super.initState();
    final timetableController = context.read<TimetableController>();
    final subjectController = context.read<SubjectController>();
    _confirmCardController = ConfirmCardController(
      timetableController: timetableController,
      subjectController: subjectController,
    );
    _loadSubjects(); // 教科をロード
  }

  // 教科を非同期でロードする
  Future<void> _loadSubjects() async {
    try {
      _subjects =
          await _confirmCardController.getTodaySubjects(widget.uid); // 今日の教科を取得
      setState(() {
        _isLoading = false; // ロード完了後、ローディング終了
      });
    } catch (e) {
      print('Error loading subjects: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // スワイプ終了時の処理
  void _onSwipeEnd(
      int previousIndex, int currentIndex, SwiperActivity activity) {
    if (activity.direction == AxisDirection.left) {
      setState(() {
        _subjects.add(_subjects[previousIndex]); // 左にスワイプした場合、前の教科を追加
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // ロード中表示
      );
    }

    return Scaffold(
      body: Column(
        children: [
          DateTileWidget(date: DateTime.now()), // 今日の日付を表示
          MemoWidget(uid: widget.uid), // メモウィジェットを表示
          Expanded(
            child: _subjects.isEmpty
                ? Container() // 教科がない場合は空のコンテナ
                : AppinioSwiper(
                    invertAngleOnBottomDrag: true,
                    backgroundCardCount: 3,
                    swipeOptions:
                        const SwipeOptions.symmetric(horizontal: true),
                    cardCount: _subjects.length,
                    onSwipeEnd: _onSwipeEnd,
                    cardBuilder: (context, index) {
                      return ConfirmCard(subject: _subjects[index]); // 確認カードを表示
                    },
                  ),
          ),
          const Center(child: Text("スワイプして確認")),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
