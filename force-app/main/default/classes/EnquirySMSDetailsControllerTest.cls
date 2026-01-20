@isTest
public class EnquirySMSDetailsControllerTest {

    Static testmethod void EnquirySMSDetails(){
        
        smsgupshup__c sm = new smsgupshup__c();
        sm.Contact_ID__c='test';
        sm.Message__c='test message';
        insert sm;
        
       ApexPages.StandardController sc = new ApexPages.StandardController(sm);
       EnquirySMSDetailsController uf= new EnquirySMSDetailsController(sc);
        
    }
}