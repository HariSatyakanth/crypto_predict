import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../utils/constants.dart';
import '../../models/predictedNumbersModel.dart';
import '../../provider/predictedNumbersProvider.dart';

class PredictedNumbersView extends StatefulWidget {
  @override
  _PredictedNumbersViewState createState() => _PredictedNumbersViewState();
}

class _PredictedNumbersViewState extends State<PredictedNumbersView>
    with SingleTickerProviderStateMixin {
  late var predictionProvider;
  late Future predictionFuture;
  @override
  void initState() {
    predictionProvider =
        Provider.of<PredictedNumbersProvider>(context, listen: false);
    predictionFuture = predictionProvider.getPrdictedNumbers();
    super.initState();
  }

  void getPredictedData(String type) {
    predictionProvider.setType(type);
    setState(() {
      predictionFuture = predictionProvider.getPrdictedNumbers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: predictionFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container(
                padding: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.width * 0.45,
                child: Center(
                  child: Text(
                    'No Internet\n Check the network connection and Retry',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.8)),
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              PredictedNumbersModel data =
                  snapshot.data! as PredictedNumbersModel;
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, tweenSize, _) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 5, top: 5),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            DateFormat.yMMMd().format(data.date),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 2, left: 16, right: 16),
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Center(
                                    child: Stack(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                border: new Border.all(
                                                  width: 4,
                                                  color: Colors.teal.shade100,
                                                ) //HexColor('#d062f5').withOpacity(0.2)) //Color(0xFF2633C5).withOpacity(0.2)),
                                                ),
                                            child: Center(
                                              child: Text(
                                                '${(double.tryParse(data.prime)! * tweenSize).toInt()}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: 'Teko',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 28,
                                                    letterSpacing: 0.1,
                                                    color: Colors
                                                        .black //Color(0xFF2633C5).withOpacity(0.2),
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CustomPaint(
                                            painter: CurvePainter(
                                                colors: [
                                                  Colors.teal.shade400,
                                                  Colors.teal.shade300,
                                                  Colors.teal.shade100
                                                ],
                                                angle: math.pi *
                                                        double.tryParse(
                                                            data.primePer)! +
                                                    (360 -
                                                            math.pi *
                                                                double.tryParse(
                                                                    data.primePer)!) *
                                                        (1.0 - tweenSize)),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3 +
                                                  10,
                                              height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3 +
                                                  10,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  'Prime ${double.tryParse(data.primePer)}%',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    //   fontFamily:  FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    letterSpacing: 0.0,
                                    color: accentcolor,
                                  ),
                                ),
                              ],
                            ),
                            //SizedBox(width: 20),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Container(
                                            height: 50,
                                            width: 5,
                                            decoration: BoxDecoration(
                                              color: HexColor('#87A0E5')
                                                  .withOpacity(0.2),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                            ),
                                            child: Column(
                                              verticalDirection:
                                                  VerticalDirection.up,
                                              children: [
                                                Container(
                                                  width: 5,
                                                  height: ((double.tryParse(
                                                              data.secondPer)! *
                                                          0.5) *
                                                      tweenSize),
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        LinearGradient(colors: [
                                                      HexColor('#87A0E5'),
                                                      HexColor('#87A0E5')
                                                          .withOpacity(0.5),
                                                    ]),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                4.0)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Container(
                                        //   height: 48,
                                        //   width: 2,
                                        //   decoration: BoxDecoration(
                                        //     color: Colors.purpleAccent.withOpacity(
                                        //         0.5), //HexColor('#87A0E5').withOpacity(0.5),
                                        //     borderRadius: BorderRadius.all(
                                        //         Radius.circular(4.0)),
                                        //   ),
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4, bottom: 2),
                                                child: Text(
                                                  'Second',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    letterSpacing: -0.1,
                                                    color: accentcolor,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4, bottom: 3),
                                                    child: Text(
                                                      '${(double.tryParse(data.second)! * tweenSize).toInt()}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF17262A),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4, bottom: 3),
                                                    child: Text(
                                                      '${double.tryParse(data.secondPer)}%',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                        letterSpacing: -0.2,
                                                        color: accentcolor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Container(
                                            height: 50,
                                            width: 5,
                                            decoration: BoxDecoration(
                                              color: HexColor('#87A0E5')
                                                  .withOpacity(0.2),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                            ),
                                            child: Column(
                                              verticalDirection:
                                                  VerticalDirection.up,
                                              children: [
                                                Container(
                                                  width: 5,
                                                  height: ((double.tryParse(
                                                              data.thirdPer)! *
                                                          0.5) *
                                                      tweenSize),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        HexColor('#87A0E5'),
                                                        HexColor('#87A0E5')
                                                            .withOpacity(0.5),
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(4.0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Container(
                                        //   height: 48,
                                        //   width: 2,
                                        //   decoration: BoxDecoration(
                                        //     color: Colors.purpleAccent.withOpacity(
                                        //         0.5), //HexColor('#F56E98').withOpacity(0.5),
                                        //     borderRadius: BorderRadius.all(
                                        //         Radius.circular(4.0)),
                                        //   ),
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4, bottom: 2),
                                                child: Text(
                                                  'Third',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    letterSpacing: -0.1,
                                                    color: accentcolor,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4, bottom: 3),
                                                    child: Text(
                                                      '${(double.tryParse(data.third)! * tweenSize).toInt()}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                          color: Color(
                                                              0xFF17262A)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8, bottom: 3),
                                                    child: Text(
                                                      '${double.tryParse(data.thirdPer)}%',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                        letterSpacing: -0.2,
                                                        color: accentcolor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            return Center(
              heightFactor: 6,
              child: CircularProgressIndicator(),
            );
          },
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              color: Color(0xFFF2F3F8),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    primary: predictionProvider.whichType == 'Generic'
                        ? elevatedButtonColor
                        : Colors.grey),
                onPressed: () {
                  getPredictedData('Generic');
                },
                child: Text('Generic'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    primary: predictionProvider.whichType == 'Numaric'
                        ? elevatedButtonColor
                        : Colors.grey),
                onPressed: () {
                  getPredictedData('Numaric');
                },
                child: Text('Numaric'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    primary: predictionProvider.whichType == 'Name'
                        ? elevatedButtonColor //Theme.of(context).elevatedButtonTheme.style.backgroundColor
                        : Colors.grey),
                onPressed: () {
                  getPredictedData('Name');
                },
                child: Text('Name'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color>? colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color?>? colorsList = [];
    if (colors != null) {
      colorsList = colors;
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList as List<Color>,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

/*
return Center(
                heightFactor: 5.9,
                child: CircularProgressIndicator(),
              );
 */
