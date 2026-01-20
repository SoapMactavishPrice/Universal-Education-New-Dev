@isTest
public class Send_EnquiryFormLink_MassEmailTest {
    
    @isTest 
    public static void testSendEmailNotificationPostive()
    {
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Lead testLead = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert testLead;
        
        Account acc = new Account();
        acc.Name ='Test_account_name';
        acc.School_Short_Code__c='UHSC';
        insert acc;
        
        List<Id> conListId= new List<Id>();
        
        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='himanshunimje@live.com';
        con.Type__c='Admission Enquiry';
        con.Enquiry_Link_Sent__c=false;
        con.Lead__c=testLead.Id;
        insert con;
        
        Contact con1 = new Contact();
        con1.FirstName = 'Test_First_name';
        con1.LastName ='Test_Last _name';
        con1.AccountId=acc.Id;
        con1.MobilePhone='844691090';
        con1.Email='himanshunimje@live.com';
        con1.Type__c='Admission Enquiry';
        con1.Lead__c=testLead.Id;
        con1.Enquiry_Link_Sent__c=false;
        
        insert con1;
        
        conListId.add(con.Id);
        conListId.add(con1.Id);
        
        
        List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
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
        enq.Application_Sent__c=false;
        enq.School_Tour_Scheduled__c=false;
        enq.School_Tour_Re_Scheduled__c=false;
        enq.Interaction_Done__c=true;
        enq.Lead__c=testLead.Id;
        enqlist.add(enq);
        insert enqlist;
       
        smsgupshupTemplate__c sms = new smsgupshupTemplate__c();
        sms.Name__c = 'OTP';
        sms.Description__c = 'Your OTP for using the Universal Admission Enquiry System is %code%';
        insert sms;        
        
        test.startTest(); 
        Send_EnquiryFormLink_MassEmail.SendEmailNotification(conListId);
        test.stopTest();
        
        
       
    }
    
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"success": true, "message": "Callout simulated successfully"}');
            res.setStatusCode(200);
            return res;
        }
    }
}