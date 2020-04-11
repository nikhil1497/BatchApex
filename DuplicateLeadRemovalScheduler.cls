/**
 * @File Name          : DuplicateLeadRemovalScheduler.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 11/4/2020, 12:17:26 pm
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2/26/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
global class DuplicateLeadRemovalScheduler implements Schedulable
{
    /**
     * execute method executes the batch class
     * @param  sc SchedulableContext
     */
    global void execute(SchedulableContext sc)
    {
        // Implement any logic to be scheduled
       
        // We now call the batch class to be scheduled
        DuplicateLeadsRemoval b = new DuplicateLeadsRemoval ();
       
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b,200);
    }
   
}


/*

DuplicateLeadRemovalScheduler batchSch=new DuplicateLeadRemovalScheduler();
String sch='0 5 2 * * ?';

System.schedule('Batch Schedule' ,sch, batchSch);
*/