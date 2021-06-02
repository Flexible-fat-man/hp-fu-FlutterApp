class Withdraw {
  String agentWithdrawNo;
  String agentNo;
  String agentName;
  String remark;
  int withdrawMoney;
  int withdrawStatus;
  int createTime;
  int deleteTime;

  Withdraw(
      {this.agentWithdrawNo,
        this.agentNo,
        this.agentName,
        this.remark,
        this.withdrawMoney,
        this.withdrawStatus,
        this.createTime,
        this.deleteTime});

  Withdraw.fromJson(Map<String, dynamic> json) {
    agentWithdrawNo = json['agentWithdrawNo'];
    agentNo = json['agentNo'];
    agentName = json['agentName'];
    remark = json['remark'];
    withdrawMoney = json['withdrawMoney'];
    withdrawStatus = json['withdrawStatus'];
    createTime = json['createTime'];
    deleteTime = json['deleteTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agentWithdrawNo'] = this.agentWithdrawNo;
    data['agentNo'] = this.agentNo;
    data['agentName'] = this.agentName;
    data['remark'] = this.remark;
    data['withdrawMoney'] = this.withdrawMoney;
    data['withdrawStatus'] = this.withdrawStatus;
    data['createTime'] = this.createTime;
    data['deleteTime'] = this.deleteTime;
    return data;
  }
}