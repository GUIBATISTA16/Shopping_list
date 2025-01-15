import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:shopping_list/screens/homepage.dart';
import 'package:shopping_list/screens/register_page.dart';
import 'package:shopping_list/widget/home/wrapperhome.dart';
import '../firebase_options.dart';
import '../globais/colorsglobal.dart';
import '../globais/functionsglobal.dart';
import '../globais/validator.dart';
import '../riverpod/loggeduserprovider.dart';
import '../service/auth.dart';
import '../widget/standalonewidgets/containerbordasfinas.dart';
import '../widget/standalonewidgets/loading.dart';
import '../widget/standalonewidgets/textoprincipal.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {

  bool passwordVisible = false;

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  Future<void> _initializeFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    User? user = FirebaseAuth.instance.currentUser;//caso já esteja loggado
    if (user != null) {
      ref.read(userUidProvider.notifier).state = FirebaseAuth.instance.currentUser?.uid;//atualiza o logged user

      print('Tá logado');
      Navigator.of(context).pushReplacement(//vai para a homepage
        MaterialPageRoute(
          builder: (context) => Wrapper(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List',
          style: TextStyle(color: textoPrincipal),),
        centerTitle: true,
        backgroundColor: principal,
      ),
      backgroundColor: fundoMenusSecondary,
      body:
        FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot){
            return loading ? Loading() : Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ContainerBordasFinas(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                              child: TextFormField(
                                validator: (value) => Validator.validateEmail(email: value),
                                controller: _emailTextController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                  hintText: 'Email',
                                  hintStyle: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                              child: TextFormField(
                                obscureText: !passwordVisible,
                                enableSuggestions: false,
                                autocorrect: false,
                                validator: (value) => Validator.validatePassword(password: value),
                                controller: _passwordTextController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                  hintText: 'Password',
                                  hintStyle: const TextStyle(color: Colors.black),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      !passwordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                String oldpass = _passwordTextController.text;//guarda a password escrita
                                _passwordTextController.text = '111111';//password "fake" para passar a validação
                                if(_formKey.currentState!.validate()){//verifica que um email foi escrito
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(email: _emailTextController.text);
                                  _passwordTextController.text = oldpass;//retorna a password antiga
                                  showCustomSnackBar(context, 'Email de redefinição de password enviado');
                                  return;
                                }
                                _passwordTextController.text = oldpass;//retorna a password antiga
                              },
                              child: Text('Esqueci-me da password!',
                                style: TextStyle(
                                  color: secondary
                                ),
                              )
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {//verifica se escreveu o email e a password
                                            setState(() {
                                              loading = true;//aparece o widget de loading
                                            });
                                            User? user = await FireAuth.signInUsingEmailPassword(
                                              email: _emailTextController.text,
                                              password: _passwordTextController.text,
                                            );
                                            if (user != null) {//caso consiga fazer login
                                              ref.read(userUidProvider.notifier).state = FirebaseAuth.instance.currentUser?.uid;//atualiza o logged user

                                              Navigator.of(context).pushReplacement(//vai para a home page
                                                MaterialPageRoute(
                                                  builder: (context) => Wrapper(),
                                                ),
                                              );
                                            }
                                            else {
                                              setState(() {//caso não faça login volta a pagina normal
                                                loading = false;
                                              });
                                            }
                                          }
                                        },
                                        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(principal)),
                                        child: const TextoPrincipal(text: 'Login',fontSize: 18,),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                                          );
                                        },
                                        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(principal)),
                                        child: const TextoPrincipal(text: 'Criar Conta',fontSize: 18,),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            SignInButton(
                              Buttons.GoogleDark,
                              text: "Sign up with Google",
                              padding: EdgeInsets.symmetric(horizontal: 70),
                              onPressed: () async {
                                setState(() {//aparece o widget de loading
                                  loading = true;
                                });
                                try {
                                  User? user = await FireAuth.signInWithGoogle();
                                  if (user != null) {//caso consiga fazer login
                                    ref.read(userUidProvider.notifier).state = FirebaseAuth.instance.currentUser?.uid;//atualiza o logged user

                                    Navigator.of(context).pushReplacement(//vai para a home page
                                      MaterialPageRoute(
                                        builder: (context) => Wrapper(),
                                      ),
                                    );
                                  }
                                  else {
                                    setState(() {//caso não faça login volta a pagina normal
                                      loading = false;
                                    });
                                  }
                                }
                                catch(e){
                                  print(e);
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              },
                            ),
                            SizedBox(width: 10,),
                          ],
                        ),
                      ),
                    ),

                  ),
                ),
              ),
            );
          },

        )
    );
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }
}
