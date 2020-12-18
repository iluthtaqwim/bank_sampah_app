class TransaksiModel {
  String id_transaksi;
  String kode_transaksi;
  String berat_sampah;
  String tanggal_transaksi;
  String total_harga;
  String jenis_sampah;
  String harga;
  String id_nasabah;
  String nama_nasabah;

  TransaksiModel.fromJsonMap(Map<String, dynamic> map)
      : id_transaksi = map["id_transaksi"],
        kode_transaksi = map["kode_transaksi"],
        berat_sampah = map["berat_sampah"],
        tanggal_transaksi = map["tanggal_transaksi"],
        total_harga = map["total_harga"],
        jenis_sampah = map["jenis_sampah"],
        harga = map["harga"],
        id_nasabah = map["id_nasabah"],
        nama_nasabah = map["nama_nasabah"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_transaksi'] = id_transaksi;
    data['kode_transaksi'] = kode_transaksi;
    data['berat_sampah'] = berat_sampah;
    data['tanggal_transaksi'] = tanggal_transaksi;
    data['total_harga'] = total_harga;
    data['jenis_sampah'] = jenis_sampah;
    data['harga'] = harga;
    data['id_nasabah'] = id_nasabah;
    data['nama_nasabah'] = nama_nasabah;
    return data;
  }
}
