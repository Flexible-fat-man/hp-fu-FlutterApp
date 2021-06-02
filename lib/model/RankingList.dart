class RankingList {
  String agentNo;
  String agentName;
  int lft;
  int rgt;
  num sumTransAmt;
  int countEnableDate;

  RankingList(
      {this.agentNo,
        this.agentName,
        this.lft,
        this.rgt,
        this.sumTransAmt,
        this.countEnableDate});

  RankingList.fromJson(Map<String, dynamic> json) {
    agentNo = json['agentNo'];
    agentName = json['agentName'];
    lft = json['lft'];
    rgt = json['rgt'];
    sumTransAmt = json['sumTransAmt'];
    countEnableDate = json['countEnableDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agentNo'] = this.agentNo;
    data['agentName'] = this.agentName;
    data['lft'] = this.lft;
    data['rgt'] = this.rgt;
    data['sumTransAmt'] = this.sumTransAmt;
    data['countEnableDate'] = this.countEnableDate;
    return data;
  }
}