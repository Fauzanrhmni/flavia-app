class ProdukModel {
  final String id;
  final String namaProduk;
  final String qty;
  final String harga;
  final String createdDate;
  final String idUsers;
  final String name;
  final String image;
  final String deskripsi;

  ProdukModel(
      {required this.id,
      required this.namaProduk,
      required this.qty,
      required this.harga,
      required this.createdDate,
      required this.idUsers,
      required this.name,
      required this.image,
      required this.deskripsi});
}
