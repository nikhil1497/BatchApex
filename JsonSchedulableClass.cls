/**
 * @File Name          : JsonSchedulableClass.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 9/4/2020, 8:39:30 pm
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    21/3/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
global class JsonSchedulableClass implements Schedulable{

    global void execute(SchedulableContext sc)
    {
       
/*JsonSchedulableClass jsonBatchSch=new JsonSchedulableClass();
string sch='';
System.schedule('Batch Schedule 3' ,sch, jsonBatchSch);*/
        // Implement any logic to be scheduled
       
        // We now call the batch class to be scheduled

        Id batchId = Database.executeBatch(new GenericRecordCreationEngine(),200);
        //GenericRecordCreationEngine a=new GenericRecordCreationEngine();       
        //Parameters of ExecuteBatch(context,BatchSize)
       // database.executebatch(b,200);
    }
   
}

/* //finish 3.59 4.0 schedulable 3.30 3.31 3.32 

2020-04-08 12:56:26         //System.now

'0 57 12 4 8 4 2020'        //next minute cron expression
JsonSchedulableClass jsonBatchSch=new JsonSchedulableClass();
String sch='0 57 12 4 8 4 2020';

System.schedule('Batch Schedule 3' ,sch, jsonBatchSch);
*/