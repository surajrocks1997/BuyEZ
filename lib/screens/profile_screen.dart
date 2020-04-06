import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/profile.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _form = GlobalKey<FormState>();

  var _initValue = {
    'firstName': '',
    'lastName': '',
    'age': '',
    'address': '',
  };

  var _editedProfile = Profile(
    firstName: '',
    lastName: '',
    age: 0,
    address: '',
  );

  
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // Profile profileData = ModalRoute.of(context).settings.arguments as Profile;
    Profile profileData = Provider.of<ProfileDetails>(context).details;
    if (profileData != null) {
      _editedProfile = profileData;

      _initValue = {
        'firstName': _editedProfile.firstName,
        'lastName': _editedProfile.lastName,
        'age': _editedProfile.age.toString(),
        'address': _editedProfile.address,
      };
    }
    super.didChangeDependencies();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (_isInit) {
  //     Provider.of<ProfileDetails>(context)
  //         .fetchAndSetProfile()
  //         .then((response) => {_editedProfile = response});
  //     if (_editedProfile == null) {
  //       return;
  //     }
  //     _initValue = {
  //       'firstName': _editedProfile.firstName,
  //       'lastName': _editedProfile.lastName,
  //       'age': _editedProfile.age.toString(),
  //       'address': _editedProfile.address,
  //     };
  //   }
  //   _isInit = false;
  // }

  var imageUrl =
      'https://previews.123rf.com/images/jemastock/jemastock1904/jemastock190431374/123116164-man-portrait-faceless-avatar-cartoon-character-vector-illustration-graphic-design.jpg';

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
        title: Text('Update Details'),
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
          : Padding(
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
                      initialValue: _initValue['firstName'],
                      decoration: InputDecoration(labelText: 'First Name'),
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
                      initialValue: _initValue['lastName'],
                      decoration: InputDecoration(labelText: 'Last Name'),
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
                      initialValue: _initValue['age'],
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
                      initialValue: _initValue['address'],
                      decoration:
                          InputDecoration(labelText: 'Delivery Address'),
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
  }
}
