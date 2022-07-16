import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:prediction_app/provider/membersProvider.dart';
import 'package:prediction_app/utils/constants.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';

class UsersUsersScreen extends StatefulWidget {
  
  final String userId;
  UsersUsersScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UsersUsersScreenState createState() => _UsersUsersScreenState();
}

class _UsersUsersScreenState extends State<UsersUsersScreen> {
  late Future<List<dynamic>> future;

  @override
  void initState() {
    future = Provider.of<MembersProvider>(context, listen: false)
        .getMembers(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members'),
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            List<dynamic>? data = snapshot.data;
            return data == null || data.isEmpty
                ? Center(
                    child: Text('No data'),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      String? imagepath = data[index]['Picture'] != null
                          ? imagePath + data[index]['Picture']
                          : null;
                      return ListTile(
                        leading: imagepath != null
                            ? CachedNetworkImage(
                                imageUrl: imagepath,
                                imageBuilder: (context, image) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: image, fit: BoxFit.cover),
                                    ),
                                  );
                                },
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                                child: Center(
                                  child: Icon(Icons.error),
                                ),
                              ),
                        title: Text(data[index]['name'] ?? ''),
                      );
                    },
                  );
          } else {
            return Center(
              child: Text('No data'),
            );
          }
        },
      ),
    );
  }
}
