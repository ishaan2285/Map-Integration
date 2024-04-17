import 'package:animation/Views/screens/Register_screen.dart';
import 'package:animation/Views/screens/map_screen.dart';
import 'package:animation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final AuthController authController=AuthController();

  late String email;

  bool isloading=false;

  late String password;

  loginuser()async{
    if(formKey.currentState!.validate()) {
      setState(() {
        isloading=true;
      });
      String res = await authController.loginuser(email, password);
      setState(() {
        isloading=true;
      });
      if (res == 'success') {
        setState(() {
          isloading=false;
        });
        Get.to(MapScreen());
        Get.snackbar('Login Success', 'You are Now Logged In',
            backgroundColor: Colors.pink, colorText: Colors.white);
      }
      else {
        Get.snackbar(
            'Error Occured', res.toString(), backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Login Account",style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
              ),
              SizedBox(
                height: 25,
              ),
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
                decoration: InputDecoration(labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email,color: Colors.pink,),),
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
                decoration: InputDecoration(labelText: 'Password',
                  prefixIcon: Icon(Icons.lock,color: Colors.pink,),),
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  loginuser();
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width-40,
                  decoration: BoxDecoration(color: Colors.pink,
                  borderRadius: BorderRadius.circular(10)),
                  child: Center(child: isloading?CircularProgressIndicator(color: Colors.white,):Text('Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold
                  ),),)
                ),
              ),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return RegisterScreen();
                },),);
              }, child: Text('Need An Account'))
            ],
          ),
        ),
      ),
    );
  }
}
