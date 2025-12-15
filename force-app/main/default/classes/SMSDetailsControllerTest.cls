@isTest

public class SMSDetailsControllerTest {
    
    Static testmethod void SMSDetails(){
        
        smsgupshup__c sm = new smsgupshup__c();
        sm.Contact_ID__c='test';
        sm.Message__c='test message';
        insert sm;
        
       ApexPages.StandardController sc = new ApexPages.StandardController(sm);
       SMSDetailsController uf= new SMSDetailsController(sc);
        
    }
}