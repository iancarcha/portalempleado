import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portalempleado/MyHomePage.dart';

class CreateUserPage extends StatefulWidget{


  @override
  State createState(){
    return _CreateUserState();
  }
}

class _CreateUserState extends State<CreateUserPage>{

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
      appBar: AppBar(
        title: Text("Portal del Empleado"),
      ),

      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Padding(
             padding: const EdgeInsets.all(16.0),
            child: Text("Crear Usuario", style: TextStyle(color: Colors.black, fontSize: 20),),
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
          botonCrearUsuario(),
        ],
      ),
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

  Widget botonCrearUsuario() {
    return FractionallySizedBox(
      widthFactor: 8.6,
      child: ElevatedButton(
          onPressed: () async{

              if(_formsKey.currentState!.validate()){
                _formsKey.currentState!.save();
                UserCredential? credenciales = await crear(email, password);
                if(credenciales !=null){
                  if(credenciales.user != null){
                    await  credenciales.user!.sendEmailVerification();
                      Navigator.of(context).pop();

                  }
                }
              }


          },
          child: Text("Registrarse")
      ),
    );
  }

  Future<UserCredential?>crear(String email, String password) async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;

    } on FirebaseAuthException catch(e){
      if(e.code == 'email-already-in-user'){
        setState(() {
          error = "El correo ya est registrado";
        });
    }
      if(e.code == 'weak-password'){
        setState(() {
          error = "Contraseña muy debil";
        });
      }
    }catch(e){
      print(e.toString());
    }
  }

}