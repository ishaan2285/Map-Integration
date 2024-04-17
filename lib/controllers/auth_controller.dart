import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  final FirebaseStorage storage= FirebaseStorage.instance;
  pickimageprofile(ImageSource source) async{
    final ImagePicker imagepicker= ImagePicker();

    XFile? file= await imagepicker.pickImage(source: source);
    if(file!=null){
      Uint8List fileByte = await file.readAsBytes();
      return  fileByte;
    }
    else{
      print("No image");
    }
  }
  uploadImageToStorage (Uint8List? image) async {
    Reference ref = storage.ref().child('profileImages').child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(image!);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  Future<String> createNewUser(String email, String fullName,
      String password) async {
    String res = 'some erorr occured';
    try {
      UserCredential userCredential=await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
     // String downloadUrl= uploadImageToStorage(image);
      await firestore.collection('buyers').doc(userCredential.user!.uid).set({'fullName':fullName, 'email':email, 'password':password});
      res = 'success';
      print(res);
    }
    catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginuser(String email, String password)async{
    String res='some error occured';
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res='success';
    }
    catch(e){
      res=e.toString();
    }
    return res;
  }
}