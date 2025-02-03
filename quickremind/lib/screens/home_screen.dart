import 'package:flutter/material.dart';
import 'package:quickremind/widgets/datetile_widget.dart';
import 'package:quickremind/widgets/memo_widget.dart';
import 'package:quickremind/controller/memo_controller.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
// import '../controller/subject_controller.dart';
import '../model/subject_model.dart';
import '../widgets/subjectcard.dart';
import '../widgets/swipebutton_widget.dart';
import 'package:quickremind/controller/timetable_controller.dart';

class HomeScreen extends StatefulWidget {
  final String uid;

  const HomeScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  final TimetableController _controller = TimetableController();
  final AppinioSwiperController _swiperController = AppinioSwiperController();
  List<SubjectModel> _subjects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    List<SubjectModel> subjects = await _controller.getTodaySubjects();
    setState(() {
      _subjects = subjects.toSet().toList(); // 同じ教科を1つにまとめる
      isLoading = false;
    });
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
          MemoWidget(controller: MemoController(uid: widget.uid)),
          Expanded(
            child: AppinioSwiper(
              invertAngleOnBottomDrag: true,
              backgroundCardCount: 3,
              swipeOptions: const SwipeOptions.symmetric(horizontal: true),
              onCardPositionChanged: (
                SwiperPosition position,
              ) {},
              controller: _swiperController,
              cardCount: _subjects.length,
              cardBuilder: (BuildContext context, int index) {
                return ConfirmationCard(subject: _subjects[index]);
              },
            ),
          ),
          ConfirmationButtons(controller: _swiperController),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
