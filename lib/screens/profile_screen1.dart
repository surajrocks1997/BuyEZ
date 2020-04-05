import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/profile.dart';

class ProfileScreen1 extends StatefulWidget {
  static const routeName = '/profile';
  @override
  _ProfileScreen1State createState() => _ProfileScreen1State();
}

class _ProfileScreen1State extends State<ProfileScreen1> {
  final _form = GlobalKey<FormState>();

  Future userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = _getUser();
  }

  _getUser() async {
    Profile profile =
        await Provider.of<ProfileDetails>(context).fetchAndSetProfile();
    print(profile);
    // return profile;
  }

  var imageUrl =
      'https://previews.123rf.com/images/jemastock/jemastock1904/jemastock190431374/123116164-man-portrait-faceless-avatar-cartoon-character-vector-illustration-graphic-design.jpg';

  var _editedProfile = Profile(
    firstName: '',
    lastName: '',
    age: 0,
    address: '',
  );

  // var _isInit = true;
  var _isLoading = false;

  Future<void> _saveDetails() async {
    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_editedProfile.firstName != null ||
          _editedProfile.lastName != null ||
          _editedProfile.age != null ||
          _editedProfile.address != null) {
        await Provider.of<ProfileDetails>(context, listen: false)
            .updateProfile(_editedProfile);
      } else {
        await Provider.of<ProfileDetails>(context, listen: false)
            .saveProfile(_editedProfile);
      }

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).popAndPushNamed('/');
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _saveDetails,
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder(
              future: userFuture,
              builder: ((ctx, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('none');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.done:
                    print(snapshot.data);
                    return Consumer<ProfileDetails>(
                      builder: (ctx, profiledata, _) => Padding(
                        padding: EdgeInsets.all(25),
                        child: Form(
                          key: _form,
                          child: ListView(
                            children: <Widget>[
                              Container(
                                height: 250,
                                width: 250,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(imageUrl),
                                    // backgroundColor: Theme.of(context).primaryColor,
                                    radius: 40,
                                  ),
                                ),
                              ),
                              TextFormField(
                                initialValue: _editedProfile.firstName,
                                decoration:
                                    InputDecoration(labelText: 'First Name'),
                                onSaved: (value) => {
                                  _editedProfile = Profile(
                                    firstName: value,
                                    lastName: _editedProfile.lastName,
                                    age: _editedProfile.age,
                                    address: _editedProfile.address,
                                  ),
                                },
                              ),
                              TextFormField(
                                initialValue: _editedProfile.lastName,
                                decoration:
                                    InputDecoration(labelText: 'Last Name'),
                                onSaved: (value) => {
                                  _editedProfile = Profile(
                                    firstName: _editedProfile.firstName,
                                    lastName: value,
                                    age: _editedProfile.age,
                                    address: _editedProfile.address,
                                  ),
                                },
                              ),
                              TextFormField(
                                initialValue: _editedProfile.age.toString(),
                                decoration: InputDecoration(labelText: 'Age'),
                                keyboardType: TextInputType.number,
                                onSaved: (value) => {
                                  _editedProfile = Profile(
                                    firstName: _editedProfile.firstName,
                                    lastName: _editedProfile.lastName,
                                    age: int.parse(value),
                                    address: _editedProfile.address,
                                  ),
                                },
                              ),
                              TextFormField(
                                initialValue: _editedProfile.address,
                                decoration: InputDecoration(
                                    labelText: 'Delivery Address'),
                                maxLines: 2,
                                onSaved: (value) => {
                                  _editedProfile = Profile(
                                    firstName: _editedProfile.firstName,
                                    lastName: _editedProfile.lastName,
                                    age: _editedProfile.age,
                                    address: value,
                                  ),
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  default:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                }
              }),
            ),
    );
  }
}
