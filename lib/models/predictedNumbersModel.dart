
class PredictedNumbersModel {
  final DateTime date;
  final String prime;
  final String primePer;
  final String second;
  final String secondPer;
  final String third;
  final String thirdPer;

  PredictedNumbersModel(
      {required this.date,
      required this.prime,
      required this.primePer,
      required this.second,
      required this.secondPer,
      required this.third,
      required this.thirdPer});

  factory PredictedNumbersModel.fromJson(Map<String, dynamic> numbers) {
    return PredictedNumbersModel(
        date: DateTime.tryParse(numbers['pdate']) ?? DateTime.now(),
        prime: numbers['prime'] ?? '',
        primePer: numbers['primePer'] ?? '',
        second: numbers['second'] ?? '',
        secondPer: numbers['secondPer'] ?? '',
        third: numbers['third'] ?? '',
        thirdPer: numbers['thirdPer'] ?? '');
  }
}
