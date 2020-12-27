class AppUser {
  final uid;
  AppUser({this.uid});
}

class UserData {
  final String uid;
  final String userType; //worker, boss
  final String name;
  final int walletValue;

  UserData({this.uid, this.name, this.walletValue, this.userType});
}

class Job {
  final String jobID;
  final String jobName;
  final int jobValue;
  final String jobStatus; //NotStarted, Started, Awaiting Approval, Completed

  Job({this.jobID, this.jobName, this.jobValue, this.jobStatus});
}