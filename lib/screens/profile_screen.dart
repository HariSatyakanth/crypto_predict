import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/image_picker.dart';
import '../utils/constants.dart';
import '../provider/userDataProvider.dart';
import './profileBankDetails.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profileScreen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String imagepath = imagePath;
  bool _appBarBackEnable = true;
  bool _enabled = false;
  bool _loading = false;
  GlobalKey<FormState> _fromkey = new GlobalKey();
  late String firstName;
  late String lastName;
  late String email;
  late String mobileNumber;
  late String nric;
  late String address;
  late String postCode;

  void _changeLoadingStatus() {
    setState(() {
      _loading = !_loading;
    });
  }

  void saveForm() {
    var prodata = Provider.of<UserDataProvider>(context, listen: false);
    if (_fromkey.currentState!.validate()) {
      _fromkey.currentState!.save();
      _appBarBackEnable = false;
      _enabled = false;
      _changeLoadingStatus();
      prodata
          .updateUser(
              firstName, lastName, email, mobileNumber, nric, address, postCode)
          .then((_) {
        _changeLoadingStatus();
        _appBarBackEnable = true;
        prodata.image('');
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: primarycolor,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: _appBarBackEnable,
          title: const Text(
            'Profile details',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.mode_edit,
              ),
              onPressed: () {
                setState(
                  () {
                    _enabled = !_enabled;
                    // if (!_enabled) {//TO reset if data added does not save and clicked on edit again
                    //   _fromkey.currentState!.reset();
                    // }
                  },
                );
              },
            ),
          ],
        ),
        body: profileView());
  }

  Widget profileView() {
    return Consumer<UserDataProvider>(
      builder: (context, userData, _) {
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 45),
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        userData.imagePath != null && userData.imagePath != ''
                            ? FileImage(File(userData.imagePath!))
                            : (userData.user.image == ''
                                    ? AssetImage(
                                        'assets/images/avatar.png',
                                      )
                                    : NetworkImage(
                                        '$imagepath${userData.user.image}'))
                                as ImageProvider<Object>?,
                  ),
                  if (_enabled)
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: Container(
                        height: 40,
                        width: 40,
                        child: IconButton(
                          icon: Icon(Icons.add_a_photo),
                          color: primarycolor,
                          onPressed: () {
                            Imagepicker().showPicker(context);
                          },
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.white //Color(0xFFFFF7EC),
                  ), // [Colors.black54, Color.fromRGBO(0, 41, 102, 1)]
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Form(
                    key: _fromkey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: TextFormField(
                                expands: false,
                                initialValue: userData.user.firstName,
                                enabled: _enabled,
                                enableInteractiveSelection: _enabled,
                                decoration: InputDecoration(
                                  //contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  prefixIcon: Icon(Icons.person),
                                  border: _enabled
                                      ? UnderlineInputBorder(
                                          borderRadius: BorderRadius.horizontal(
                                              right: Radius.circular(10)),
                                          borderSide: BorderSide(width: 1))
                                      : InputBorder.none,
                                  // prefixIcon: Icon(Icons.person),
                                  labelText: 'First Name',
                                  hintStyle: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                validator: (name) {
                                  if (name!.isEmpty) {
                                    return 'First Name should not be empty';
                                  }
                                  return null;
                                },
                                onSaved: (name) {
                                  firstName = name ?? '';
                                },
                              ),
                            ),
                            Flexible(
                              child: TextFormField(
                                expands: false,
                                initialValue: userData.user.lastName,
                                enabled: _enabled,
                                enableInteractiveSelection: _enabled,
                                decoration: InputDecoration(
                                  // contentPadding: EdgeInsets.symmetric(  horizontal: 10, vertical: 5),
                                  border: _enabled
                                      ? UnderlineInputBorder(
                                          borderRadius: BorderRadius.horizontal(
                                              right: Radius.circular(10)),
                                          borderSide: BorderSide(width: 1))
                                      : InputBorder.none,
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'Last Name',
                                  hintText: 'Last Name',
                                  hintStyle: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                validator: (name) {
                                  if (name!.isEmpty) {
                                    return 'Last Name should not be empty';
                                  }
                                  return null;
                                },
                                onSaved: (name) {
                                  lastName = name ?? '';
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          initialValue: userData.user.email,
                          enabled: false,
                          enableInteractiveSelection: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Email',
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          validator: (email) {
                            if (email!.isEmpty) {
                              return 'Enter email';
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                .hasMatch(email)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (emai) {
                            email = emai ?? '';
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          initialValue: userData.user.mobileNumber,
                          enabled: _enabled,
                          enableInteractiveSelection: _enabled,
                          decoration: InputDecoration(
                            border: _enabled
                                ? UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1))
                                : InputBorder.none,
                            prefixIcon: Icon(Icons.phone),
                            labelText: 'Mobile Number',
                            hintText: 'Mobile Number:',
                            hintStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          onSaved: (number) {
                            if (number == null) {
                              mobileNumber = '';
                            }
                            mobileNumber = number!;
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          initialValue: userData.user.nric ?? '',
                          enabled: _enabled,
                          enableInteractiveSelection: _enabled,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.credit_card),
                            border: _enabled
                                ? UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1))
                                : InputBorder.none,
                            labelText: 'NRIC Number',
                            hintText: 'NRIC Number:',
                            hintStyle: TextStyle(
                              // color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          onSaved: (nricn) {
                            if (nricn!.isEmpty) {
                              nric = '';
                            }
                            nric = nricn;
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          initialValue: userData.user.address,
                          enabled: _enabled,
                          enableInteractiveSelection: _enabled,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          onTap: () {},
                          decoration: InputDecoration(
                            border: _enabled
                                ? UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1))
                                : InputBorder.none,
                            prefixIcon: Icon(Icons.location_on),
                            labelText: 'Address',
                            hintText: 'Address:',
                            hintStyle: TextStyle(
                              // color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          onSaved: (add) {
                            if (add!.isEmpty) {
                              address = '';
                            }
                            address = add;
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          initialValue: userData.user.postcode,
                          enabled: _enabled,
                          enableInteractiveSelection: _enabled,
                          decoration: InputDecoration(
                            border: _enabled
                                ? UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1))
                                : InputBorder.none,
                            prefixIcon: Icon(Icons.markunread_mailbox_rounded),
                            labelText: 'Post Code',
                            hintText: 'Post Code:',
                            hintStyle: TextStyle(
                              // color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          onSaved: (post) {
                            if (post!.isEmpty) {
                              postCode = '';
                            }
                            postCode = post;
                          },
                        ),
                        ListTile(
                          onTap: () => Navigator.of(context).pushNamed(
                              ProfileBankDetails.routeName,
                              arguments: false),
                          title: Text('Bank Details'),
                          trailing: Icon(Icons.arrow_forward_ios_rounded),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        if (_enabled)
                          _loading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  child: const Text(
                                    "SAVE",
                                  ),
                                  onPressed: saveForm,
                                ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Agent Details: '),
                            Text(userData.agentid),
                            const SizedBox(width: 5),
                            Text(userData.agentName),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ))
          ],
        );
      },
    );
  }
}

/*
Profile view circle avatar


userData.imagePath != null &&
                          userData.imagePath != ''
                      ? FileImage(
                          File(userData.imagePath),
                        )
                      : userData.user.image == ''
                          ? Center(
                              child: Icon(Icons.camera_alt),
                            )
                          : NetworkImage('$imagepath${userData.user.image}'),
 */
