class GetConfigList {
  final String color;
  final String name;
  final String idk;
  final String ref;
  final String icon;
  final String idf1;
  final String idf2;
  final String idf3;
  final String idf4;

  GetConfigList({
    this.color,
    this.name,
    this.idk,
    this.ref,
    this.icon,
    this.idf1,
    this.idf2,
    this.idf3,
    this.idf4,
  }) ;

  factory GetConfigList.fromJson(Map<String, dynamic> json){
    // var listData = json['icon'] as List;
    // List<GetIconData> data;
    // if(json['icon'] != null) {
    //   data = listData.map((i) => GetIconData.fromJson(i)).toList();
    // }
    return new GetConfigList(
      color: json['color'],
      name: json['name'],
      idk: json['idk'],
      ref: json['ref'],
      icon: json['icon'],
      idf1: json['idf1'],
      idf2: json['idf2'],
      idf3: json['idf3'],
      idf4: json['idf4'],
    );
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["color"] = color;
    map["name"] = name;
    map["idk"] = idk;
    map["ref"] = ref;
    // if (icon != null) {
    //   map["icon"] = icon.map((v) => v.toJson()).toList();
    // }
    map["icon"] = icon;
    map["idf1"] = idf1;
    map["idf2"] = idf2;
    map["idf3"] = idf3;
    map["idf4"] = idf4;
    return map;
  }
}

class GetIconData {
  final int codePoint;
  final String fontFamily;
  final String fontPackage;
  final bool matchTextDirection;

  GetIconData({
    this.codePoint,
    this.fontFamily,
    this.fontPackage,
    this.matchTextDirection,
  });

  factory GetIconData.fromJson(Map<String, dynamic> json){
    return GetIconData(
      codePoint : json['codePoint'],
      fontFamily : json['fontFamily'],
      fontPackage : json['fontPackage'],
      matchTextDirection : json['matchTextDirection'],
    );
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["codePoint"] = codePoint;
    map["fontFamily"] = fontFamily;
    map['fontPackage'] = fontPackage;
    map['matchTextDirection'] = matchTextDirection;
    return map;
  }

}