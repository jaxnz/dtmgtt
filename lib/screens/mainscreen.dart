import 'package:dtmgtt/services/auth_service.dart';
import 'package:dtmgtt/services/job_service.dart';
import 'package:dtmgtt/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:dtmgtt/models/user_model.dart';

class MainScreen extends StatefulWidget {
  final int walletValue;
  final List<Job> listOfJobs;
  MainScreen({this.walletValue, this.listOfJobs});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int calculateTotal(List<Job> listOfJobs){
    int total = 0;
    listOfJobs.forEach((job) { 
      total += job.jobValue;
    });
    return total;
  }

  Job nextJob(List<Job> listOfJobs){
    //Either show job in progress or next job of the lowest value
    bool jobStarted = false;
    Job currentJob;
    listOfJobs.forEach((job) { 
      if(job.jobStatus == 'Started'){
        jobStarted = true;
        currentJob = job;
      }
    });
    if(jobStarted){
      return currentJob;
    } else {
      //sort jobs from lowest to highest and return lowest value Job
      listOfJobs.sort((a,b){
        return a.jobValue.compareTo(b.jobValue);
      });
      return listOfJobs[0];
    }
  }


  @override
  Widget build(BuildContext context) {
    Job currentJob = nextJob(widget.listOfJobs);
          return Scaffold(
            appBar: AppBar(
              title: Center(child: Text('DTMGTT')),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {});
                  },
                ),
                IconButton(
                  icon: Icon(Icons.login),
                  onPressed: () {
                    AuthService().signOut();
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.purple[800],
                      ),
                      width: double.infinity,
                      child: Center(
                          child: Column(
                        children: [
                          Text(
                            'Current Wallet Value',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '\$${widget.walletValue}',
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          )
                        ],
                      )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue[800],
                      ),
                      height: 200,
                      width: double.infinity,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('NEXT JOB:',
                              style: TextStyle(color: Colors.white)),
                          Text(
                            currentJob.jobName,
                            style: TextStyle(color: Colors.white, fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                          Text('Value: \$${currentJob.jobValue}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ],
                      )),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if(currentJob.jobStatus != 'Started'){
                        JobDatabaseService().updateJob(currentJob.jobID, 'Started');
                      } else if (currentJob.jobStatus == 'Started'){
                        JobDatabaseService().updateJob(currentJob.jobID, 'Awaiting Approval');
                      }
                    },
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: currentJob.jobStatus == 'Started' ? Text('Complete Job') : currentJob.jobStatus == 'Awaiting Approval' ? Text('Awaiting Approval...') : Text('Start Job'),
                  ),
                  Container(
                    color: Colors.grey[100],
                    height: 30,
                    width: double.infinity,
                    child:
                        Center(child: Text('Total available to earn: \$${calculateTotal(widget.listOfJobs)}')),
                  ),
                ],
              ),
            ),
          );
  }
}
