import 'package:fluttersip/FrontEndOnly/AdminView/admin_peka_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_peka_page_fe.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class LaporanPekaController extends GetxController {
  final isLoading = false.obs;
  final userID = 0.obs;

  final box = GetStorage();


  Future submit({
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
    // required img
  }) async {


    try {
      isLoading.value = true;
      var data = {
        'nama_pegawai': namaPegawai,
        'email_pegawai' : emailPegawai,
        'nama_fungsi': namaFungsi,
        'lokasi_spesifik' : lokasiSpesifik,
        'deskripsi_observasi' : deskripsiObservasi,
        'direct_action' : directAction,
        'saran_aplikasi' : saranAplikasi,
        'tanggal': tanggal,
        'user_id': userId,
        'lokasi_id': lokasiId,
        'tipe_observasi_id': tipeobservasiId,
        'kategori_id' : kategoriId,
        'clsr_id' : clsrId,
        // 'img' : img,
      };

      var response = await http.post(
        Uri.parse('${url}laporans'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 201) {
        isLoading.value = false;
        var userRole = box.read('userRole');
        if (userRole == 'Admin') {
          Get.offAll(() => const AdminPekaPageFE());
        } else {
          Get.offAll(() => const UserPekaPageFE());
        }
      } else {
        isLoading.value = false;
        print('Input Laporan error: ${response.body}');
      }
    } catch (e) {
      isLoading.value = false;
      print('pala bapak kau pecah');
      print(e.toString());
      print('pala mamak kau pecah');
    }
  }
}