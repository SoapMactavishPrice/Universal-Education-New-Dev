@isTest
public class emailNotificationTest {
    
    // Mock class to handle web service callouts during test
    private class EmailNotificationHttpMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success","message":"mocked"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    public static void testEmail() {
        // Set mock for HTTP callout
        Test.setMock(HttpCalloutMock.class, new EmailNotificationHttpMock());

        // Create Lead (required due to validation rule)
        Lead testLead = new Lead(
            LastName = 'Test Lead',
            Company  = 'Test Company',
            Status   = 'Open - Not Contacted'
        );
        insert testLead;

        // Create Application_Form__c record
        Application_Form__c af = new Application_Form__c(
            Name              = 'Test Form',
            Enquiry_Number__c = 'ENQ-001',
            Email_Address__c  = 'test@email.com',
            Lead__c           = testLead.Id
        );
        insert af;

        Test.startTest();
        // Call the email notification method
        emailNotification_onApplicationSubmit.sendMail(af);
        Test.stopTest();

    }
}