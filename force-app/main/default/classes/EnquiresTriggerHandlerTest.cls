@isTest
public class EnquiresTriggerHandlerTest {
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
         
        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.AccountId=schInst.Id;
        con.MobilePhone='9123445678';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.Contact_Status__c = 'Qualified';
        con.Contact_Reasons__c = 'N/A';
        insert con;
        
        List<Enquiry__c> lstEnq = new List<Enquiry__c>();
         
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='test_parent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='test_address';
        enq.City__c='test_city';
        enq.State__c='test_state';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'test_source';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        lstEnq.add(enq);
        insert lstEnq;
        
        enq.Stages__c='Lost';
        update enq;

        Test.startTest();
        EnquiresTriggerHandler.updateCurrentStatus(lstEnq);
        EnquiresTriggerHandler.fakeMethod();
        Test.stopTest();
    }

}