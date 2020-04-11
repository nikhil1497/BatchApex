/**
 * @File Name          : GenericRecordCreationEngine.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 11/4/2020, 7:05:55 pm
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    3/8/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
 **/



global class GenericRecordCreationEngine implements Database.Batchable < sObject > , Database.Stateful {

    //Map<String, Object> cObjMap ;

    global GenericRecordCreationEngine() {

    }

    /**
     * start method fetches the query and returns the records to the batches for execution
     * @param  BC Batchable Context
     * @return    returns the records fetched by query
     */
    global Database.QueryLocator start(Database.BatchableContext BC) {

        String query = 'SELECT Id,  ObjectName__c,Json__c,record__c,processed__c,error__c FROM EventJson__c WHERE processed__c=false';
        System.debug(query);

        return Database.getQueryLocator(query);
    }

    /**
     * execute method deserialize the records and insert them in given object
     */
    global void execute(Database.BatchableContext BC,
        List < EventJson__c > eventRecords) {

        List < sobject > recordsToInsert = new List < sobject > ();

        System.debug('eventRecords : ' + eventRecords);
        for (EventJson__c eventItr: eventRecords) {
            System.debug('eventItr' + eventItr);


            if (eventItr.processed__c == false) {
                eventItr.Processed__c = true;
                System.debug('eventItr number=======>' + eventItr);
                try {
                    Object fieldList = (Object) JSON.deserializeUntyped(eventItr.JSON__c);
                    System.debug('fieldList====>' + fieldList);

                    Map < String, Object > mapObject = (Map < String, Object > ) fieldList;
                    System.debug('mapObject====>' + mapObject);

                    Schema.SObjectType sObj = Schema.getGlobalDescribe().get(eventItr.ObjectName__c);
                    System.debug('sObj==>' + sObj);

                    Schema.DescribeSObjectResult r = sObj.getDescribe();
                    System.debug('r===>' + r);

                    Map < String, Schema.SObjectField > fields = r.fields.getMap();
                    System.debug('fields===>' + fields);

                    sObject sObjIns = sObj.newSObject();
                    for (String fieldname: mapObject.keyset()) {
                        System.debug('fieldName====>' + fieldName);
                        sObjIns.put(fieldname, mapObject.get(fieldname));
                    }

                    System.debug('sObjIns===>' + sObjIns);
                    recordsToInsert.add(sObjIns);
                    eventItr.Record__c = true;

                } catch (exception e) {
                    System.debug('error message==>' + e.getMessage());
                    eventItr.Error__c = e.getMessage();
                }



            }

            System.debug(eventItr);

        }
        update eventRecords;
        System.debug(eventRecords);
        if (!recordsToInsert.isEmpty()) {

            System.debug('BEFOR INSERT  : ' + recordsToInsert);

            insert recordsToInsert;

        }

        System.debug('eventRecordsj before delete======>' + eventRecords);

        List < EventJson__c > deleteEventJsonList = [SELECT id
                                                            , Json__c, ObjectName__c, Processed__c, Record__c
                                                     FROM   EventJson__c
                                                     WHERE  Record__c = true
        ];
        System.debug('deleteEventJsonList==========>' + deleteEventJsonList);
        delete deleteEventJsonList;
    }





    global void finish(Database.BatchableContext BC) {
        DateTime dt = System.now().addMinutes(1);
        string min = String.valueOf(dt.Minute());
        string dayOfMonth = String.valueOf(dt.day());
        string hour = String.valueOf(dt.hour());
        string yr = String.valueOf(dt.year());
        string month = String.valueOf(dt.month());
        string second = '0';
        string DayOfWeek = '?';

        string today = String.valueOf(System.now().day());
        if (dayOfMonth == today) {
            string cron = second + ' ' + min + ' ' + hour + ' ' + dayOfMonth + ' ' + month + ' ' + DayOfWeek + ' ' + yr;
            JsonSchedulableClass jsonBatchSch = new JsonSchedulableClass();
            System.schedule('Batch Schedule 5' + dt + '', cron, jsonBatchSch);

        }

    }
}