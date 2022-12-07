// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import "dart:convert";

Future<datamodel> dataModelFromJson(String str) async {
  return datamodel.fromJson(json.decode(str));
}

Future<String> dataModelToJson(datamodel data1) async {
  return json.encode(data1.toJson());
}

class datamodel {
  datamodel({
    required this.summarize,
  }) {
    // TODO: implement datamodel
    throw UnimplementedError();
  }
  String summarize;

  factory datamodel.fromJson(Map<String, dynamic> json) => datamodel(
        summarize: json["summarize"],
      );

  Map<String, dynamic> toJson() => {
        "summarize": summarize,
      };
}
// MARK: - Welcome
//struct Welcome: Codable {
//let summarize: String
//}
