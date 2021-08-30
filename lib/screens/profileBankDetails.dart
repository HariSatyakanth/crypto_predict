import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'package:provider/provider.dart';

import '../provider/bankDetails.dart';

class ProfileBankDetails extends StatefulWidget {
  static const routeName = '/profileBankDetails';
  const ProfileBankDetails({Key? key}) : super(key: key);

  @override
  _ProfileBankDetailsState createState() => _ProfileBankDetailsState();
}

class _ProfileBankDetailsState extends State<ProfileBankDetails> {
  GlobalKey<FormState> _fromkey = new GlobalKey();
  bool isinit = true;
  String? _name;
  String? _accountNumber;
  String? _bankName;
  String? _branch;
  bool _enabled = false;

  var future;
  late Future bankDetails;

  @override
  void initState() {
    future = Provider.of<BankDetails>(context, listen: false);
    bankDetails = future.getBankDetails();

    super.initState();
  }

  void onEdit() {
    setState(() {
      _enabled = !_enabled;
    });
  }

  @override
  void didChangeDependencies() {
    if (isinit) {
      _enabled = ModalRoute.of(context)!.settings.arguments as bool;
      isinit = false;
    }
    super.didChangeDependencies();
  }

  void onSubmit() {
    if (_fromkey.currentState!.validate()) {
      _fromkey.currentState!.save();
      onEdit();
      future
          .updateBankDetails(_name, _accountNumber, _bankName, _branch)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added data Successfully'),
          ),
        );
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //_enabled = ModalRoute.of(context)!.settings.arguments as bool;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Bank Details'),
        actions: [IconButton(onPressed: onEdit, icon: Icon(Icons.edit))],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: primarycolor,
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/bank.png'),
              ),
            ),
          ),
          FutureBuilder(
            future: bankDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasError && snapshot.data == null) {
                return Center(
                  child: Text('Something went wrong please try again'),
                );
              }
              Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(18),
                child: Form(
                  key: _fromkey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: data['name'],
                        enabled: _enabled,
                        enableInteractiveSelection: _enabled,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Name',
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (name) {
                          if (name == null || name == '') {
                            return 'Enter your name';
                          }
                          if (name.length < 5) {
                            return 'Please enter the name as in your bank';
                          }
                          return null;
                        },
                        onSaved: (name) {
                          _name = name!;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        initialValue: data['account_no'],
                        enabled: _enabled,
                        enableInteractiveSelection: _enabled,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.credit_card_outlined),
                          hintText: 'Account Number',
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (number) {
                          if (number == null || number == '') {
                            return 'Enter Account Number';
                          }
                          if (!(number.length > 13 && number.length < 20)) {
                            return 'Please enter a valid account number';
                          }
                          return null;
                        },
                        onSaved: (accountNum) {
                          _accountNumber = accountNum!;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        initialValue: data['bank_name'],
                        enabled: _enabled,
                        enableInteractiveSelection: _enabled,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_balance),
                          hintText: 'Bank Name',
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (bankName) {
                          if (bankName == null || bankName == '') {
                            return 'Enter Bank Name';
                          }
                          return null;
                        },
                        onSaved: (bankName) {
                          _bankName = bankName!;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        initialValue: data['branch'],
                        enabled: _enabled,
                        enableInteractiveSelection: _enabled,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_on),
                          hintText: 'Branch',
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (branch) {
                          if (branch == null || branch == '') {
                            return 'Enter Branch';
                          }
                          return null;
                        },
                        onSaved: (branch) {
                          _branch = branch!;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary:
                                _enabled ? primarycolor : Colors.grey.shade300),
                        onPressed: () {
                          if (_enabled) {
                            onSubmit();
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
