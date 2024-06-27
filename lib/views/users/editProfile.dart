import 'dart:io';

import 'package:flavia_app/model/api.dart';
import 'package:flavia_app/model/userModel.dart';
import 'package:flavia_app/utils/global.colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  final String username;
  final String name;
  final String image;

  const EditProfile({
    Key? key,
    required this.username,
    required this.name,
    required this.image,
    required this.model,
    required this.reload,
  }) : super(key: key);

  final UserModel model;
  final VoidCallback reload;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String id = ''; // Default value untuk name

  final _key = GlobalKey<FormState>();
  String? username;
  String? name;
  late TextEditingController txtUsername;
  late TextEditingController txtName;

  @override
  void initState() {
    super.initState();
    txtUsername = TextEditingController(text: widget.username);
    txtName = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    txtUsername.dispose();
    txtName.dispose();
    super.dispose();
  }

  File? _newImageFile;
  _pilihGaleri() async {
    var picker = ImagePicker();
    var image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxHeight: 2000,
      maxWidth: 2000,
    );
    if (image != null) {
      setState(() {
        _newImageFile = File(image.path);
      });
    }
  }

  submit() async {
    try {
      var uri = Uri.parse(BaseUrl.editProfile);
      var request = http.MultipartRequest("POST", uri);

      // Jika _newImageFile tidak null, tambahkan gambar baru ke request
      if (_newImageFile != null) {
        var stream =
            http.ByteStream(Stream.castFrom(_newImageFile!.openRead()));
        var length = await _newImageFile!.length();
        request.files.add(http.MultipartFile(
          "image",
          stream,
          length,
          filename: path.basename(_newImageFile!.path),
        ));
      }

      request.fields['username'] = username!;
      request.fields['name'] = name!;
      request.fields['id'] = widget.model.id;

      var response = await request.send();
      if (response.statusCode == 200) {
        print("Edit user berhasil");
        // Panggil reload setelah berhasil menyimpan
        setState(() {
          Navigator.pop(context);
          widget.reload(); // Memuat ulang data pengguna di halaman Profile
        });
      } else {
        print("Gagal mengedit user. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id") ?? "";
    });
  }

  check() {
    final form = _key.currentState!;
    if (form.validate()) {
      form.save();
      submit();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = SizedBox(
      width: 150,
      height: 150,
      child: widget.model.image == 'profile.jpg'
          ? Image.asset(
              'assets/jpg/profile.jpg',
              height: 200,
              width: double.infinity,
            )
          : Image.network(
              '${BaseUrl.uploadProfile}${widget.model.image}',
              height: 200,
              width: double.infinity,
            ),
    );
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              color: GlobalColors.hitam,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: SvgPicture.asset(
              'assets/svgs/head_logo.svg', // Path ke file SVG
              height: 23,
            ),
          ),
        ],
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 25), 
              child: Text(
                "Anda tidak dapat mengubah email!",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 150,
              child: InkWell(
                onTap: () {
                  _pilihGaleri();
                },
                child: _newImageFile == null
                    ? placeholder
                    : SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: Image.file(
                          _newImageFile!,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 15),
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
                controller: txtUsername,
                readOnly: true,
                style: TextStyle(color: Colors.black),
                onSaved: (e) => username = e!,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  labelText: "Username",
                ),
              ),
            ),
            const SizedBox(height: 15),
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
                controller: txtName,
                onSaved: (e) => name = e!,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  labelText: "Name",
                ),
              ),
            ),
            const SizedBox(height: 15),
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
                    'Simpan',
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
    );
  }
}
