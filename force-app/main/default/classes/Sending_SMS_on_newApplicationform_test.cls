@isTest
public class Sending_SMS_on_newApplicationform_test {
    
    
    class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    public static testmethod void applicationtrigger(){
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Lead lead = new Lead();
            lead.FirstName = 'Test';
            lead.LastName = 'User';
            lead.Company = 'Test Company';
            lead.Status = 'Open - Not Contacted';
       
        insert lead;
        
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c='UHSC';
        insert acc;
        
        Contact con = new Contact();
        con.Lead__c = lead.id;
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        insert con;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Lead__c = lead.id;
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
        enq.Application_Sent__c=true;
        enq.School_Institution__c=con.AccountId;
        enq.orgCode__c = 'EISB';
       
        insert enq;
        
        Application_Form__c ap=new Application_Form__c();
        ap.Lead__c = lead.Id;
        ap.Mobile_Number__c='2154789630';
        ap.Enquiry__c = enq.id;
        ap.School_Institution__c = enq.School_Institution__c;
        ap.Email_Address__c = enq.Email__c;
        ap.SchoolShort_Code__c = 'EISB';
        insert ap;
        
        
        smsgupshupTemplate__c st1=new smsgupshupTemplate__c();
        st1.Description__c='xyz';
        st1.Name__c='confirm_Application';
        insert st1;
            
        ap.Mobile_Number__c='8844687782';
        update ap;    
        
       
        EnquirySendSmSCallout.sendgupshupsms('success', '8197318304', '2000045203', 'universalgoogle');
        EnquirySendSmSCallout.sendsms();
        UE_SendApplicationFormPDF.sendPDF(ap.id);
        
        
    }

}