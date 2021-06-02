class Achievement {
  int countAgent;
  int countTransAmt;
  int sumTransAmt;
  int countDevice;

  Achievement(
      {this.countAgent,
        this.countTransAmt,
        this.sumTransAmt,
        this.countDevice});

  Achievement.fromJson(Map<String, dynamic> json) {
    countAgent = json['countAgent'];
    countTransAmt = json['countTransAmt'];
    sumTransAmt = json['sumTransAmt'];
    countDevice = json['countDevice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countAgent'] = this.countAgent;
    data['countTransAmt'] = this.countTransAmt;
    data['sumTransAmt'] = this.sumTransAmt;
    data['countDevice'] = this.countDevice;
    return data;
  }
}