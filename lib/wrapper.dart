import 'package:dtmgtt/screens/bossscreen.dart';
import 'package:dtmgtt/services/job_service.dart';
import 'package:dtmgtt/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dtmgtt/screens/login.dart';
import 'package:dtmgtt/services/auth_service.dart';
import 'package:dtmgtt/models/user_model.dart';
import 'package:dtmgtt/screens/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthStream extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser>.value(
      value: AuthService().user,
      child: Wrapper(),
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    if (user == null) {
      return Login();
    } else {
      return UserRoute(user.uid);
    }
  }
}

UserData userData;
getUser(String userID) async {
  return FirebaseFirestore.instance.collection('users').doc(userID).snapshots().map(_userListFromSnapshot);
}

  if (userResults.data() != null) {
    userData = userListFromSnapshot(userResults);
  } else {
   AuthService().signOut();
  }

UserData _userListFromSnapshot(DocumentSnapshot snapshot) {
  return UserData(
    uid: snapshot.data()['uid'],
    userType: snapshot.data()['userType'],
    name: snapshot.data()['name'],
    walletValue: snapshot.data()['walletValue'],
  ); 
}

class UserRoute extends StatelessWidget {
  final String uid;
  UserRoute(this.uid);
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserData>.value(
        value: getUser(uid),
        builder: (context, snapshot) {
          UserData user = snapshot.data;
          if (snapshot.hasData) {
            return StreamBuilder<List<Job>>(
              stream: JobDatabaseService().notStartedJobs,
              builder: (context, snapshot){
                List<Job> listOfJobs = snapshot.data;
                if (!snapshot.hasData) {
                  return Loading();
                }
                if (user.userType == 'worker') {
                  print('worker logged in');
                  return MainScreen(walletValue: user.walletValue, listOfJobs: listOfJobs,);
                } else if (user.userType == 'boss') {
                  print('boss logged in');
                  return BossScreen(listOfJobs);
                } else {
                  print('login failed');
                  return Login();
                }
              },
              );

          } else {
            return Loading();
          }
        });
  }
}
