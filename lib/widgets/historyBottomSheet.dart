import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/histioryDataProvider.dart';
import '../utils/showAlert.dart';

class HistoryBottomSheet extends StatefulWidget {
  @override
  _HistoryBottomSheetState createState() => _HistoryBottomSheetState();
}

class _HistoryBottomSheetState extends State<HistoryBottomSheet> {
  DateTime? _bottomSheetStartDate;
  DateTime? _bottomSheetendDate;

  void showCalender(context, bool start) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then(
      (value) {
        if (value != null) {
          setState(() {
            start ? _bottomSheetStartDate = value : _bottomSheetendDate = value;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _bottomSheetStartDate != null
                    ? Text(
                        DateFormat('dd-MM-yyyy').format(_bottomSheetStartDate!),
                      )
                    : Text('Start Date'),
              ),
              ElevatedButton(
                  onPressed: () {
                    showCalender(context, true);
                  },
                  child: const Text('Select start date'))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _bottomSheetendDate != null
                    ? Text(
                        DateFormat('dd-MM-yyyy').format(_bottomSheetendDate!),
                      )
                    : const Text('end Date'),
              ),
              ElevatedButton(
                  onPressed: () {
                    showCalender(context, false);
                  },
                  child: const Text('Select end date'))
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (_bottomSheetStartDate != null &&
                  _bottomSheetendDate != null) {
                if (_bottomSheetStartDate!.isBefore(_bottomSheetendDate!)) {
                  Provider.of<HistoryDataProvider>(context, listen: false)
                      .setDate(_bottomSheetStartDate, _bottomSheetendDate);
                  Navigator.of(context).pop();
                } else {
                  ShowAlert().showAlert(context, 'Alert',
                      'Start Date must be less than end date');
                }
              }
            },
            child: const Text('Get Data'),
          ),
        ],
      ),
    );
  }
}
