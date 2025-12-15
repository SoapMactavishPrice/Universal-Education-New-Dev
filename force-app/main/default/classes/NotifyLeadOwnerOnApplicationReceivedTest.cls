@isTest
public class NotifyLeadOwnerOnApplicationReceivedTest {
    // Mock class for the HTTP callout
    private class MyHttpCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Mock response for the web service callout
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": "success"}');  // Sample response body
            res.setStatusCode(200);  // HTTP status code 200 for success
            return res;
        }
    }
    @isTest
    static void testApplicationFormNotification() {
        // Set up the mock for the web service callout
    Test.setMock(HttpCalloutMock.class, new MyHttpCalloutMock());
        // Step 1: Set up test data
        // Create a test user to act as the lead owner
        User leadOwner = new User(
            Username = 'testleadowner@example.com',
            LastName = 'LeadOwner',
            Email = 'testleadowner@example.com',
            Alias = 'tlo',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US'
        );
        insert leadOwner;
        
       Lead testLead = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert testLead;
        
         Account acc = new Account();
        acc.Name ='Testaccountname';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'TestFirstname';
        con.LastName ='TestLastname';
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.Lead__c= testLead.Id;
        con.Contact_Status__c = 'Qualified';
        con.Contact_Reasons__c = 'N/A';
        insert con;
        
        List<Enquiry__c> enqlist=new List<Enquiry__c>();
         Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        //enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='test_parent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='test_address';
        enq.City__c='testcity';
        enq.State__c='test_state';
        enq.Lead__c= testLead.Id;
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'test_source';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enqlist.add(enq);
   insert enqlist;
    
        Application_Form__c af1=new Application_Form__c();
        af1.Academic_Year__c='2019-20';
        af1.Address__c='address';
        af1.Lead__c= testLead.Id;
        af1.Adhaar_Card_No__c='768768765654';
        af1.Father_Annual_Income__c=10000;
        af1.Mother_Anual_Income__c=20000;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Birth_Place__c='kolkata';
        af1.Blood_Group__c='AB+ve';
        af1.Father_Business_Address__c='Father_Business_Address__c';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        af1.Father_Business_Contact__c='6767876543';
        af1.Mother_Business_Contact__c='9876787654';
        af1.Category__c='Gen';
        af1.Country__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@developer.com';
        af1.Enquiry__c=enqlist[0].Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        insert af1;
        
        // Step 2: Execute the trigger by updating Print_Copy_Submitted__c to true
        Test.startTest();
        af1.Print_Copy_Submitted__c = true;
        update af1;
        Test.stopTest();
        
        // Step 3: Verify the expected outcome
        // Check that the custom notification was sent
        // Note: Since actual sending of notifications is not performed in test context,
        // we would typically verify that the trigger logic executed without errors.
        // Additional assertions can be added if there are observable changes or outputs.
    }
}