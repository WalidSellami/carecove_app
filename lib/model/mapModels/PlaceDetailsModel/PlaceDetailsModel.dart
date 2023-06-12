class PlaceDetailsModel {

  String? name;
  AddressData? address;
  PlaceDetailsModel.fromJson(Map<String , dynamic> json){
    name = json['display_name'];
    address = (json['address'] != null) ? AddressData.fromJson(json['address']) : null;
  }

}


class AddressData {

  String? road;
  String? village;
  String? region;
  String? country;
  String? cityDistrict;
  String? city;
  String? town;

  AddressData.fromJson(Map<String , dynamic> json) {
    road = json['road'];
    village = json['village'];
    region = json['region'];
    country = json['country'];
    cityDistrict = json['city_district'];
    city = json['city'];
    town = json['town'];
  }


}