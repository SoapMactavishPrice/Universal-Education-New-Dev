@isTest
global class VerifyDocumentsControllerTest {


    global class MockHttpResponseGenerator implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testGetDocumentDetailsAndSaveAndProceed() {
        Account school = new Account(Name='Test School');
        insert school;

        Lead lead = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Company = 'Test Company',
            School_Institution__c = school.Id
        );
        insert lead;

        Enquiry__c enquiry = new Enquiry__c(
            Date_of_Birth__c = Date.newInstance(2010,1,1),
            Name = 'John Doe',
            Gender__c = 'Male',
            Email__c = 'johndoe@gmail.com',
            Enq_School_Institute__c = school.Id,
            Grade__c = 'Grade 10',
            School_Institution__c = school.Id,
            Lead__c = lead.Id
        );
        insert enquiry;

        Application_Form__c appForm = new Application_Form__c(
            Academic_Year__c = '2025-2026',
            Student_Name__c = 'John Doe',
            Enquiry__c = enquiry.Id,
            School_Institution__c = school.Id,
            Lead__c = lead.Id
        );
        insert appForm;

        List<Document_Detail__c> docDetails = new List<Document_Detail__c>{
            new Document_Detail__c(Name = 'Father\'s signature', Mandatory__c = true, Submission_Status__c = 'Accepted', Application_Form__c = appForm.Id),
            new Document_Detail__c(Name = 'Mother\'s signature', Mandatory__c = true, Submission_Status__c = 'Not Submitted', Application_Form__c = appForm.Id),
            new Document_Detail__c(Name = 'Student\'s photo', Mandatory__c = false, Submission_Status__c = null, Application_Form__c = appForm.Id)
        };
        insert docDetails;

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();

        List<VerifyDocumentsController.DocumentDetailWrapper> wrappers = VerifyDocumentsController.getDocumentDetails(appForm.Id);

        for (VerifyDocumentsController.DocumentDetailWrapper wrap : wrappers) {
            if (wrap.submissionStatus == 'Accepted') wrap.submissionStatus = 'Accepted';
            else if (wrap.submissionStatus == 'Not Submitted') wrap.submissionStatus = 'Accepted';
            else wrap.submissionStatus = 'Accepted';
        }

        String saveResult = VerifyDocumentsController.saveAndProceed(wrappers, appForm.Id);

        List<VerifyDocumentsController.DocumentDetailWrapper> emptyList = new List<VerifyDocumentsController.DocumentDetailWrapper>();
        String emptyResult = VerifyDocumentsController.saveAndProceed(emptyList, appForm.Id);

        Test.stopTest();
    }
}