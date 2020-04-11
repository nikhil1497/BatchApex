/** 
 * @File Name          : DuplicateLeadsRemovalTest.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 6/4/2020, 10:34:07 am
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    3/18/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@isTest public with sharing class DuplicateLeadsRemovalTest {
    @isTest 
    public static void leadDuplicateTest(){
        List<Lead> leadList=TestDataFactory.createLeadRecords(94);
        leadList.add(new Lead(Status='Open-Not Contacted',leadSource='Web',Email='ser0@gmail.com',Lastname='ABC',Company='Eternus',Phone='154'));
        leadList.add(new Lead(Status='Open-Not Contacted',leadSource='Web',Email='ser0@gmail.com',Lastname='ABC',Company='Eternus',Phone='5454'));
        leadList.add(new Lead(Status='Open-Not Contacted',leadSource='Web',Email='ser29@gmail.com',Lastname='ABC',Company='Eternus',Phone='5454'));
        leadList.add(new Lead(Status='Open-Not Contacted',leadSource='Web',Email='ser70@gmail.com',Lastname='ABC',Company='Eternus',Phone='5454'));

        insert leadList;        //Insert 100 Lead records 
      
        System.Test.startTest();

 DuplicateLeadsRemoval a=new DuplicateLeadsRemoval();
        Id batchJobId = Database.executeBatch(a, 150);

        System.Test.stopTest();
        leadList=[SELECT Id FROM lead];
        System.assertEquals(94,leadList.size());
    }
}