import 'package:dtmgtt/models/user_model.dart';
import 'package:dtmgtt/services/auth_service.dart';
import 'package:dtmgtt/services/job_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class BossScreen extends StatefulWidget {
  final List<Job> listOfJobs;
  BossScreen(this.listOfJobs);
  @override
  _BossScreenState createState() => _BossScreenState();
}

class _BossScreenState extends State<BossScreen> {
  final _addJobFormKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: FormBuilder(
                          key: _addJobFormKey,
                          child: Column(
                            children: [
                              Text('Add Job'),
                              SizedBox(height: 20),
                              FormBuilderTextField(
                                name: 'Job Name',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context),
                                ]),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey[300]),
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Job Name',
                                  hintText: 'Job Name',
                                ),
                              ),
                              FormBuilderTextField(
                                name: 'Job Value',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context),
                                  FormBuilderValidators.numeric(context),
                                ]),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey[300]),
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Job Value - \$',
                                  hintText: 'Job Value - \$',
                                ),
                              ),
                              Center(
                                child: RaisedButton(
                                  child: Text('Create Job'),
                                  onPressed: (){
                                    String jobName = _addJobFormKey.currentState.fields['Job Name'].value;
                                    var jobValue = int.parse(_addJobFormKey.currentState.fields['Job Value'].value);
                                    JobDatabaseService().createJob(jobName, jobValue);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ]
                          ),
                          ),
                      ),
                    ),
                  );
                }
              );
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
        child: Container(
          child: SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.listOfJobs.length,
              itemBuilder: (BuildContext context, int index){
                return ListTile(
                  title: Text(widget.listOfJobs[index].jobName),
                  subtitle: Text('Value: \$${widget.listOfJobs[index].jobValue}. Status: ${widget.listOfJobs[index].jobStatus}'),
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(20.0),
                              child: widget.listOfJobs[index].jobStatus == 'Awaiting Approval' 
                              ? RaisedButton(
                                  child: Text('Approve'),
                                  onPressed: (){
                                    JobDatabaseService().updateJob(widget.listOfJobs[index].jobID, 'Completed');
                                    Navigator.pop(context);
                                  }
                                ) 
                              : RaisedButton(
                                child: Text('Close'),
                                onPressed: (){
                                  Navigator.pop(context);
                                }), 
                            ),
                          ),
                        );
                      }
              );
                  },
                );
              },
            ),
            ),
        ),
        ),
    );
  }
}