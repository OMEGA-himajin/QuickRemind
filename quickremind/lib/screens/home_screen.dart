import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:provider/provider.dart';
import '../widgets/confirm_card.dart';
import '../widgets/datetile_widget.dart';
import '../widgets/memo_widget.dart';
import '../model/subject_model.dart';
import '../controller/timetable_controller.dart';
import '../controller/subject_controller.dart';
import '../controller/confirm_card_controller.dart';

class HomeScreen extends StatefulWidget {
  final String uid;

  const HomeScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ConfirmCardController _confirmCardController;
  List<SubjectModel> _subjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final timetableController = context.read<TimetableController>();
    final subjectController = context.read<SubjectController>();
    _confirmCardController = ConfirmCardController(
      timetableController: timetableController,
      subjectController: subjectController,
    );
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    try {
      _subjects = await _confirmCardController.getTodaySubjects(widget.uid);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading subjects: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          DateTileWidget(date: DateTime.now()),
          MemoWidget(uid: widget.uid),
          Expanded(
            child: _subjects.isEmpty
                ? Container()
                : AppinioSwiper(
                    invertAngleOnBottomDrag: true,
                    backgroundCardCount: 3,
                    swipeOptions:
                        const SwipeOptions.symmetric(horizontal: true),
                    cardCount: _subjects.length,
                    cardBuilder: (context, index) {
                      return ConfirmationCard(subject: _subjects[index]);
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
