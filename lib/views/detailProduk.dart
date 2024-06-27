import 'package:flavia_app/model/api.dart';
import 'package:flavia_app/model/produkModel.dart';
import 'package:flavia_app/utils/global.colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetailProduk extends StatefulWidget {
  final ProdukModel model;
  const DetailProduk(this.model, {super.key});

  @override
  State<DetailProduk> createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  final money = NumberFormat("#,###", "id_ID");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 400,
              floating: true,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Hero(
                    tag: widget.model.id,
                    child: Image.network(
                      '${BaseUrl.uploadProduk}${widget.model.image}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              backgroundColor: GlobalColors.abuputih,
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 20,
                right: 10,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 190,
                          child: Text(
                            widget.model.namaProduk,
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                color: GlobalColors.hitam,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Rp. ${money.format(int.parse(widget.model.harga))}",
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: GlobalColors.hitam,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Deskripsi",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          color: GlobalColors.hitam,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      widget.model.deskripsi,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          color: GlobalColors.abu,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Material(
                    color: GlobalColors.yellow,
                    borderRadius: BorderRadius.circular(10),
                    child: MaterialButton(
                      onPressed: () {},
                      height: 60,
                      child: Text(
                        "Add Like",
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            color: GlobalColors.putih,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
