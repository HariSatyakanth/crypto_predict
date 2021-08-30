

class Result {
  final String firstPrize;
  final String secondPrize;
  final String thirdPrize;
  final String date;
  final List<String> consolationPrizes;
  final List<String> specialPrize;
  final String drawNumber;

  Result(
      {required this.firstPrize,
      required this.secondPrize,
      required this.thirdPrize,
      required this.date,
      required this.consolationPrizes,
      required this.drawNumber,
      required this.specialPrize});

  factory Result.fromJson(Map<String, dynamic> resultdata) {
    return Result(
      firstPrize: resultdata['First_Prize'] ?? '',
      secondPrize: resultdata['Second_Prize'] ?? '',
      thirdPrize: resultdata['Third_Prize'] ?? '',
      date: resultdata['rdate'] ?? '',
      consolationPrizes: resultdata['Consolation_Numbers'].split(',') ?? [''],
      specialPrize: resultdata['Special_Numbers'].split(',') ?? [''],
      drawNumber: resultdata['Draw_Number'] ?? '',
    );
  }
}
