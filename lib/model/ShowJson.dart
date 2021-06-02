class ShowJson {
   int code;
   String msg;
  dynamic data;

  ShowJson(this.code, this.msg, this.data);

  ShowJson.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data1 = new Map<String, dynamic>();
    data1['code'] = this.code;
    data1['msg'] = this.msg;
    data1['data'] = this.data;
    return data;
  }
}
