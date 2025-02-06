import 'package:flutter/material.dart';
import 'package:quickremind/widgets/datetile_widget.dart';
import 'package:quickremind/widgets/memo_widget.dart';
import 'package:quickremind/controller/memo_controller.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import '../model/subject_model.dart';
import '../widgets/subjectcard.dart';
import 'package:quickremind/controller/timetable_controller.dart';

class HomeScreen extends StatefulWidget {
  final String uid;

  const HomeScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  final AppinioSwiperController _swiperController = AppinioSwiperController();
  TimetableController timetableController = TimetableController();
  List<SubjectModel> _subjects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubjects(widget.uid);
  }

  Future<void> _loadSubjects(String uid) async {
    List subjects = await timetableController.fetchSubjectsForToday(uid);
    _subjects = subjects.cast<SubjectModel>();
    setState(() {
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
          MemoWidget(controller: MemoController(uid: widget.uid)),
          Expanded(
            child: AppinioSwiper(
              invertAngleOnBottomDrag: true,
              backgroundCardCount: 3,
              swipeOptions: const SwipeOptions.symmetric(horizontal: true),
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
