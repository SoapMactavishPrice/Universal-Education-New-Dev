@isTest

public class SendSMSforBussinessHourTest {
    
    Static testMethod void sendSMS(){
        
        Account acc = new Account();
        acc.Name = 'test Account';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'test last name';
        con.FirstName = 'test Firest name';
        con.Phone='9617904978';
        con.AccountId=acc.id;
        insert con;
        
        Task t = new Task();
        t.WhoId=con.id;
        t.knowlarity_cti__Call_Disposition__c='Test Description';
        insert t;
        
        smsgupshupTemplate__c smtemplate = new smsgupshupTemplate__c();
          smtemplate.Name__c = 'Test Template';
          smtemplate.Description__c = 'success';
          insert smtemplate;
        
         smsgupshup__c smsgupshup=new smsgupshup__c();
         smsgupshup.Contact_ID__c=con.Id;
         smsgupshup.Contact_Name_Number__c=con.Name;
         smsgupshup.Message__c= smtemplate.Description__c;
         smsgupshup.Sender_Number__c=con.Phone;
         // smsgupshup.Message__c='success';
          insert smsgupshup;   
    }   
    
    

}