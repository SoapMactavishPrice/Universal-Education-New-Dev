@isTest
public class AutomateSMSTest {

    class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    static void automate() {
        
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Generate a unique but short school code (max 10 chars)
        String timestamp = String.valueOf(Datetime.now().getTime());
        String uniqueSchoolCode = 'UHT' + timestamp.right(6); // e.g., UHT123456 (9 chars total)

        // Create Account with valid short code
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.School_Short_Code__c = uniqueSchoolCode;
        insert acc;

        // Create Contact
        Contact con = new Contact();
        con.LastName = 'Test Contact';
        con.AccountId = acc.Id;
        insert con;

        // Create Enquiry__c
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c = con.Id;
        enq.Stages__c = 'Enquiry';
        enq.Mobile_No__c = '9617904978';
        enq.FirstName__c = 'TestFirstName';
        enq.Last_Name__c = 'TestLastName';
        enq.orgCode__c = uniqueSchoolCode;
        enq.Log_Status__c = 'New Enquiry';
        enq.Email__c = 'test@example.com';
        insert enq;

        // Create SMS Template
        smsgupshupTemplate__c gup = new smsgupshupTemplate__c();
        gup.Name__c = 'School Add (' + uniqueSchoolCode + ')';
        gup.Description__c = 'Test Description';
        insert gup;

        Test.startTest();
        // Add logic here if your AutomateSMS class has callable methods
        Test.stopTest();
    }
}