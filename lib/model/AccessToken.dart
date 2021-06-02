class AccessToken {
  String _accessToken;

  AccessToken({String accessToken}) {
    this._accessToken = accessToken;
  }

  String get accessToken => _accessToken;
  set accessToken(String accessToken) => _accessToken = accessToken;

  AccessToken.fromJson(Map<String, dynamic> json) {
    _accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this._accessToken;
    return data;
  }
}
