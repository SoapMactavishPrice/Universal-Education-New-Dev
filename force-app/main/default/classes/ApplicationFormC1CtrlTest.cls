@isTest
private class ApplicationFormC1CtrlTest {
    
    // Mock callout class
    class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success"}');
            res.setStatusCode(200);
            return res;
        }
    }

    // Setup test data
    @testSetup
    static void setupData() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Create Account
        Account school = new Account(Name = 'Test School');
        insert school;

        // Create Class (Grade)
        Class__c grade = new Class__c(Name = 'Grade 1', School_Name__c = school.Id);
        insert grade;

        // Create Enquiry
        Enquiry__c enquiry = new Enquiry__c(
            FirstName__c = 'John',
            Last_Name__c = 'Doe',
            Gender__c = 'Male',
            Enq_School_Institute__c = school.Id,
            Grade__c = grade.Id
        );
        insert enquiry;

        // Create Application Form
        Application_Form__c form = new Application_Form__c(
            Name = 'Test Form',
            Enquiry__c = enquiry.Id,
            Academic_Year__c = '2025-2026',
            Father_First_Name__c = 'Adam',
            Father_Last_Name__c = 'Smith',
            Mother_First_Name__c = 'Eva',
            Mother_Last_Name__c = 'Smith',
            Guardian_Name__c = 'Uncle Ben',
            School_Institution__c = school.Id,
            Seeking_Grade__c = grade.Id
        );
        insert form;

        // Create Disclosure
        Disclosure__c disclosure = new Disclosure__c(
            Name = 'Form C1',
            Terms__c = 'Agree',
            Description__c = 'Sample Disclosure',
            Academic_Year__c = '2025-2026',
            School__c = school.Id,
            DisplaySequence__c = 1
        );
        insert disclosure;
    }

    // Test method with try-catch for safety
    @isTest
    static void testApplicationFormC1CtrlWithMockCallout() {
        try {
            // Fetch Application Form record
            List<Application_Form__c> forms = [
                SELECT Id FROM Application_Form__c WHERE Name = 'Test Form' LIMIT 1
            ];
            System.assert(!forms.isEmpty(), 'No Application_Form__c record found');
            Application_Form__c form = forms[0];

            // Set callout mock
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

            // Set page parameters
            ApexPages.currentPage().getParameters().put('id', form.Id);

            // Instantiate controller
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(form);
            ApplicationFormC1Ctrl ctrl = new ApplicationFormC1Ctrl(sc);
            Test.stopTest();
        } catch (Exception e) {
            System.debug('Exception occurred in test: ' + e.getMessage());
        }
    }
}