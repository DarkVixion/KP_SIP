import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/AdminView/admin_home_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/AdminView/admin_peka_page_fe.dart';

import 'package:fluttersip/FrontEndOnly/UserView/user_home_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_peka_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/profile_page_fe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GlobalStateFE with ChangeNotifier {
  static final GlobalStateFE _instance = GlobalStateFE._internal();

  factory GlobalStateFE() => _instance;

  GlobalStateFE._internal();


  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;



  void onItemTapped(int index, BuildContext context) {
    _selectedIndex = index;
    notifyListeners();
    final box = GetStorage();

    var userRole = box.read('userRole');

    if (index == 0) {
      if (userRole == 'Admin') {
        Get.offAll(() => const AdminHomePageFE());
      } else {
        Get.offAll(() => const UserHomePageFE());
      }
    } else if (index == 1) {
      if (userRole == 'Admin') {
        Get.offAll(() => const TindakLanjutPageFE());
      } else {
        Get.offAll(() => const UserPekaPageFE());
      }
    } else if (index == 2) {
      Get.offAll(() => const ProfilePageFE());
    }
  }



  String namaPegawai = '';
  String emailPekerja = '';
  String namaFungsi = '';
  String lokasiSpesifik = '';
  String deskripsiObservasi = '';
  String directAction = '';



  String? selectedKategori;

  DateTime? selectedTanggal;

  String? _selectedTipeObservasiId = '';
  String? _selectedSubKategoriId;
  String? _selectedClsr = '';
  String? _selectedLokasiId = '';
  String? _selectedNonCLSR = '';

  String? get selectedNonClsr => _selectedNonCLSR;
  String? get selectedLokasiId => _selectedLokasiId;
  String? get selectedClsrId => _selectedClsr;
  String? get selectedTipeObservasiId => _selectedTipeObservasiId;
  String? get selectedSubKategoriId => _selectedSubKategoriId;
  String? _userId;

  // Getter for userId
  String? get userId => _userId;
// Method to load userId from GetStorage
  void updateUserId(String? value) {
    _userId = value;  // 'userID' should match the key used when storing the ID
    notifyListeners();  // Notify UI that userID has been updated
  }
  File? image;

  void updateImage(File? newImage) {
    image = newImage;
    notifyListeners();
  }




  void updateClsr(String? id) {
    _selectedClsr = id;
    notifyListeners();
  }

  void updateSubKategori(String? id) {
    _selectedSubKategoriId = id;
    notifyListeners();
  }

  void updateTipeObservasi(String id) {
    _selectedTipeObservasiId = id;
    notifyListeners();
  }


  void updateKategori(String kategori) {
    selectedKategori = kategori;
    notifyListeners();
  }

  void updateLokasiObservasi(String? lokasi) {
    _selectedLokasiId = lokasi;
    notifyListeners();
  }

  void updateNonClsr(String? nonClsr) {
    _selectedNonCLSR = nonClsr;
    notifyListeners();
  }

  void updateNamaPegawai(String value) {
    namaPegawai = value;
    notifyListeners();
  }

  void updateEmailPekerja(String value) {
    emailPekerja = value;
    notifyListeners();
  }

  void updateNamaFungsi(String value) {
    namaFungsi = value;
    notifyListeners();
  }

  void updatedeskripsiObservasi(String value) {
    deskripsiObservasi = value;
    notifyListeners();
  }

  void updatedirectAction(String value) {
    directAction = value;
    notifyListeners();
  }



  void updateLokasiSpesifik(String value) {
    lokasiSpesifik = value;
    notifyListeners();
  }

  void updateSelectedDate(DateTime date) {
    selectedTanggal = date;
    notifyListeners();
  }

  void resetForm() {
    lokasiSpesifik = '';
    deskripsiObservasi = '';
    directAction = '';
    selectedKategori = null;
    _selectedNonCLSR = '';
    selectedTanggal = DateTime.now();
    _selectedLokasiId = null;
    _selectedTipeObservasiId = null;
    _selectedSubKategoriId = null;
    _selectedClsr = null;

    // Notify listeners that the state has changed
    notifyListeners();
  }

}
