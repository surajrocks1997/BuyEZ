import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/auth.dart';
import '../screens/profile_screen.dart';
import '../screens/analysis_screen.dart';

class AppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color.fromRGBO(156, 39, 176, 1).withOpacity(0.4),
                  Color.fromRGBO(156, 39, 176, 1).withOpacity(1.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 1],
              ),
            ),
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Material(
                      child: 
                      CircleAvatar(
                        // backgroundColor: Theme.of(context).primaryColor,
                        backgroundImage: NetworkImage('https://previews.123rf.com/images/jemastock/jemastock1904/jemastock190431374/123116164-man-portrait-faceless-avatar-cartoon-character-vector-illustration-graphic-design.jpg'),
                        radius: 40,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                      elevation: 15,
                    ),
                  ),
                  Consumer<ProfileDetails>(
                    builder: (ctx, profileData, _) =>
                        profileData.details == null
                            ? Text(
                                'Welcome, User',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                ),
                              )
                            : Text(
                                'Welcome, ${profileData.details.firstName}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                ),
                              ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text('Orders Assessment'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AnalysisScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProfileScreen.routeName);
            },
            // onTap: () async {
            //   Profile profileData = await Provider.of<ProfileDetails>(context)
            //       .fetchAndSetProfile();
            //   Navigator.of(context).pushReplacementNamed(
            //       ProfileScreen.routeName,
            //       arguments: profileData);
            // },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              // Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
