import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portalempleado/CreateUserPage.dart';
import 'package:portalempleado/MyHomePage.dart';

class LoginPage extends StatefulWidget{


  @override
  State createState(){
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage>{

  late String email, password;
  final _formsKey = GlobalKey<FormState>();
  String error='';

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Padding(
             padding: const EdgeInsets.all(16.0),
            child: Text("Login Page", style: TextStyle(color: Colors.black, fontSize: 20),),
         ) ,
        Offstage(
          offstage: error=='',
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(error, style: TextStyle(color: Colors.red, fontSize: 16),),

          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: formulario(),
        ),
          botonLogin(),
          nuevousuario(),
        ],
      ),
    );
  }
  
  Widget nuevousuario(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Nuevo usuario"),
        TextButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateUserPage()));
        }, child: Text("Registrarse")),
      ],
    );
  }
  
  
  Widget formulario(){
    return Form(
      key: _formsKey,
        child: Column(children: [
        buildEmail(),
        const Padding(padding: EdgeInsets.only(top: 12)),
        buildPassword()
    ]
    ));
  }



  Widget buildEmail(){
  return TextFormField(

    decoration: InputDecoration(
        labelText: "Email",
      border: OutlineInputBorder(
        borderRadius: new BorderRadius.circular(8),
        borderSide: new BorderSide(color: Colors.black)
      )
    ),
    keyboardType: TextInputType.emailAddress,
    onSaved: (String? value){
      email = value!;
    },
    validator: (value){
      if(value!.isEmpty){
        return "Este campo es obligatorio";
      }
      return null;
    },
  );
  }

  Widget buildPassword(){
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(8),
              borderSide: new BorderSide(color: Colors.black)
          )
      ),
      obscureText: true,
      validator: (value){
        if(value!.isEmpty){
          return "Este campo es obligatorio";
        }
        return null;
      },
      onSaved: (String? value){
        password = value!;
      },
    );
  }

  Widget botonLogin() {
    return FractionallySizedBox(
      widthFactor: 8.6,
      child: ElevatedButton(
          onPressed: () async{
              if(_formsKey.currentState!.validate()){
                _formsKey.currentState!.save();
                UserCredential? credenciales = await login(email, password);
                if(credenciales !=null){
                  if(credenciales.user != null){
                    if(credenciales.user!.emailVerified){
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => MyHomePage()), (
                              Route<dynamic> route) => false);
                    }
                    else{
                      //mostrar al usuario que tiene q verificar el email
                    setState(() {
                      error = "Debes verificar tu correo para acceder";
                    });
                    }
                  }
                }
              }


          },
          child: Text("Login")
      ),
    );
  }

  Future<UserCredential?>login(String email, String password) async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        setState(() {
          error = "usuario no encontrado";
        });
    }
      if(e.code == 'wrong-password'){
        setState(() {
          error = "contraseña incorrecta";
        });
      }
    }
  }

}