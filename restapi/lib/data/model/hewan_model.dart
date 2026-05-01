class HewanModel {
  final int id;
  final String nama;
  final String jenis;
  final String tanggalLahir;
  final int harga;
  final String status;

  HewanModel({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.tanggalLahir,
    required this.harga,
    required this.status,
  });

  factory HewanModel.fromJson(Map<String, dynamic> json) {
    return HewanModel(
      id: json['id'],
      nama: json['nama'],
      jenis: json['jenis'],
      tanggalLahir: json['tanggal_lahir'],
      harga: json['harga'],
      status: json['status'],
    );
  }
}
