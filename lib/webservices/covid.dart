
class Covid {

  String name;
  String positif;
  String sembuh;
  String meninggal;
  String dirawat;

	Covid.fromJsonMap(Map<String, dynamic> map): 
		name = map["name"],
		positif = map["positif"],
		sembuh = map["sembuh"],
		meninggal = map["meninggal"],
		dirawat = map["dirawat"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = name;
		data['positif'] = positif;
		data['sembuh'] = sembuh;
		data['meninggal'] = meninggal;
		data['dirawat'] = dirawat;
		return data;
	}
}
