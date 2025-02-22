import 'package:flutter/material.dart';
import 'package:quickremind/widgets/datetile_widget.dart';
import 'package:quickremind/widgets/memo_widget.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import '../model/subject_model.dart';
import '../widgets/subjectcard.dart';
import 'package:quickremind/controller/timetable_controller.dart';
import 'package:quickremind/controller/subject_controller.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final String uid;

  const HomeScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  final AppinioSwiperController _swiperController = AppinioSwiperController();
  List<SubjectModel> _subjects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    final timetableController = context.read<TimetableController>();
    final subjectController = context.read<SubjectController>();

    await Future.wait([
      timetableController.loadTimetable(widget.uid),
      subjectController.loadSubjects(widget.uid),
    ]);

    final today = DateTime.now().weekday - 1;
    final todaySchedule =
        timetableController.timetable?.getScheduleForDay(today) ?? [];

    // 重複を除外するために Set を使用
    final uniqueSubjects = todaySchedule
        .where((subjectId) => subjectId.isNotEmpty)
        .map((subjectId) => subjectController.subjects[subjectId])
        .where((subject) => subject != null)
        .cast<SubjectModel>()
        .toSet() // Set に変換して重複を除外
        .toList();

    setState(() {
      _subjects = uniqueSubjects;
      isLoading = false;
    });
  }

  void _onswipeEnd(
      int previousIndex, int currentIndex, SwiperActivity activity) {
    if (activity.direction == AxisDirection.right) {
      print('Swiped right');
    } else if (activity.direction == AxisDirection.left) {
      print('Swiped left');
      setState(() {
        _subjects.add(_subjects[previousIndex]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          DateTileWidget(
            date: _selectedDate,
          ),
          MemoWidget(uid: widget.uid),
          Expanded(
            child: _subjects.isEmpty
                ? Container()
                : AppinioSwiper(
                    invertAngleOnBottomDrag: true,
                    backgroundCardCount: 3,
                    swipeOptions:
                        const SwipeOptions.symmetric(horizontal: true),
                    onSwipeEnd: _onswipeEnd,
                    controller: _swiperController,
                    cardCount: _subjects.length,
                    cardBuilder: (BuildContext context, int index) {
                      return ConfirmationCard(subject: _subjects[index]);
                    },
                  ),
          ),
          Center(child: Text("スワイプして確認")),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
