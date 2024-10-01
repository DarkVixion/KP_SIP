import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:fluttersip/FrontEndOnly/AdminView/admin_peka_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_peka_page_fe.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LaporanPekaController extends GetxController {
  final dio.Dio _dio = dio.Dio();
  final isLoading = false.obs;


  final box = GetStorage();
  Future<void> submitLaporan({
    required String namaPegawai,
    required String emailPegawai,
    required String namaFungsi,
    required String lokasiSpesifik,
    required String deskripsiObservasi,
    required String directAction,
    required String saranAplikasi,
    required String tanggal,
    required String userId,
    required String lokasiId,
    required String tipeobservasiId,
    required String kategoriId,
    required String clsrId,
    File? image,
  }) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'tanggal': tanggal,
        'user_id': userId,
        'lokasi_id': lokasiId,
        'tipe_observasi_id': tipeobservasiId,
        'kategori_id': kategoriId,
        'clsr_id': clsrId,
        'nama_pegawai': namaPegawai,
        'email_pegawai': emailPegawai,
        'nama_fungsi': namaFungsi,
        'lokasi_spesifik': lokasiSpesifik,
        'deskripsi_observasi': deskripsiObservasi,
        'direct_action': directAction,
        'saran_aplikasi': saranAplikasi,
        if (image != null)
          'img': await dio.MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
      });

      dio.Response response = await _dio.post(
        '${url}laporans',
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer ${box.read('token')}', // If token authentication is used
          },
        ),
      );

      if (response.statusCode == 201) {
        print("Laporan created successfully: ${response.data}");
        String laporanId = response.data['laporan']['id'].toString();
        await _createTindakLanjut(laporanId);

        GlobalStateFE().resetForm();
        var userRole = box.read('userRole');
        if (userRole == 'Admin') {
          Get.offAll(() => const TindakLanjutPageFE());
        } else {
          Get.offAll(() => const UserPekaPageFE());
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error submitting laporan: $e");
    }
  }

  Future<void> _createTindakLanjut(String laporanId) async {
    try {
      var response = await _dio.post(
        '${url}tindaklanjuts',
        data: {
          'laporan_id': laporanId,
          'tanggal': GlobalStateFE().selectedTanggal!.toIso8601String(),
          'tipe': GlobalStateFE().selectedTipeObservasiId.toString(),
          'status': 'Open',
          'deskripsi': GlobalStateFE().deskripsiObservasi.toString(),
          'img': '', // If you want to include an image
        },
      );

      if (response.statusCode == 201) {
        print('Tindak Lanjut created successfully');
      } else {
        print('Failed to create Tindak Lanjut. Response: ${response.data}');
      }
    } catch (e) {
      print('Error in _createTindakLanjut: ${e.toString()}');
    }
  }
}