import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/login_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/Service/main_page_fe.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class AuthenticationController extends GetxController{
  final isLoading = false.obs;
  final Dio dio = Dio();
  final token = ''.obs;
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userID = ''.obs;
  final userRole = ''.obs;  // For storing the role name
  final userFungsiD = ''.obs;  // For storing the fungsi name
  final userFungsiJ = ''.obs;
  final box = GetStorage();
  Future<void> LoginSSO({
    required String username,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      var response = await dio.post(
        'https://sso.universitaspertamina.ac.id/api/login',
        options: Options(headers: {'Accept': 'application/json'}),
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        var userData = response.data['data'];

        // Simpan data tanpa 'isSSO'
        box.write('token', userData['token']);
        box.write('userID', userData['id'].toString());
        box.write('userCode', userData['code']);
        box.write('userUsername', userData['username']);
        box.write('userName', userData['name']);
        box.write('userEmail', userData['alt_email']);

        Get.snackbar(
          'Login Berhasil',
          'Selamat datang, ${userData['name']}!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Redirect ke halaman utama
        Get.offAll(() => MainPageFE());
      } else {
        Get.snackbar(
          'Login Gagal',
          response.data['message'] ?? 'Periksa kembali username dan password!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      Get.snackbar(
        'Login Error',
        e.response?.data['message'] ?? 'Terjadi kesalahan saat login!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Login SSO Error: ${e.message}");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> LoginLaravel({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      var response = await dio.post(
        '${url}login',
        options: Options(headers: {'Accept': 'application/json'},
          validateStatus: (status) {
            // Jangan lemparkan exception untuk status 401
            return status! < 500; // Semua status di bawah 500 diterima
          },),
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        var responseBody = response.data;
        var user = responseBody['user'];

        // Simpan data ke GetStorage
        box.write('token', responseBody['token']);
        box.write('userID', user['id'].toString());
        box.write('userName', user['name']);
        box.write('userEmail', user['email']);
        box.write('isSSO', false); // Tandai login via Laravel API

        // Update variabel agar UI langsung berubah
        token.value = responseBody['token'];
        userID.value = user['id'].toString();
        userName.value = user['name'];
        userEmail.value = user['email'];

        // Fetch role dan fungsi
        await fetchRole(user['role_id']);
        await fetchFungsi(user['fungsi_id']);

        Get.snackbar(
          'Login Berhasil',
          'Selamat datang, ${user['name']}!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Arahkan ke halaman utama
        Get.offAll(() => MainPageFE());
      } else if (response.statusCode == 401) {
        // Tangani login gagal
        Get.snackbar(
          'Login Gagal',
          response.data['Pesan'] ?? 'Login gagal!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        // Tangani error lain
        Get.snackbar(
          'Login Error',
          'Terjadi kesalahan saat login.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Login Laravel Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
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
        userFungsiD.value = responseBody['departemen'].toString();
        userFungsiJ.value = responseBody['jabatan'].toString();
        box.write('userFungsiD', userFungsiD.value);
        box.write('userFungsiJ', userFungsiJ.value);
      } else {
        print('Fungsi fetch error: ${response.body}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> logoutAll() async {
    try {
      isLoading.value = true;

      bool? isSSO = box.read('isSSO'); // Laravel login akan menyimpan isSSO, SSO tidak

      if (isSSO != null && isSSO == true) {
        // Jika Laravel, lakukan request logout ke backend
        var storedToken = box.read('token');
        var response = await dio.post(
          '${url}logout',
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $storedToken',
            },
          ),
        );

        if (response.statusCode == 201) {
          print('Logout Laravel berhasil');
        }
      }

      // Hapus semua data sesi
      box.erase();

      // Menampilkan snackbar berhasil logout
      Get.snackbar(
        'Logout Berhasil',
        'Anda telah berhasil keluar.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAll(() => const LoginPageFE());
    } catch (e) {
      print("Logout Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

}