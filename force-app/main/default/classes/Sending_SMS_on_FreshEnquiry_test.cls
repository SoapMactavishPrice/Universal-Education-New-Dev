@isTest
public class Sending_SMS_on_FreshEnquiry_test {
    public static testmethod void SMStrigger(){
        
        Account acc = new Account();
    acc.Name ='Test_account_name';
        acc.School_Short_Code__c='UHT';
    insert acc;
    
    Contact con = new Contact();
    con.FirstName = 'Test_First_name';
    con.LastName ='Test_Last _name';
    con.AccountId=acc.Id;
    con.MobilePhone='9123445678';
    con.Email='biswajit@developer.com';
    con.Type__c='Admission Enquiry';
    insert con;
        Enquiry__c e=new Enquiry__c();
        e.Stages__c='Enquiry';
        e.Mobile_No__c='9736921663';
        e.orgCode__c = 'EIS';
        e.Contact__c=con.Id;
        insert e;
        
        smsgupshupTemplate__c smtemplate = new smsgupshupTemplate__c();
        smtemplate.Name__c = 'Test Template';
        smtemplate.Description__c = 'success';
        insert smtemplate;
        
        
        smsgupshup__c smsgupshup=new smsgupshup__c();
        smsgupshup.Message__c= smtemplate.Description__c;
        insert smsgupshup;   
        
        e.Stages__c='Application Link Sent';
        update e;    
        
        EnquirySendSmSCallout enqs = new EnquirySendSmSCallout();
        EnquirySendSmSCallout.sendgupshupsms(smsgupshup.Message__c, e.Mobile_No__c, '2000045203', 'universalgoogle');
        EnquirySendSmSCallout.sendsms();
      
    }
}