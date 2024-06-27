import 'dart:convert';

import 'package:flavia_app/model/api.dart';
import 'package:flavia_app/model/userModel.dart';
import 'package:flavia_app/utils/global.colors.dart';
import 'package:flavia_app/views/editUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  var loading = false;

  final List<UserModel> list = [];

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(
      Uri.parse(BaseUrl.lihatUser),
    );
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach(
        (api) {
          final ab = UserModel(
            id: api['id'],
            username: api['username'],
            level: api['level'],
            name: api['name'],
            image: api['image'],
            status: api['status'],
            createdDate: api['createdDate'],
          );
          list.add(ab);
        },
      );
      setState(() {
        loading = false;
      });
    }
  }

  String capitalize(String input) {
    return input.isNotEmpty
        ? '${input[0].toUpperCase()}${input.substring(1)}'
        : '';
  }

  dialogDelete(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            children: <Widget>[
              const Text("Apakah kamu yakin ingin menghapus user ini?"),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Tidak"),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      _delete(id);
                    },
                    child: const Text("Ya"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _delete(String id) async {
    final response = await http.post(
      Uri.parse(BaseUrl.deleteUser),
      body: {
        "idUsers": id,
      },
    );
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _lihatData();
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    super.initState();
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          "Data User",
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
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                return Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: GlobalColors.abu,
                          width: 2.0,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Gambar di tengah vertikal
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ClipOval(
                                  child: SizedBox(
                                    width: 90, // Ukuran gambar 1:1
                                    height: 90,
                                    child: x.image == 'profile.jpg'
                                        ? Image.asset(
                                            'assets/jpg/profile.jpg',
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            '${BaseUrl.uploadProfile}${x.image}',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    text: "${capitalize(x.name)} ",
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        color: GlobalColors.hitam,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            "(${x.level == '1' ? 'Admin' : 'User'})",
                                        style: TextStyle(
                                          color: x.level == '1'
                                              ? GlobalColors.pinky
                                              : GlobalColors.hijau,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Email",
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        color: GlobalColors.abu,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10),
                                  ),
                                ),
                                Text(
                                  x.username,
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        color: GlobalColors.hitam,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Tanggal Dibuat",
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        color: GlobalColors.abu,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10),
                                  ),
                                ),
                                Text(
                                  x.createdDate,
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        color: GlobalColors.hitam,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    color: GlobalColors
                                        .hijau, // Warna latar belakang kuning
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Bentuk border radius
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                        Icons.mode_edit_outline_outlined),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditUser(x, _lihatData),
                                        ),
                                      );
                                    },
                                    color:
                                        GlobalColors.putih, // Warna icon putih
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: GlobalColors
                                        .pinky, // Warna latar belakang kuning
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Bentuk border radius
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Iconsax.trash),
                                    onPressed: () {
                                      dialogDelete(x.id);
                                    },
                                    color:
                                        GlobalColors.putih, // Warna icon putih
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
