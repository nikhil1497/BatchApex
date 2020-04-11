/**
 * @File Name          : GenericRecordCreationEngineTest.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 21/3/2020, 12:23:27 pm
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    21/3/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@isTest public with sharing class GenericRecordCreationEngineTest {
    @isTest
     public static void testJsonDeserialize(){
        List<EventJson__c> eventJsonRecords=TestDataFactory.createJsonRecords(2);
         insert eventJsonRecords;
         System.Test.startTest();
			//GenericRecordCreationEngine b=new GenericRecordCreationEngine();
			   Database.executeBatch(new GenericRecordCreationEngine());
         System.Test.stopTest();
         List<Account> accList=new List<Account>();
         accList=([SELECT id FROM Account]);
         System.assertEquals(2, accList.size(), 'passed');
         eventJsonRecords=([SELECT id FROM EventJson__c]);
         System.assertEquals(0, eventJsonRecords.size(), 'Passed');
    }
}