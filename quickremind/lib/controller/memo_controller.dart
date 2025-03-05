import 'package:flutter/foundation.dart';
import '../model/memo_model.dart';
import '../repository/memo_repository.dart';

// メモデータを管理するコントローラー
class MemoController extends ChangeNotifier {
  final MemoRepository _repository;
  MemoModel? _memo;

  MemoController({required MemoRepository repository})
      : _repository = repository;

  // 現在のメモテキストを取得
  String get memoText => _memo?.text ?? '';

  // メモを読み込む
  Future<void> loadMemo(String uid) async {
    _memo = await _repository.fetchMemo(uid);
    notifyListeners();
  }

  Future<void> saveMemo(String uid, String text) async {
    final memo = MemoModel(text: text);
    await _repository.saveMemo(uid, memo);
    _memo = memo;
    notifyListeners();
  }
}
