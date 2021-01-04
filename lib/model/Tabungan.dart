
class Tabungan {

  String id_nasabah;
  String total_tabungan;

	Tabungan.fromJsonMap(Map<String, dynamic> map): 
		id_nasabah = map["id_nasabah"],
		total_tabungan = map["total_tabungan"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id_nasabah'] = id_nasabah;
		data['total_tabungan'] = total_tabungan;
		return data;
	}
}
