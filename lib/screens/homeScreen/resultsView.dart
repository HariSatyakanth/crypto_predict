import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../../models/result.dart';
import '../../provider/resultProvider.dart';
import '../../utils/constants.dart';

class ResultsView extends StatefulWidget {
  @override
  _ResultsViewState createState() => _ResultsViewState();
}

class _ResultsViewState extends State<ResultsView>
    with TickerProviderStateMixin {
  DateTime? _selectedDate;
  late var prodata;

  @override
  void initState() {
    prodata = Provider.of<ResultProvider>(context, listen: false);
    DateTime? date = prodata.date;
    if (date == null) {
      prodata.setDate(DateTime.now());
      _selectedDate = DateTime.now();
    } else {
      _selectedDate = prodata.date;
    }
    super.initState();
  }

  void showCalender(context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1999),
            lastDate: DateTime.now())
        .then(
      (value) {
        setState(() {
          prodata.setDate(value);
          _selectedDate = value;
        });
      },
    );
  }

  List<Widget> getTableData(List<String> data, int start, int end) {
    List<String> matchNumbers = prodata.matchedNumbers ?? [];
    return data
        .getRange(start, end)
        .map(
          (e) => Text(
            e,
            style: TextStyle(
                fontFamily: 'Teko',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: matchNumbers.contains(e)
                    ? Colors.red
                    : Colors.white), //Color(0xFF505050)
          ),
        )
        .toList();
  }

  Widget _tableText(String text) {
    List<String> matchNumbers = prodata.matchedNumbers ?? [];

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Teko',
        fontWeight: FontWeight.bold,
        fontSize: 25,
        color: matchNumbers.contains(text)
            ? Colors.red
            : Colors.white, //Color(0xFF505050)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Results',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Padding(
          padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: 55,
                decoration: BoxDecoration(
                  color: accentcolor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        _selectedDate != null
                            ? DateFormat('yyyy-MM-dd')
                                .format(_selectedDate!)
                                .toString()
                            : 'Pick a data',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showCalender(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: prodata.getResult(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  heightFactor: 5, child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text('No internet'),
                ),
              );
            }
            if (snapshot.data != null && snapshot.hasData) {
              Result data = snapshot.data! as Result;
              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(seconds: 1),
                builder: (context, dynamic size, child) {
                  return Column(children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: primarycolor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        'Draw Number : ${data.drawNumber}',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          transform: Matrix4.translationValues(
                              0, 0, 50 * (1.0 - size)),
                          padding: EdgeInsets.all(25),
                          width: MediaQuery.of(context).size.width / 3,
                          child: Column(
                            children: [
                              const Text(
                                '1st prize',
                                style: TextStyle(color: Colors.white),
                              ),
                              _tableText(data.firstPrize),
                            ],
                          ),
                          decoration: BoxDecoration(
                              // gradient: LinearGradient(
                              //     begin: Alignment.topCenter,
                              //     end: Alignment.bottomCenter,
                              //     colors: [
                              //       Colors.purple[100]!.withOpacity(size),
                              //       Colors.purple[200]!.withOpacity(size),
                              //       Colors.purple[300]!.withOpacity(size),
                              //     ]),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12, spreadRadius: 2.0)
                              ],
                              color: accentcolor.withOpacity(size).withRed(80),
                              shape: BoxShape.circle),
                        ),
                        Container(
                          transform: Matrix4.translationValues(
                              0, 0, 50 * (1.0 - size)),
                          padding: EdgeInsets.all(25),
                          width: MediaQuery.of(context).size.width / 3,
                          child: Column(
                            children: [
                              const Text('2nd prize',
                                  style: TextStyle(color: Colors.white)),
                              _tableText(data.secondPrize),
                            ],
                          ),
                          decoration: BoxDecoration(
                              // gradient: LinearGradient(
                              //   colors: [
                              //     Colors.purple[100]!.withOpacity(size),
                              //     Colors.purple[200]!.withOpacity(size),
                              //     Colors.purple[300]!.withOpacity(size),
                              //   ],
                              // ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12, spreadRadius: 2.0)
                              ],
                              color: accentcolor.withOpacity(size).withRed(80),
                              shape: BoxShape.circle),
                        ),
                        Container(
                          transform: Matrix4.translationValues(
                              0, 0, 50 * (1.0 - size)),
                          padding: EdgeInsets.all(25),
                          width: MediaQuery.of(context).size.width / 3,
                          child: Column(
                            children: [
                              const Text('3rd prize',
                                  style: TextStyle(color: Colors.white)),
                              _tableText(data.thirdPrize),
                            ],
                          ),
                          decoration: BoxDecoration(
                              // gradient: LinearGradient(colors: [
                              //   Colors.purple[100]!.withOpacity(size),
                              //   Colors.purple[200]!.withOpacity(size),
                              //   Colors.purple[300]!.withOpacity(size),
                              // ]),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12, spreadRadius: 2.0)
                              ],
                              color: accentcolor.withOpacity(size).withRed(80),
                              //color: Colors.purple.withOpacity(size),
                              shape: BoxShape.circle),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        // gradient: LinearGradient(
                        //     begin: Alignment.topCenter,
                        //     end: Alignment.bottomCenter,
                        //     colors: [
                        //       Colors.purple[100]!.withOpacity(size),
                        //       Colors.purple[200]!.withOpacity(size),
                        //       Colors.purple[300]!.withOpacity(size),
                        //     ]),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, spreadRadius: 2.0)
                        ],
                        color: accentcolor.withOpacity(size).withRed(80),
                      ),
                      transform:
                          Matrix4.translationValues(0, 50 * (1.0 - size), 0),
                      child: Column(
                        children: [
                          const Text(
                            'Special',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: getTableData(data.specialPrize, 0,
                                (data.specialPrize.length / 2).floor()),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: getTableData(
                                data.specialPrize,
                                (data.specialPrize.length / 2).floor(),
                                data.specialPrize.length),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        // gradient: LinearGradient(
                        //     begin: Alignment.topCenter,
                        //     end: Alignment.bottomCenter,
                        //     colors: [
                        //       Colors.purple[100]!.withOpacity(size),
                        //       Colors.purple[200]!.withOpacity(size),
                        //       Colors.purple[300]!.withOpacity(size),
                        //     ]),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, spreadRadius: 2.0)
                        ],
                        color: accentcolor.withOpacity(size).withRed(80),
                      ),
                      transform:
                          Matrix4.translationValues(0, 80 * (1.0 - size), 0),
                      child: Column(
                        children: [
                          const Text(
                            'Consolation',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: getTableData(
                                    data.consolationPrizes,
                                    0,
                                    (data.consolationPrizes.length / 2)
                                        .floor()),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: getTableData(
                                    data.consolationPrizes,
                                    (data.consolationPrizes.length / 2).floor(),
                                    data.consolationPrizes.length),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]);
                },
              );
            }
            return Container();
          },
        )
      ],
    );
  }
}
