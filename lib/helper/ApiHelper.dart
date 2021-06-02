class ApiHelper {
  static String base = "https://flm.zhengzhouwannengbang.com";

  // 登录
  static String Accountlogin = "/agent/Account/login";

  // static String Devicequery = base + "/agent/Device/query";

  //服务商列表
  static String AgentQuery = "/agent/Agent/query";

  //商户统计
  static String statisticByMerchant = "/agent/Device/statisticByMerchant";

  //商户列表
  static String DeviceQuery = "/agent/Device/query";

  //我的
  static String AgentMe = "/agent/Agent/me";

  //邀请
  static String AgentInvite = "/index/Page/invite";

  //结算人信息
  static String AgentSettle = "/agent/Agent/settle";

  //交易金额
  static String statisticByDate = "/agent/Order/statisticByDate";

  //更改名称
  static String updateAgentName = "/agent/Agent/updateAgentName";

  //更改密码
  static String updatePassword = "/agent/Agent/updatePassword";

  //更改手机号
  static String updateAgentMobile = "/agent/Agent/updateAgentMobile";

  //注销
  static String solfDelete = "/agent/Agent/solfDelete";

  //个人日交易排行榜
  static String singleDayOrderRank = "/agent/Report/singleDayOrderRank";

  //个人月交易排行榜
  static String singleMonthOrderRank = "/agent/Report/singleMonthOrderRank";

  //个人日激活排行榜
  static String singleDayDeviceRank = "/agent/Report/singleDayDeviceRank";

  //个人月激活排行榜
  static String singleMonthDeviceRank = "/agent/Report/singleMonthDeviceRank";

  //团队日交易排行榜
  static String groupDayOrderRank = "/agent/Report/groupDayOrderRank";

  //团队月交易排行榜
  static String groupMonthOrderRank = "/agent/Report/groupMonthOrderRank";

  //团队日激活排行榜
  static String groupDayDeviceRank = "/agent/Report/groupDayDeviceRank";

  //团队月激活排行榜
  static String groupMonthDeviceRank = "/agent/Report/groupMonthDeviceRank";

  //查询服务商提现
  static String AgentWithdrawQuery = "/agent/AgentWithdraw/query";

  //服务商提现
  static String AgentWithdrawAdd = "/agent/AgentWithdraw/add";

  // 机具统计
  static String DeviceStatisticByDevice = "/agent/Device/statisticByDevice";

  //版本更新
  static String version = base + "/index/Callback/version";

  //业绩
  static String achievement = "/agent/Report/achievement";

  //业绩
  static String deviceFind = "/agent/Device/find";

  //所有子服务商
  static String agentQueryAllSon = "/agent/Agent/queryAllSon";

  //从我处转移走
  static String deviceTransferAwayByList = "/agent/Device/transferAwayByList";

  //从我处转移走
  static String deviceTransferAwayByNos = "/agent/Device/transferAwayByNos";

  //发送验证码
  static String sendVerifyCode = "/index/Callback/sendVerifyCode";

  //设置结算
  static String setValueForSub = "/agent/AgentRate/setValueForSub";

  //我的结算
  static String queryAllMine = "/agent/AgentRate/queryAllMine";

  //下级的结算
  static String queryAllSub = "/agent/AgentRate/queryAllSub";
  //我的下级
  static String devicestatiSticBySonAgent = "/agent/Device/statisticBySonAgent";
  //划拨记录
  static String deviceTransferQuery = "/agent/DeviceTransfer/query";
}

// Device/transferAwayByList  从我处转移走,编号列表childAgentNo,snNoStart,snNoEnd
// Device/transferAwayByNos  从我处转移走,编号集合childAgentNo,nos(json字符串)
// Device/transferBackByList 转移回来到我处,编号列表childAgentNo,snNoStart,snNoEnd
// Device/transferBackByNos 转移回来到我处,编号集合childAgentNo,nos(json字符串)
// Agent/queryAllSon 所有子服务商 accessToken
