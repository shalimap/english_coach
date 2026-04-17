import 'dart:convert';

List<Structure> structureFromJson(String str) =>
    List<Structure>.from(json.decode(str).map((x) => Structure.fromJson(x)));

String structureToJson(List<Structure> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Structure {
  Structure({
    this.structNum,
    this.modNum,
    this.structStructure,
  });

  int? structNum;
  int? modNum;
  String? structStructure;

  factory Structure.fromJson(Map<String, dynamic> json) => Structure(
        structNum: int.parse(json["struct_num"]),
        modNum: int.parse(json["mod_num"]),
        structStructure: json["struct_structure"],
      );

  Map<String, dynamic> toJson() => {
        "struct_num": structNum,
        "mod_num": modNum,
        "struct_structure": structStructure,
      };
}
