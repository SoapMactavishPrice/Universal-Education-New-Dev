@istest
public class EnquirySendSMSControllerTest {
    static TestMethod void EnquirySendSMSControllerTest(){
          
         
          
          Account acc = new Account();
          acc.Name = 'VST';
         acc.School_Short_Code__c='UHT';
          insert acc;
          
          Contact con = new Contact();
          con.LastName = 'Gupta';
          con.AccountId = acc.Id;
          con.Phone = '9854215245';
          insert con;
          
          Enquiry__c enq = new Enquiry__c();
          enq.FirstName__c='test';
          enq.Last_Name__c='testLastname';
          enq.Mobile_No__c = '7418529630';
          enq.orgCode__c = 'EIS';
        enq.Contact__c=con.Id;
          insert enq;
          PageReference pageRef = Page.SendSmsEnquiry;
		  Test.setCurrentPage(pageRef);
   		  pageRef.getParameters().put('id',enq.id);       
          
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
          
        
        PageReference pg = Page.SendSmsEnquiry;
        Test.setCurrentPage(pg);
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(enq);
        
        Test.startTest();
        EnquirySendSMSController  scc = new EnquirySendSMSController(sc);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorOtp());
        scc.sendsms();
        scc.sendgupshupsms();
        scc.getsmsTemplates();
        Test.stopTest();
        
          
      }
}