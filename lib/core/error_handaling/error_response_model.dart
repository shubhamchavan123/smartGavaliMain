class ErrorResponseModel {
  ErrorResponseModel({
    Meta? meta,
  }) {
    _meta = meta;
  }

  ErrorResponseModel.fromJson(json) {
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Meta? _meta;

  Meta? get meta => _meta;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_meta != null) {
      map['meta'] = _meta?.toJson();
    }
    return map;
  }
}

class Meta {
  Meta({String? code, String? message}) {
    _code = code;
    _message = message;
  }

  Meta.fromJson(json) {
    _code = json['status'];
    _message = json['statusMessage'];
  }

  String? _code;
  String? _message;

  String? get code => _code;

  String? get message => _message;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['status'] = _code;
    map['statusMessage'] = _message;
    return map;
  }
}
