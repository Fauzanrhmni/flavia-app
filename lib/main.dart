import 'dart:convert';

import 'package:flavia_app/model/api.dart';
import 'package:flavia_app/utils/global.colors.dart';
import 'package:flavia_app/views/authentication/splash.view.dart';
import 'package:flavia_app/views/produk.dart';
import 'package:flavia_app/views/profile.dart';
import 'package:flavia_app/views/user.dart';
import 'package:flavia_app/views/users/menuUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn, signInUsers }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String? username, password;
  final _key = GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  var _autovalidate = false;

  check() {
    final form = _key.currentState!;
    if (form.validate()) {
      form.save();
      login();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  login() async {
    final response = await http.post(
      Uri.parse(BaseUrl.login),
      body: {"username": username, "password": password},
    );
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String usernameAPI = data['username'];
    String nameAPI = data['name'];
    String id = data['id'];
    String level = data['level'];
    if (level == "1") {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, usernameAPI, nameAPI, id, level);
      });
      print(pesan);
    } else {
      setState(() {
        _loginStatus = LoginStatus.signInUsers;
        savePref(value, usernameAPI, nameAPI, id, level);
      });
      print(pesan);
    }
    print(data);
  }

  savePref(
    int value,
    String username,
    String name,
    String id,
    String level,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("name", name);
      preferences.setString("username", username);
      preferences.setString("id", id);
      preferences.setString("level", level);
      // preferences.commit();
    });
  }

  // ignore: prefer_typing_uninitialized_variables
  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(
      () {
        value = preferences.getString("level");

        _loginStatus = value == "1"
            ? LoginStatus.signIn
            : value == "2"
                ? LoginStatus.signInUsers
                : LoginStatus.notSignIn;
      },
    );
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("value"); // Menghapus nilai "value"
    preferences.remove("level"); // Menghapus nilai "level"
    setState(() {
      _loginStatus = LoginStatus.notSignIn; // Mengubah status login
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          body: Form(
            key: _key,
            autovalidateMode: _autovalidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                const SizedBox(height: 30),
                SvgPicture.asset(
                  "assets/svgs/head_logo.svg",
                  height: 60,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Log In to ',
                      style: TextStyle(
                        color: GlobalColors.hitam,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      child: Text(
                        'Flavia',
                        style: TextStyle(
                          color: GlobalColors.yellow,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Welcome to Flavia, please enter your login details\nbelow to using the website',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: GlobalColors.hitam,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // Username
                Stack(
                  children: [
                    // Background tambahan di bawah Container
                    Container(
                      height: 55, // Sesuaikan tinggi dengan Container
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 7,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 75,
                      padding: const EdgeInsets.only(left: 15),
                      // Container utama dengan TextFormField
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (e) {
                              if (e!.isEmpty) {
                                const SizedBox(height: 15);
                                return 'Please enter your email';
                              } else if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(e)) {
                                return 'Wrong format email for username';
                              }
                              return null;
                            },
                            onSaved: (e) => username = e!,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(0),
                              labelText: "Email",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // const SizedBox(height: 15),
                // Password
                Container(
                  height: 55,
                  padding: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    obscureText: _secureText,
                    validator: (value) {
                      if (value!.length < 3) {
                        return "Minimal password 8 character";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (e) => password = e!,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(0),
                      labelText: "Password",
                      suffixIcon: IconButton(
                        onPressed: showHide,
                        padding: const EdgeInsets.only(right: 10),
                        icon: Icon(
                            _secureText ? Iconsax.eye_slash5 : Iconsax.eye4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Sign In Button
                MaterialButton(
                  onPressed: () {
                    check();
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: GlobalColors.yellow,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Container(
                      height: 55,
                      alignment: Alignment.center,
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                )
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 70,
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an Account?'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Register(),
                      ),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: GlobalColors.yellow,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case LoginStatus.signIn:
        return MainMenu(signOut);

      case LoginStatus.signInUsers:
        return MenuUser(signOut: signOut);
    }
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? username, password, name;
  final _key = GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  var validate = false;

  check() {
    final form = _key.currentState!;
    if (form.validate()) {
      form.save();
      save();
    } else {
      setState(() {
        validate = true;
      });
    }
  }

  save() async {
    final response = await http.post(
      Uri.parse(BaseUrl.register),
      body: {"name": name, "username": username, "password": password},
    );
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        // Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      });
    } else {
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        autovalidateMode:
            validate ? AutovalidateMode.always : AutovalidateMode.disabled,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            const SizedBox(height: 30),
            SvgPicture.asset(
              "assets/svgs/head_logo.svg",
              height: 60,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign Up to ',
                  style: TextStyle(
                    color: GlobalColors.hitam,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  child: Text(
                    'Flavia',
                    style: TextStyle(
                      color: GlobalColors.yellow,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Welcome to Flavia, create your account\nbelow to use the app',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: GlobalColors.hitam,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 25),
            // Fullname
            Container(
              height: 55,
              padding: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 7,
                  ),
                ],
              ),
              child: TextFormField(
                validator: (e) {
                  if (e!.isEmpty) {
                    return "Please insert fullname";
                  }
                  return null;
                },
                onSaved: (e) => name = e!,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  labelText: "Fullname",
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Username
            Container(
              height: 55,
              padding: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 7,
                  ),
                ],
              ),
              child: TextFormField(
                validator: (e) {
                  if (e!.isEmpty) {
                    return "Please insert username";
                  }
                  return null;
                },
                onSaved: (e) => username = e!,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  labelText: "Email",
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Password
            Container(
              height: 55,
              padding: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 7,
                  ),
                ],
              ),
              child: TextFormField(
                obscureText: _secureText,
                validator: (value) {
                  if (value!.length < 3) {
                    return "Minimal password 8 character";
                  } else {
                    return null;
                  }
                },
                onSaved: (e) => password = e!,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(0),
                  labelText: "Password",
                  suffixIcon: IconButton(
                    onPressed: showHide,
                    padding: const EdgeInsets.only(right: 10),
                    icon: Icon(_secureText ? Iconsax.eye_slash5 : Iconsax.eye4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Sign In Button
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Ink(
                decoration: BoxDecoration(
                  color: GlobalColors.yellow,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Container(
                  height: 55,
                  alignment: Alignment.center,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have an Account?'),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              child: Text(
                'Log In',
                style: TextStyle(
                  color: GlobalColors.yellow,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  const MainMenu(this.signOut, {super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String username = "";
  String nameApi = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username") ?? "";
      nameApi = preferences.getString("name") ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          children: <Widget>[
            Produk(nameApi: nameApi),
            User(),
            Profile(),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 80.0, // Atur tinggi yang diinginkan
          child: TabBar(
            labelColor: GlobalColors.yellow,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                style: BorderStyle.none,
              ),
            ),
            tabs: <Widget>[
              const Tab(
                icon: Icon(Iconsax.home),
              ),
              const Tab(
                icon: Icon(Iconsax.profile_2user),
              ),
              const Tab(
                icon: Icon(Iconsax.user),
              ),
              IconButton(
                onPressed: () {
                  signOut();
                },
                icon: const Icon(
                  Iconsax.logout,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
