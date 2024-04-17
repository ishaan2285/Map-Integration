
import 'dart:developer';
import 'dart:typed_data';

import 'package:animation/Views/screens/Login_screen.dart';
import 'package:animation/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthController authController=AuthController();
  late String email;
  late String fullname;
  late String password;
  bool isloading=false;
  Uint8List? image;
  selectimage() async{
    Uint8List im=await authController.pickimageprofile(ImageSource.gallery);
    setState(() {
      image=im;
      log(image!.toString());
    });
  }

  registeruser()async{
    if(image!=null){
      if(formKey.currentState!.validate()){
        setState(() {
          isloading=true;
        });
        String res= await authController.createNewUser(email,fullname, password,);
        if(res=='success'){
          Get.to(login());
          Get.snackbar('Success','Account has been created');
        }
        else{
          Get.snackbar('Error Occured',res.toString(),snackPosition: SnackPosition.BOTTOM);
        }
      }
      else{
        Get.snackbar('Form','Form Field is not valid');
      }
    }
    else{
      Get.snackbar('No Image','Please select image',snackPosition: SnackPosition.BOTTOM);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Register Account',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),),
            Stack(
              children: [
                image==null? CircleAvatar(
                radius: 65,
                child: Icon(Icons.person,size: 60),
              ):CircleAvatar(
                  radius: 65,
                  backgroundImage: MemoryImage(image!),
                ),
                Positioned(top:15,right:0,child:IconButton(
                    onPressed: (){
                      selectimage();
                    },
                    icon: Icon(CupertinoIcons.photo))
                )]
            ),
            SizedBox(height: 20,),
            TextFormField(
              onChanged: (value){
                email=value;
              },
              validator: (value){
                if(value!.isEmpty){
                  return 'Email Address cannot be empty';
                }
                else{
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'Enter Email Address',
                prefixIcon: Icon(Icons.email,color: Colors.pink,),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20,),
            TextFormField(
              onChanged: (value){
                fullname=value;
              },
              validator: (value){
                if(value!.isEmpty){
                  return 'Please Enteer your Full Name';
                }
                else{
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter Full Name',
                prefixIcon: Icon(Icons.person,color: Colors.pink,),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20,),
            TextFormField(
              onChanged: (value){
                password=value;
              },
              validator: (value){
                if(value!.isEmpty){
                  return 'Password cannot be empty';
                }
                else{
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter Password',
                prefixIcon: Icon(Icons.lock,color: Colors.pink,),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                registeruser();
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width-40,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Center(child: isloading?CircularProgressIndicator(color: Colors.white,):Text('Register',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white, letterSpacing: 4),)),
              ),
            ),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return login();
              }));
            }, child: Text('Already Have an Account'))
          ],
        ),
      ),
    );
  }
}
