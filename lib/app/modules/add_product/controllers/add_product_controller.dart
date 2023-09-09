import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  late TextEditingController cNama;
  late TextEditingController cNpm;
  late TextEditingController cAlamat;
  late TextEditingController cJk;
  late TextEditingController cProgramstudi;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addProduct(String nama, String npm, String alamat, String jk,
      String program_studi) async {
    CollectionReference mahasiswa = firestore.collection("mahasiswa");

    try {
      await mahasiswa.add({
        "nama": nama,
        "npm": npm,
        "alamat": alamat,
        "jk": jk,
        "program_studi": program_studi,
      });
      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Berhasil menyimpan data ",
        onConfirm: () {
          cNama.clear();
          cNpm.clear();
          cAlamat.clear();
          cJk.clear();
          cProgramstudi.clear();
          Get.back();
          Get.back();
        },
      );
    } catch (e) {}
  }

  @override
  void onInit() {
    // TODO: implement onInit
    cNama = TextEditingController();
    cNpm = TextEditingController();
    cAlamat = TextEditingController();
    cJk = TextEditingController();
    cProgramstudi = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    cNama.dispose();
    cNpm.dispose();
    cAlamat.dispose();
    cJk.dispose();
    cProgramstudi.dispose();
    super.onClose();
  }
}
