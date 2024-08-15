import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServiceFE {
  static final UserServiceFE _instance = UserServiceFE._internal();

  factory UserServiceFE() => _instance;

  UserServiceFE._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _userName;
  String? _userRole;
  String? _userId;
  String? _userEmail;
  String? _userKantor;

  String? get userName => _userName;
  String? get userRole => _userRole;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  String? get userKantor => _userKantor;

  Future<void> initialize() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _fetchUserData(user.email);
    }
  }

  Future<void> _fetchUserData(String? email) async {
    try {
      final querySnapshot = await _firestore.collection('users').where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first.data();
        _userName = userDoc['name'];  // Assuming the field name is 'name'
        _userRole = userDoc['role'];  // Assuming the field name is 'role'
        _userId = userDoc['userId'];
        _userEmail = userDoc['email'];
        _userKantor = userDoc['perusahaan'];
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
}
