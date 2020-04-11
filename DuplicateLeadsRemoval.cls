/**
 * @File Name          : DuplicateLeadsRemoval.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 11/4/2020, 12:16:02 pm
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2/25/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
 **/



global class DuplicateLeadsRemoval implements Database.Batchable < sObject > , Database.Stateful {

     String uniqueValue=System.Label.Email;

 
  global Map < String, Lead > leadMap = new Map < String, Lead > ();



  /**
   * start method queries the records on lead and pass the records in batches to execute method for processing
   * @param  BC Database.BatchableContext
   * @return    returns the fetched records
   */
  global Database.QueryLocator start(Database.BatchableContext BC) {
    // Access initialState here 

      System.debug('query'+Database.getQueryLocator('SELECT ' + uniqueValue +' FROM Lead ORDER BY CreatedDate'));

    return Database.getQueryLocator('SELECT ' + uniqueValue +' FROM Lead ORDER BY CreatedDate');
  }

  /**
   * execute method removes the duplicate leads from the list
   */
  global void execute(Database.BatchableContext BC,
    List < Lead > batch) {

    // Access initialState here
    List < Lead > duplicateLeads = new List < Lead > (); //List of lead initialized
        System.debug('batch'+batch);
    for (lead l: batch) {								 //Scope is iterated
      /**
       * If the email is not present in any lead record present, put the email in map of lead
       */
          String distinct='' ;
        
                 distinct = String.valueOf(l.get(uniqueValue));
			
        System.debug('distict===>'+distinct);
      if (!leadMap.containsKey(distinct) ) {
        leadMap.put(distinct, l);
 System.debug('LeadMap'+leadMap);
          
      }
      //If the email record is already present, Add the record in list of duplicateleads initialized earlier
       else {
        duplicateLeads.add(l); 
      }
    }
        
    /**
     * Check if the list is not empty and delete all the records in the list
     */
    if (!duplicateLeads.isEmpty()) {
      delete duplicateLeads;
    }



  }

  global void finish(Database.BatchableContext BC) {
    // Access initialState here 
    DateTime dt=System.now().addHours(3);
    string min=String.valueOf(dt.Minute());
    string dayOfMonth=String.valueOf(dt.day());
    string hour=String.valueOf(dt.hour());
    string yr=String.valueOf(dt.year());
    string month=String.valueOf(dt.month());
    string second='0';
    string DayOfWeek='?';

    //string today=String.valueOf(System.now().day());
    //if(dayOfMonth==today){
        string cron=second+' '+min+' '+hour+' '+dayOfMonth+' '+month+' '+DayOfWeek+' '+yr;
        DuplicateLeadRemovalScheduler batch=new DuplicateLeadRemovalScheduler();
        System.schedule('Batch Schedule 5'+dt+'' ,cron, batch);

    //}
  }
}



/*
DuplicateLeadsRemoval a=new DuplicateLeadsRemoval();

Id batchJobId = Database.executeBatch(a, 200);
*/