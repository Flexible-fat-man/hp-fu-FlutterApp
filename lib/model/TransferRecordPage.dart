class TransferRecord {
  String agentNo;
  String agentName;
  String subAgentNo;
  String subAgentName;
  String actionType;
  String remark;

  TransferRecord({
    this.agentNo,
    this.agentName,
    this.subAgentNo,
    this.subAgentName,
    this.actionType,
    this.remark,
  });

  TransferRecord.fromJson(Map<String, dynamic> json) {
    agentNo = json['agentNo'];
    agentName = json['agentName'];
    subAgentNo = json['subAgentNo'];
    subAgentName = json['subAgentName'];
    actionType = json['actionType'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agentNo'] = this.agentNo;
    data['agentName'] = this.agentName;
    data['subAgentNo'] = this.subAgentNo;
    data['subAgentName'] = this.subAgentName;
    data['actionType'] = this.actionType;
    data['remark'] = this.remark;
    return data;
  }
}
