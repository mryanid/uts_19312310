import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_get/app/routes/app_pages.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get streamAuthStatus => auth.authStateChanges();

  void signup(String emailAddress, String password) async {
    try {
      UserCredential myUser = await auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      await myUser.user!.sendEmailVerification();
      Get.defaultDialog(
          title: "Verifikasi Email",
          middleText:
              "Kami Telah mengirimkan verifikasi ke email $emailAddress.",
          onConfirm: () {
            Get.back();
            Get.back();
          },
          textConfirm: "OK");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void login(String emailAddress, String password) async {
    try {
      UserCredential myUser = await auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      if (myUser.user!.emailVerified) {
        //untuk routing
        Get.offAllNamed(Routes.HOME);
      } else
        (Get.defaultDialog(
          title: "Verifikasi Email",
          middleText: "Harap verifikasi email terlebih dahulu",
        ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void logout() async {
    await auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  void resetPassword(String emailAddress) async {
    //reset password
    if (emailAddress != '' && GetUtils.isEmail(emailAddress)) {
      try {
        await auth.sendPasswordResetEmail(email: emailAddress);
        Get.defaultDialog(
            title: "Priksa Email Anda!!",
            middleText:
                "Kami telah mengirim permintaan reset password ke $emailAddress.",
            onConfirm: () {
              Get.back();
              Get.back();
            },
            textConfirm: "Ok");
      } catch (e) {
        Get.defaultDialog(
            title: "Tidak bisa reset", middleText: "Sistem Error.");
      }
    } else {
      Get.defaultDialog(
        title: "Email tidak valid",
        middleText: "Perika kembali email anda.",
      );
    }
  }

  void LoginGoogle() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        Get.offNamed(Routes.HOME);
      } else {
        throw "Belum memilih akun google";
      }
    } catch (error) {
      print(error);
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "${error.toString()}",
      );
    }
  }
}
