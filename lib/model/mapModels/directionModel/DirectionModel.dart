class DirectionModel {

  List<Features> features = [];

  DirectionModel.fromJson(Map<String, dynamic> json) {

    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) { features.add(Features.fromJson(v)); });
    }

  }

}

class Features {
  Properties? properties;
  // Geometry? geometry;


  Features.fromJson(Map<String, dynamic> json) {
    properties = json['properties'] != null ? Properties.fromJson(json['properties']) : null;
    // geometry = json['geometry'] != null ? new Geometry.fromJson(json['geometry']) : null;
  }

}

class Properties {
  List<Segments> segments = [];
  Summary? summary;


  Properties.fromJson(Map<String, dynamic> json) {
    if (json['segments'] != null) {
      json['segments'].forEach((v) { segments.add(Segments.fromJson(v)); });
    }
    summary = json['summary'] != null ? Summary.fromJson(json['summary']) : null;
  }

}

class Segments {
  double? distance;
  double? duration;
  List<Steps> steps = [];


  Segments.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    duration = json['duration'];
    if (json['steps'] != null) {
      json['steps'].forEach((v) { steps.add(Steps.fromJson(v)); });
    }
  }
}

class Steps {
  double? distance;
  double? duration;
  int? type;
  String? instruction;
  String? name;
  List<int>? wayPoints;


  Steps.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    duration = json['duration'];
    type = json['type'];
    instruction = json['instruction'];
    name = json['name'];
    wayPoints = json['way_points'].cast<int>();
  }

}

class Summary {
  double? distance;
  double? duration;

  Summary({this.distance, this.duration});

  Summary.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    duration = json['duration'];
  }

}

class SegmentsData {

  double? distance;
  double? duration;

  SegmentsData.fromJson(Map<String , dynamic> json){
    distance = json['distance'];
    duration = json['duration'];
  }

}