class AgentQueryAllSon {
  String agentNo;
  String agentMobile;
  String agentName;
  String password;
  int lft;
  int rgt;
  int depth;
  String settleCardNo;
  String settleName;
  String settleMobile;
  String settleIdCard;
  int totalMoney;
  int canWithdrawalMoney;
  int applyWithdrawalMoney;
  int haveWithdrawalMoney;
  int createTime;
  int deleteTime;

  AgentQueryAllSon(
      {this.agentNo,
      this.agentMobile,
      this.agentName,
      this.password,
      this.lft,
      this.rgt,
      this.depth,
      this.settleCardNo,
      this.settleName,
      this.settleMobile,
      this.settleIdCard,
      this.totalMoney,
      this.canWithdrawalMoney,
      this.applyWithdrawalMoney,
      this.haveWithdrawalMoney,
      this.createTime,
      this.deleteTime});

  AgentQueryAllSon.fromJson(Map<String, dynamic> json) {
    agentNo = json['agentNo'];
    agentMobile = json['agentMobile'];
    agentName = json['agentName'];
    password = json['password'];
    lft = json['lft'];
    rgt = json['rgt'];
    depth = json['depth'];
    settleCardNo = json['settleCardNo'];
    settleName = json['settleName'];
    settleMobile = json['settleMobile'];
    settleIdCard = json['settleIdCard'];
    totalMoney = json['totalMoney'];
    canWithdrawalMoney = json['canWithdrawalMoney'];
    applyWithdrawalMoney = json['applyWithdrawalMoney'];
    haveWithdrawalMoney = json['haveWithdrawalMoney'];
    createTime = json['createTime'];
    deleteTime = json['deleteTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agentNo'] = this.agentNo;
    data['agentMobile'] = this.agentMobile;
    data['agentName'] = this.agentName;
    data['password'] = this.password;
    data['lft'] = this.lft;
    data['rgt'] = this.rgt;
    data['depth'] = this.depth;
    data['settleCardNo'] = this.settleCardNo;
    data['settleName'] = this.settleName;
    data['settleMobile'] = this.settleMobile;
    data['settleIdCard'] = this.settleIdCard;
    data['totalMoney'] = this.totalMoney;
    data['canWithdrawalMoney'] = this.canWithdrawalMoney;
    data['applyWithdrawalMoney'] = this.applyWithdrawalMoney;
    data['haveWithdrawalMoney'] = this.haveWithdrawalMoney;
    data['createTime'] = this.createTime;
    data['deleteTime'] = this.deleteTime;
    return data;
  }
}
