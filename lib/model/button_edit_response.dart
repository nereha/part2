class ResultModel {
  final bool result;

  ResultModel({
    this.result,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json){
    return ResultModel(
      result : json['result'],
    );
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["result"] = result;
    return map;
  }

}