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
        Get.offAll(() => const AdminPekaPageFE());
      } else {
        Get.offAll(() => const UserPekaPageFE());
      }
    } else if (index == 2) {
      Get.offAll(() => const ProfilePageFE());
    }
  }


  String? selectedKategori;
  String? namaPegawaiController;
  String? emailPekerjaController;
  String? namaFungsiController;
  String? lokasiSpesifikController;
  DateTime? selectedTanggal;
  int? _selectedTipeObservasiId;
  int? _selectedSubKategoriId;
  int? _selectedClsr;
  int? _selectedLokasiId;
  int? get selectedLokasiId => _selectedLokasiId;
  int? get selectedClsrId => _selectedClsr;
  int? get selectedTipeObservasiId => _selectedTipeObservasiId;
  int? get selectedSubKategoriId => _selectedSubKategoriId;

  void updateClsr(int? id) {
    _selectedClsr = id;
    notifyListeners();
  }

  void updateSubKategori(int? id) {
    _selectedSubKategoriId = id;
    notifyListeners();
  }

  void updateTipeObservasi(int id) {
    _selectedTipeObservasiId = id;
    notifyListeners();
  }


  void updateKategori(String kategori) {
    selectedKategori = kategori;
    notifyListeners();
  }

  void updateLokasiObservasi(int lokasi) {
    _selectedLokasiId = lokasi;
    notifyListeners();
  }

  void updateNamaPegawai(String nama) {
    namaPegawaiController = nama;
    notifyListeners();
  }

  void updateEmailPekerja(String email) {
    emailPekerjaController = email;
    notifyListeners();
  }

  void updateLokasiSpesifik(String lokasi) {
    lokasiSpesifikController = lokasi;
    notifyListeners();
  }

  void updateNamaFungsiProdi(String fungsi) {
    namaFungsiController = fungsi;
    notifyListeners();
  }

  void updateSelectedDate(DateTime date) {
    selectedTanggal = date;
    notifyListeners();
  }

}
