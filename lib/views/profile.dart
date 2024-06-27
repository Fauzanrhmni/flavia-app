import 'dart:convert';

import 'package:flavia_app/model/api.dart';
import 'package:flavia_app/model/userModel.dart';
import 'package:flavia_app/utils/global.colors.dart';
import 'package:flavia_app/views/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = ''; // Default value untuk name
  String username = ''; // Default value untuk name
  String image = ''; // Default value untuk name
  String id = ''; // Default value untuk name

  Future<void> _fetchUserData(String id) async {
    final response = await http.post(
      Uri.parse(BaseUrl.profile),
      body: {'id': id},
    );

    if (response.statusCode == 200) {
      // Jika request berhasil
      final jsonData = jsonDecode(response.body);
      setState(() {
        name = jsonData['name'];
        username = jsonData['username'];
        image = jsonData['image'];
      });
    } else {
      // Jika request gagal
      setState(() {
        name = 'Failed to load data';
        username = 'Failed to load data';
        image = 'Failed to load data';
      });
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id") ?? "";
    });
    _fetchUserData(id);
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          "Profile",
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              color: GlobalColors.hitam,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 11),
          child: SvgPicture.asset(
            'assets/svgs/head_logo.svg', // Path ke file SVG
            height: 23,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 20), // Spacer
              ClipOval(
                child: image == 'profile.jpg'
                    ? Image.asset(
                        'assets/jpg/profile.jpg',
                        fit: BoxFit.cover,
                        height: 200,
                        width: 200,
                      )
                    : Image.network(
                        '${BaseUrl.uploadProfile}${image}',
                        fit: BoxFit.cover,
                        height: 200,
                        width: 200,
                      ),
              ),
              SizedBox(height: 20), // Spacer
              Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(237, 237, 237, 1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: Color.fromRGBO(213, 213, 213, 1), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 7,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(13),
                child: Text(
                  username,
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10), // Spacer
              Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(237, 237, 237, 1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: Color.fromRGBO(213, 213, 213, 1), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 7,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(13),
                child: Text(
                  name,
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10), // Spacer
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditProfile(
                        username: username,
                        name: name,
                        image: image,
                        model: UserModel(
                          id: id,
                          username: username,
                          level: '',
                          name: name,
                          image: image,
                          createdDate: '',
                          status: '',
                        ),
                        reload: () {
                          _fetchUserData(id);
                        },
                      ),
                    ),
                  );
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
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
