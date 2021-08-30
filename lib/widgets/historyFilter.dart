import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/widgets/historyBottomSheet.dart';
import '../provider/histioryDataProvider.dart';

class HistoryFilter extends StatefulWidget {
  @override
  _HistoryFilterState createState() => _HistoryFilterState();
}

class _HistoryFilterState extends State<HistoryFilter> {
  String dropDownValue = 'This month';

  void bottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return HistoryBottomSheet();
      },
    );
  }

  selectDate(String category) {
    switch (category) {
      case 'This month':
        return 0;
      case 'Last 2 Months':
        return 1;
      case 'Last 3 Months':
        return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.orange.shade200),
      child: DropdownButton(
        elevation: 2,
        underline: Container(),
        value: dropDownValue,
        onChanged: (dynamic val) {
          setState(() {
            dropDownValue = val;
          });
          if (val == 'Select Dates') {
            bottomSheet(context);
          } else {
            DateTime today = DateTime.now();
            int month = selectDate(val);
            DateTime _startDate = DateTime(today.year, today.month - month, 1);
            DateTime _endDate = today;
            Provider.of<HistoryDataProvider>(context, listen: false)
                .setDate(_startDate, _endDate);
          }
        },
        items: ['This month', 'Last 2 Months', 'Last 3 Months', 'Select Dates']
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
      ),
    );
  }
}
