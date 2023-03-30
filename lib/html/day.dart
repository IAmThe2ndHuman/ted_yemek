class Day {
  final int _dayOfTheWeek;
  final List<String> dishes;

  String get dayOfTheWeek {
    switch (_dayOfTheWeek) {
      case 1:
        return "Pazartesi";
      case 2:
        return "Salı";
      case 3:
        return "Çarşamba";
      case 4:
        return "Perşembe";
      case 5:
        return "Cuma";
      default:
        return "???";

    }
  }

  Day(this.dishes, this._dayOfTheWeek);

  @override
  String toString() {
    return "$_dayOfTheWeek ($dayOfTheWeek) : $dishes";
  }
}