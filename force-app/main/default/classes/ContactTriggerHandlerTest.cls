@isTest
public class ContactTriggerHandlerTest {
      @isTest public static void testmethod1(){
         
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());

        Account schInst = new Account();
        schInst.Name = 'Stellar World School (Bandra)';
        schInst.Website = 'https://stellarworldschool.edu.in/';
        schInst.School_Email__c = 'admissions.bandra@stellarworldschool.edu.in';
        schInst.School_Short_Code__c = 'STELRB';
        insert schInst;
         
        Lead ld = new Lead();
        ld.Acadmic_Year__c = '2022-2023';
        ld.LastName = 'test';
        ld.Email = 'test123@test.com';
        ld.MobilePhone = '9897898798';
        ld.Company = 'Test Company';
        ld.School_Institution__c = schInst.Id;
        ld.School_Short_Code__c = 'STELRB';
        ld.Your_First_Name__c = 'Ros';
        ld.Status = 'New';
        ld.LeadSource = 'Website';
        ld.utm_source__c = '';
        insert ld;
         
        List<Contact> lstCon= new List<Contact>();  
         
        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.AccountId=schInst.Id;
        con.MobilePhone='9123445678';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.Contact_Status__c = 'Qualified';
        con.Contact_Reasons__c = 'N/A';
        lstCon.add(con);
        insert lstCon;
        
        con.Contact_Status__c = 'New';
        update con;
          
        Test.startTest();
        ContactTriggerHandler.updateCurrentStatus(lstCon);
        ContactTriggerHandler.fakeMethod();
        Test.stopTest();
    }

}