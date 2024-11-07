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
    required String tanggal,
    required String userId,
    required String lokasiId,
    required String tipeobservasiId,
    required String kategoriId,
    required String clsrId,
    File? image,
    String? nonClsr,
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
        'non_clsr': nonClsr,
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
      final globalState = GlobalStateFE();
      final image = globalState.image;

      // Prepare form data, explicitly handling MultipartFile for the image
      dio.FormData formData = dio.FormData();

      formData.fields.addAll([
        MapEntry('tanggal', globalState.selectedTanggal!.toIso8601String()),
        MapEntry('tipe_observasi_id', globalState.selectedTipeObservasiId.toString()),
        const MapEntry('status', 'Open'),
        MapEntry('deskripsi', globalState.deskripsiObservasi.toString()),
        MapEntry('laporan_id', laporanId),
        MapEntry('lokasi_id', globalState.selectedLokasiId.toString()),
        MapEntry('detail_lokasi', globalState.lokasiSpesifik.toString()),
        MapEntry('kategori_id', globalState.selectedSubKategoriId.toString()),
        MapEntry('clsr_id', globalState.selectedClsrId.toString()),
        MapEntry('direct_action', globalState.directAction.toString()),
      ]);

      // Conditionally add non_clsr if necessary
      if (globalState.selectedClsrId == '450') {
        formData.fields.add(MapEntry('non_clsr', globalState.selectedNonClsr.toString()));
      }

      // Add the image file if available
      if (image != null) {
        formData.files.add(MapEntry(
          'img',
          await dio.MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        ));
      }

      var response = await _dio.post(
        '${url}tindaklanjuts',
        data: formData,
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