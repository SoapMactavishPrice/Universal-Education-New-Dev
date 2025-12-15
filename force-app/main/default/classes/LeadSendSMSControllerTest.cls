@isTest
public class LeadSendSMSControllerTest {
    @isTest
    public static void testsms(){
        Lead obj = new Lead(LastName ='Test', Company='test company',MobilePhone='8197318304',Phone='8191318304');
     	insert obj;
        smsgupshupTemplate__c temp=new smsgupshupTemplate__c(Name__c='test',Description__c='Dear Parent, School other Contact Numbers are +91 8080040602 / 3 / 4');
        insert temp;
        //smsgupshup__c sg=new smsgupshup__c(Contact_ID__c=obj.Id, Contact_Name_Number__c='test', Message__c='test message', Sender_Number__c='7534267222');
		//insert sg;        
        PageReference pageRef = Page.LeadSendSMS;
        Test.setCurrentPage(pageRef);
     	pageRef.getParameters().put('Id',obj.Id);
     	ApexPages.StandardController sc = new ApexPages.StandardController(obj);
     	LeadSendSMSController testcon = new LeadSendSMSController(sc);
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorOtp());
        testcon.sendsms();
        testcon.sendgupshupsms();
        testcon.getsmsTemplates();
        Test.stopTest();
        
    }
   
}