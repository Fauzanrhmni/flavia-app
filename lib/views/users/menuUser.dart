import 'dart:convert';

import 'package:flavia_app/model/api.dart';
import 'package:flavia_app/model/keranjangModel.dart';
import 'package:flavia_app/model/produkModel.dart';
import 'package:flavia_app/utils/global.colors.dart';
import 'package:flavia_app/views/users/home.dart';
import 'package:flavia_app/views/users/invoice.dart';
import 'package:flavia_app/views/users/like.dart';
import 'package:flavia_app/views/users/profile.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MenuUser extends StatefulWidget {
  final VoidCallback signOut;
  const MenuUser({super.key, required this.signOut});

  @override
  State<MenuUser> createState() => _MenuUserState();
}

class _MenuUserState extends State<MenuUser> {
  String idUsers = "";
  String nameApi = "";

  getpref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id")!;
      nameApi = preferences.getString("name")!;
    });
    _lihatData();
  }

  var loading = false;
  final List<ProdukModel> list = [];

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(
      Uri.parse(BaseUrl.lihatProduk),
    );
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach(
        (api) {
          final ab = ProdukModel(
            id: api['id'],
            namaProduk: api['namaProduk'],
            qty: api['qty'],
            harga: api['harga'],
            deskripsi: api['deskripsi'],
            createdDate: api['createdDate'],
            idUsers: api['idUsers'],
            name: api['name'],
            image: api['image'],
          );
          list.add(ab);
        },
      );
      setState(() {
        _jumlahKeranjang();
        loading = false;
      });
    }
  }

  String jumlah = "0";
  final List<KeranjangModel> ex = [];

  _jumlahKeranjang() async {
    setState(() {
      loading = true;
    });
    final response =
        await http.get(Uri.parse(BaseUrl.jumlahKeranjang + idUsers));
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final exp = KeranjangModel(api['jumlah']);
      ex.add(exp);
      setState(() {
        jumlah = exp.jumlah;
      });
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getpref();
  }

  void refreshData() {
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: TabBarView(
          children: <Widget>[
            Home(refreshParent: refreshData),
            const Like(),
            const Invoice(),
            const Profile(),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 80.0,
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
              Tab(
                icon: ClipRect(
                  child: Stack(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        child: const Icon(Iconsax.heart),
                      ),
                      jumlah == "0"
                          ? const SizedBox()
                          : Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  jumlah,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              const Tab(
                icon: Icon(Iconsax.document),
              ),
              const Tab(
                icon: Icon(Iconsax.user),
              ),
              IconButton(
                onPressed: () {
                  widget.signOut();
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
