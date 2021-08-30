import 'package:flutter/material.dart';

import 'package:prediction_app/screens/appdrawer.dart';
import 'package:prediction_app/widgets/noInternet.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../provider/histioryDataProvider.dart';
import '../widgets/historyFilter.dart';

class HistoryScreen extends StatefulWidget {
  static const routeName = '/history';
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String dropDownValue = 'This month';

  @override
  void initState() {
    // Provider.of<HistoryDataProvider>(context, listen: false).initState();

    super.initState();
  }

  List<String> compare(Map<String, dynamic> data) {
    List<String> prize = [];

    List<String> predictedNumbers = [
      data['Generic1'] ?? '',
      data['Generic2'] ?? '',
      data['Generic3'] ?? '',
      data['Numaric1'] ?? '',
      data['Numaric2'] ?? '',
      data['Numaric3'] ?? '',
      data['Name1'] ?? '',
      data['Name2'] ?? '',
      data['Name3'] ?? '',
    ];
    List<String> prizeNumbers = [
      data['First_Prize'] ?? '',
      data['Second_Prize'] ?? '',
      data['Third_Prize'] ?? '',
      ...data['Special_Numbers'].split(',') ?? '' as Iterable<String>,
      ...data['Consolation_Numbers'].split(',') ?? '' as Iterable<String>,
    ];
    prize = predictedNumbers
        .where((element) => prizeNumbers.contains(element))
        .toList();
    return prize;
  }

  Widget _singleList(Map<String, dynamic> data) {
    List<String> prize = compare(data);
    /*List<Widget> prizeText(Map<String, dynamic> prize) {
      List<Widget> prizeList = [];
      prize.forEach((key, value) {
        prizeList.add(Text('$key $value'));
      });
      return prizeList;
    }*/

    Widget _findMatched(String number) {
      return Text(number,
          style: TextStyle(
              color: prize.contains(number) ? Colors.red : Colors.black));
    }

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.yellow[800]!, Colors.orange[300]!])),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Draw Number: ${data['Draw_Number']}'),
              Text(DateFormat.yMMMd().format(DateTime.parse(data['date']))),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('Generic'),
                  _findMatched(data['Generic1']),
                  _findMatched(data['Generic2']),
                  _findMatched(data['Generic3']),
                ],
              ),
              Column(
                children: [
                  Text('Numaric'),
                  _findMatched(data['Numaric1']),
                  _findMatched(data['Numaric2']),
                  _findMatched(data['Numaric3']),
                ],
              ),
              Column(
                children: [
                  Text('Name'),
                  _findMatched(data['Name1']),
                  _findMatched(data['Name2']),
                  _findMatched(data['Name3']),
                ],
              ),
              /*  Column(children: [
                Text('prize'),
                if (prize != null && prize.isNotEmpty) ...prizeText(prize)
              ])*/
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text(
          'History',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HistoryFilter(),
          Consumer<HistoryDataProvider>(
            builder: (context, historyData, _) {
              return FutureBuilder(
                future: historyData.getHistoryData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                        child: Container(
                            child: Center(child: CircularProgressIndicator())));
                  }
                  if (snapshot.hasError) {
                    if (snapshot.error == 'No internet') {
                      return NoInternet();
                    }
                    return Expanded(
                      child: Center(
                        child: const Text(
                            'Something went wrong please try later.'),
                      ),
                    );
                  }
                  if (snapshot.data == null ||
                      (snapshot.data as List<dynamic>).length > 0) {
                    List<dynamic> data = snapshot.data! as List<dynamic>;
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'From: ${DateFormat('d-M-y').format(historyData.startdate)}'), //.yMMMMd()//DateFormat('d-M-y').format(historyData.startdate)
                              SizedBox(width: 8),
                              Text(
                                  'To: ${DateFormat('d-M-y').format(historyData.enddate)}'), //DateFormat('d-M-y').format(historyData.enddate)
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.75,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return _singleList(data[index]);
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return Expanded(
                    child: Center(
                      child: const Text(
                        'No data to view',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
/*
 Map<String, dynamic> compare(Map<String, dynamic> data) {
    Map<String, dynamic> prize = {};
    List<String> predictedNumbers = [
      data['Generic1'],
      data['Generic2'],
      data['Generic3'],
      data['Numaric1'],
      data['Numaric2'],
      data['Numaric3'],
      data['Name1'],
      data['Name2'],
      data['Name3'],
    ];
    Map<String, dynamic> prizeNumbers = {
      'First': data['First_Prize'],
      'Second': data['Second_Prize'],
      'Third': data['Third_Prize'],
      'Special': data['Special_Numbers'].split(','),
      'Consolation': data['Consolation_Numbers'].split(','),
    };
    prizeNumbers.forEach((key, value) {
      if (value.runtimeType.toString() == 'List<String>' && value.isNotEmpty) {
        List<String> temp;
        temp = value.where((val) => predictedNumbers.contains(val)).toList();
        if (temp.isNotEmpty) {
          prize.putIfAbsent(key, () => temp);
        }
      } else {
        if (predictedNumbers.contains(value)) {
          prize.putIfAbsent(key, () => value);
        }
      }
    });
    return prize;
  } */
