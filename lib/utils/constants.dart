import 'package:incisive/models/diary_model.dart';
import 'package:incisive/models/gratitude_page_model.dart';
import 'package:incisive/models/social_post_model.dart';
import 'package:incisive/models/user_model.dart';

class Constants {
  static DiaryModel mockedDiaryEntry = DiaryModel(
    date: DateTime.now(),
    text:
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
    score: 0.3,
    emotions: [],
    gratitudeAreas: [],
    nonGratitudeAreas: [],
  );

  static GratitudePageModel mockedGratitudeEntry = GratitudePageModel(
    id: "mocked_gratitude_id",
    date: DateTime.now(),
    list: List.generate(20, (index) => "Apprezzo il tempo trascorso all'aria aperta."),
  );

  static UserModel mockedUser = UserModel(
    id: "mocked_user_id",
    firstName: "Emanuele",
    lastName: "Lamagna",
    email: "emanuele.lamagna@studio.unibo.it",
    points: 100,
    level: 2,
    nextLevelPoints: 120,
    progress: 20,
  );

  static SocialPostModel mockedPostItem = SocialPostModel(
    id: "",
    authorId: "",
    approvedCommentsCount: 0,
    content:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
        "Quisque tincidunt imperdiet efficitur. Phasellus feugiat mauris id "
        "ante tempus, dignissim tincidunt nibh auctor. Vestibulum maximus "
        "sollicitudin dolor, et finibus ipsum dictum sit amet. Aliquam consequat "
        "ex at vulputate fermentum. Maecenas pellentesque rhoncus tellus id "
        "tempus. Maecenas massa purus, rhoncus in auctor quis, maximus a nulla. "
        "Vivamus at neque eget tortor eleifend cursus. Vestibulum lobortis "
        "placerat mauris, at commodo mauris egestas eu.",
    datetime: DateTime.now(),
    title: "Lorem ipsum dolor sit amet",
  );
}
