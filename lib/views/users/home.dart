import 'package:flavia_app/model/keranjangModel.dart';
import 'package:flavia_app/utils/global.colors.dart';
import 'package:flavia_app/views/detailProduk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:flavia_app/model/api.dart';
import 'package:flavia_app/model/produkModel.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final Function refreshParent;
  const Home({super.key, required this.refreshParent});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final money = NumberFormat("#,###", "id_ID");

  String idUsers = "";
  String name = "";

  String capitalize(String input) {
    return input.isNotEmpty ? '${input[0].toUpperCase()}${input.substring(1)}' : '';
  }

  getpref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id")!;
      name = preferences.getString("name")!;
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

  tambahKeranjang(String idProduk, String harga) async {
    final response = await http.post(Uri.parse(BaseUrl.tambahkeranjang), body: {
      "idUsers": idUsers,
      "idProduk": idProduk,
      "harga": harga,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      print(pesan);
      _jumlahKeranjang();
      widget.refreshParent(); // Notify parent to refresh
    } else {
      print(pesan);
    }
  }

  String jumlah = "0";
  final List<KeranjangModel> ex = [];

  _jumlahKeranjang() async {
    setState(() {
      loading = true;
    });
    ex.clear();
    final response =
        await http.get(Uri.parse(BaseUrl.jumlahKeranjang + idUsers));
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final exp = new KeranjangModel(api['jumlah']);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          "Menu",
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
        child: Column(
          children: <Widget>[
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity, // Memastikan widget penuh lebar
                    child: Align(
                      alignment: Alignment
                          .centerLeft, // Mengatur teks menjadi rata kiri
                      child: Text(
                        "Hai User ${capitalize(name)}!",
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              color: GlobalColors.hitam,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity, // Memastikan widget penuh lebar
                    child: Align(
                      alignment: Alignment
                          .centerLeft, // Mengatur teks menjadi rata kiri
                      child: Text(
                        "Jelajahi Makanan Favorit Anda Di Sini",
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              color: GlobalColors.abu,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17.5),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      mainAxisExtent: 280),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailProduk(x),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: GlobalColors.abu,
                            width: 2.0,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              Hero(
                                tag: x.id,
                                child: Image.network(
                                  '${BaseUrl.uploadProduk}${x.image}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                child: Align(
                                  alignment: Alignment
                                      .centerLeft, // Mengatur teks menjadi rata kiri
                                  child: Text(
                                    x.namaProduk,
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          color: GlobalColors.hitam,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Harga\n',
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                            color: GlobalColors.abu,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              'Rp. ${money.format(int.parse(x.harga))}',
                                          style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                color: GlobalColors.hitam,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  tambahKeranjang(x.id, x.harga);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        GlobalColors.yellow, // Warna kuning
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8.0), // Radius bisa diubah
                                    ),
                                    minimumSize: const Size(0, 35)),
                                child: Text(
                                  "Like",
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                      color: GlobalColors.putih,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
