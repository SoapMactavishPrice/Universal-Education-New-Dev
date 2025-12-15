@isTest
public class send_ApplicationFormLink_MassEmailTest {
    
    class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest public static void testSendEmailNotificationPostive()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Account acc = new Account();
        acc.Name ='Test_account_name';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='himanshunimje@live.com';
        con.Type__c='Admission Enquiry';
        insert con;
        
        List<Id> enqlist=new List<Id>();
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
        insert enq;
        
        Enquiry__c enq1 = new Enquiry__c();
        enq1.Contact__c =con.Id;
        enq1.Enquiry_Type__c='Test_General';
        enq1.Date_of_Birth__c=system.today();
        enq1.Academic_Year__c='2015';
        enq1.FirstName__c='test_Student';
        enq1.Last_Name__c='Test';
        enq1.Log_Status__c='On Hold';
        enq1.Seeking_Admission_in_Grade__c='II';
        enq1.Parent_First_Name__c ='test_parent';
        enq1.Parent_Last_Name__c= con.LastName;
        enq1.Email__c=con.Email;
        enq1.Mobile_No__c =con.MobilePhone;
        enq1.School_Institution__c=con.AccountId;
        enq1.Address__c ='test_address';
        enq1.City__c='test_city';
        enq1.State__c='test_state';
        enq1.Pin_Code__c='125479';
        enq1.Source_of_Information__c = 'test_source';
        enq1.Stages__c='Application submitted';
        enq1.Application_Received__c=true;
        enq1.Application_Sent__c=false;
        enq1.School_Tour_Scheduled__c=false;
        enq1.School_Tour_Re_Scheduled__c=false;
        enq1.Interaction_Done__c=true;
        insert enq1;
        enqlist.add(enq.Id);
        enqlist.add(enq1.Id);
        
              
        test.startTest();  
        send_ApplicationFormLink_MassEmail.SendEmailNotification(enqlist);
        test.stopTest();
    }
}