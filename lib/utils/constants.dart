import 'package:incisive/models/diary_model.dart';
import 'package:intl/intl.dart';

class Constants {
  static DiaryEntry mockedDiaryEntry = DiaryEntry(
    DateTime.now(),
    "Pensieri del giorno\n\n"
    "Questa è una pagina di diario di esempio.\n"
    "La data attuale è:\n\n"
    "${DateFormat('dd/MM/yyyy').format(DateTime.now())}\n\n"
    "Puoi aggiungere contenuti personalizzati qui.",
  );
}
