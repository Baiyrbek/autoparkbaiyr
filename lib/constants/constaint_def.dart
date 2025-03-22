const String globalUrl = "/p/autopark/app";
const String globalDomain = "https://kyrgyz.space";

class GlobalVars {
  static const List<String> adType = ["Легковые", "Спецтехника", "Мото"];
  static const List<String> payType = [
    "Наличными",
    "Выкуп",
    "Аренда",
    "Рассрочка",
    "На запчасти",
    "Возможен обмен",
  ];

  static const List<Map<String, String>> engine = [
    {
      "name": "Бензиновый двигатель",
      "img": "$globalDomain$globalUrl/../assets/oil.png",
    },
    {
      "name": "Дизельный двигатель",
      "img": "$globalDomain$globalUrl/../assets/oil.png",
    },
    {
      "name": "Газовый двигатель",
      "img": "$globalDomain$globalUrl/../assets/oil.png",
    },
    {
      "name": "Гибридный двигатель",
      "img": "$globalDomain$globalUrl/../assets/oil.png",
    },
    {
      "name": "Электрический двигатель",
      "img": "$globalDomain$globalUrl/../assets/el.png",
    },
  ];

  static const List<Map<String, String>> drive = [
    {
      "name": "Передний привод",
      "img": "$globalDomain$globalUrl/../assets/front.png",
    },
    {
      "name": "Полный привод",
      "img": "$globalDomain$globalUrl/../assets/full.png",
    },
    {
      "name": "Задний привод",
      "img": "$globalDomain$globalUrl/../assets/back.png",
    },
  ];

  static const List<Map<String, String>> transm = [
    {
      "name": "Автоматическая",
      "img": "$globalDomain$globalUrl/../assets/transm.png",
    },
    {
      "name": "Механическая",
      "img": "$globalDomain$globalUrl/../assets/transm.png",
    },
    {
      "name": "Роботизированная",
      "img": "$globalDomain$globalUrl/../assets/transm.png",
    },
    {
      "name": "Вариаторная",
      "img": "$globalDomain$globalUrl/../assets/transm.png",
    },
  ];

  static const List<Map<String, String>> color = [
    {"name": "Белый", "color": "#FFFFFF"},
    {"name": "Черный", "color": "#111111"},
    {"name": "Серебристый", "color": "#DDDDDD"},
    {"name": "Серый", "color": "#939290"},
    {"name": "Синий", "color": "#2E49F2"},
    {"name": "Красный", "color": "#E43C1F"},
    {"name": "Зелёный", "color": "#30B526"},
    {"name": "Коричневый", "color": "#926546"},
    {"name": "Бежевый", "color": "#F6F0D8"},
    {"name": "Голубой", "color": "#37A1F6"},
    {"name": "Золотистый", "color": "#F5C30C"},
    {"name": "Пурпурный", "color": "#CA0931"},
    {"name": "Жёлтый", "color": "#F6EB13"},
    {"name": "Фиолетовый", "color": "#9663C8"},
    {"name": "Оранжевый", "color": "#EF8E5B"},
    {"name": "Розовый", "color": "#F4C0CC"},
  ];

  static const List<String> owners = ["Один", "Два", "Три", "Четыре и более"];
  static const List<String> steering = ["Правый", "Левый"];
  static const List<String> condition = [
    "Идеальное",
    "Хорошее",
    "Битый тр.",
    "Аварийное",
    "На запчасти"
  ];
  static const List<String> customs = ["Растаможен", "Не растаможен"];
  static const List<String> avail = ["В наличии", "На заказ"];
  static const List<String> jamType = ["Километр", "Миля"];
  static const List<String> priceCur = ["сом", "\$"];
  static const String accounting = "";
  static const int vin = 0;
  static const List<String> region = [
    "Бишкек",
    "Баткен",
    "Жалал-Абад",
    "Ысык-Көл",
    "Наарын",
    "Ош",
    "Талас",
    "Чуй",
  ];
}
