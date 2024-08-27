import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/login_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/main_page_fe.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AuthenticationController extends GetxController{
  final isLoading = false.obs;
  final token = ''.obs;
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userRole = ''.obs;  // For storing the role name
  final userFungsi = ''.obs;  // For storing the fungsi name
  final box = GetStorage();
  Future login({
    required String email,
    required String password,
  }) async{
    try{
      isLoading.value =true;
      var data ={
        'email': email,
        'password': password,
      };

      var response = await http.post(
        Uri.parse('${url}login'),
        headers: {
          'Accept':'application/json',
        },
        body: data,
      );

      if(response.statusCode == 200){
        isLoading.value = false;
        token.value = json.decode(response.body)['token'];
        userName.value = json.decode(response.body)['user']['name']; // Assuming the API returns user data
        userEmail.value = json.decode(response.body)['user']['email'];
        var roleId = json.decode(response.body)['user']['role_id'];
        var fungsiId = json.decode(response.body)['user']['fungsi_id'];


        box.write('token', token.value);
        box.write('userName', userName.value);
        box.write('userEmail', userEmail.value);

        // Fetch role and fungsi
        await fetchRole(roleId);
        await fetchFungsi(fungsiId);

        Get.offAll(() => MainPageFE());
      }else{
        isLoading.value = false;
        Get.snackbar(
            'error',
            json.decode(response.body)['Pesan'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
        );
        print(json.decode(response.body));
      }
    } catch(e){
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future<void> fetchRole(int roleId) async {
    try {
      var response = await http.get(
        Uri.parse('${url}roles/$roleId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token.value}', // Include the token
        },
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        userRole.value = responseBody['jenis_pengguna'];
        box.write('userRole', userRole.value);
      } else {
        print('Role fetch error: ${response.body}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchFungsi(int fungsiId) async {
    try {
      var response = await http.get(
        Uri.parse('${url}fungsi/$fungsiId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token.value}', // Include the token
        },
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        userFungsi.value = responseBody['departemen'];
        box.write('userFungsi', userFungsi.value);
      } else {
        print('Fungsi fetch error: ${response.body}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future logout() async {
    try {
      isLoading.value = true;
      var storedToken = box.read('token');
      // Call the logout API route
      var response = await http.post(
        Uri.parse('${url}logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $storedToken', // Include the token
        },
      );

      if (response.statusCode == 201) {
        // Clear the token from GetStorage
        box.remove('token');
        box.remove('userName');
        box.remove('userEmail');
        box.remove('userRole');
        box.remove('userFungsi');
        token.value = '';
        userName.value = '';
        userEmail.value = '';
        userRole.value = '';
        userFungsi.value = '';
        // Redirect the user to the login screen (or another appropriate page)
        Get.offAll(() => const LoginPageFE());
      } else {
        Get.snackbar(
          'Error',
          'Logout failed. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('Logout Error: ${response.body}');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}