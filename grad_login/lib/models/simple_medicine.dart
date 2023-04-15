class SimpleMedicine {
  int? id;
  String? name;
  String? nameAr;
  List<Drug>? drugs;
  List? medicineImages;

  SimpleMedicine(
      {this.id, this.name, this.nameAr, this.drugs, this.medicineImages});

  SimpleMedicine.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['name_ar'];
    if (json['drug'] != null) {
      drugs = <Drug>[];
      json['drug'].forEach((drug) {
        drug!.add(Drug.fromJson(drug));
      });
    }
    if (json['medicine_images'] != null) {
      medicineImages = [];
      json['medicine_images'].forEach((image) {
        medicineImages!.add(image);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['name_ar'] = nameAr;
    if (drugs != null) {
      data['drug'] = drugs!.map((drug) => drug.toJson()).toList();
    }
    if (medicineImages != null) {
      data['medicine_images'] =
          medicineImages!.map((image) => image.toJson()).toList();
    }
    return data;
  }
}

class Drug {
  int? id;
  String? name;

  Drug({this.id, this.name});

  Drug.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}