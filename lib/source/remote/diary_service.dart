import 'package:incisive/utils/constants.dart';

class DiaryService {
  Future<Map<String, dynamic>> getPage(DateTime dateTime) async {
    try {
      await Future.delayed(Duration(seconds: 1));
      return {
        "text": Constants.mockedDiaryEntry.text,
      };
    } catch (e) {
      rethrow;
    }
  }
}
