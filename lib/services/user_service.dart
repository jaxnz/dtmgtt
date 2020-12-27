import 'package:cloud_firestore/cloud_firestore.dart';


class UserDatabase {

final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

Future createUser({
  final String uid,
  final String userType,
  final String name,
  final int walletValue,
}) async {
  return await usersCollection.doc(uid).set({
    'uid': uid,
    'userType': userType,
    'name': name,
    'walletValue': walletValue,
  }).then((data){
    print('data submitted');
  }).catchError((error){
    print(error);
  });
}

}