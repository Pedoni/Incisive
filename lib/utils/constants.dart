import 'package:incisive/models/diary_model.dart';
import 'package:incisive/models/gratitude_page_model.dart';

class Constants {
  static DiaryEntry mockedDiaryEntry = DiaryEntry(
    DateTime.now(),
    "Oggi è stata una giornata strana, piena di piccoli momenti "
    "in bilico tra stanchezza e gratitudine. Mi sono svegliato un po’ "
    "più teso del solito, con quella sensazione di avere troppe cose in "
    "testa e poco spazio per respirare. Però, mentre facevo colazione, ho"
    " notato un raggio di sole che entrava dalla finestra e per qualche"
    " motivo mi ha fatto sentire meglio.\n\nDurante la giornata ho cercato"
    " di restare concentrato, anche se non tutto è andato come volevo. Però"
    " ho avuto una conversazione carina con una persona che non sentivo da "
    "un po’. Mi ha fatto riflettere su quanto a volte basti davvero poco per"
    " sentirsi meno soli.\n\nStasera mi sono preso qualche minuto per me. Ho"
    " messo un po’ di musica tranquilla e ho provato a lasciare andare quello"
    " che non posso controllare. Non è semplice, ma ci sto lavorando. Forse"
    " non è stata una giornata perfetta… ma ci sono stati momenti belli, e"
    " va bene così.",
    0.3,
  );

  static GratitudePageModel mockedGratitudeEntry = GratitudePageModel(
    date: DateTime.now(),
    list: List.generate(20, (index) => "Apprezzo il tempo trascorso all'aria aperta."),
  );
}
