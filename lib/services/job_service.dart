import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtmgtt/models/user_model.dart';
import 'package:uuid/uuid.dart';

class JobDatabaseService {
  final CollectionReference jobsCollection = FirebaseFirestore.instance.collection('jobs');
  var uuid = Uuid();
  Stream<List<Job>> get notStartedJobs {
    return jobsCollection.where('jobStatus', isNotEqualTo: 'Completed').snapshots().map(_jobList);
  }

  List<Job> _jobList(QuerySnapshot enquiry) {
    return enquiry.docs.map((doc) {
      return Job(
        jobID: doc.data()['jobID'],
        jobName: doc.data()['jobName'],
        jobValue: doc.data()['jobValue'],
        jobStatus: doc.data()['jobStatus'],
      );
    }).toList();
  }

  Future createJob(
    String jobName,
    int jobValue,
  ) async {
    String docID = uuid.v4();
    jobsCollection.doc(docID).set({
      'jobID': docID,
      'jobName': jobName,
      'jobValue': jobValue,
      'jobStatus': 'NotStarted',
    });
  }

  updateJob(String jobID, String jobStatus){
    jobsCollection.doc(jobID).update({
      'jobStatus': jobStatus,
    });
  }
}