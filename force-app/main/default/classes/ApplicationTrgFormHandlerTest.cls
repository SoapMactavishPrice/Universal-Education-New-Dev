@isTest
public class ApplicationTrgFormHandlerTest {
    
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
    static void testSyncLeadFieldsFromApplicationForm_Insert() {
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Lead lead = new Lead(
            FirstName = 'Test',
            LastName = 'User',
            Company = 'Test Company',
            Status = 'Open - Not Contacted'
        );
        insert lead;

        Application_Form__c appForm = new Application_Form__c(
            Lead__c = lead.Id,
            Single_Parent__c = true,
            Father_First_Name__c = 'John',
            Father_Last_Name__c = 'Doe',
            Father_Phone__c = '11111111145',
            Father_Email_Id__c = 'john567721@example.com',
            Father_Name_of_Organisation__c = 'Org1',
            Father_Designation__c = 'Manager',
            Mother_First_Name__c = 'Jane',
            Mother_Last_Name__c = 'Doe',
            Mother_Phone__c = '2222222298',
            Mother_Email_Id__c = 'jane825631@example.com',
            Mother_Name_of_Organisation__c = 'Org2',
            Mother_Designation__c = 'Director'
        );
        insert appForm;
    }

    @isTest
    static void testSyncLeadFieldsFromApplicationForm_Update() {
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Lead lead = new Lead(
            FirstName = 'Update',
            LastName = 'Test',
            Company = 'Update Co',
            Status = 'Open - Not Contacted'
        );
        insert lead;

        Application_Form__c appForm = new Application_Form__c(Lead__c = lead.Id);
        insert appForm;

        appForm.Single_Parent__c = false;
        appForm.Father_First_Name__c = 'UpdatedJohn';
        appForm.Father_Last_Name__c = 'UpdatedDoe';
        appForm.Father_Phone__c = '3333333333';
        appForm.Father_Email_Id__c = 'updatedjohn824576@example.com';
        appForm.Father_Name_of_Organisation__c = 'UpdatedOrg1';
        appForm.Father_Designation__c = 'UpdatedManager';
        appForm.Mother_First_Name__c = 'UpdatedJane';
        appForm.Mother_Last_Name__c = 'UpdatedDoe';
        appForm.Mother_Phone__c = '4444444444';
        appForm.Mother_Email_Id__c = 'updatedjane230987@example.com';
        appForm.Mother_Name_of_Organisation__c = 'UpdatedOrg2';	
        appForm.Mother_Designation__c = 'UpdatedDirector';
        update appForm;
    }

    @isTest
    static void testSyncEnquiryFieldsFromApplicationForm_Insert() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Lead lead = new Lead(
            FirstName = 'Test',
            LastName = 'User',
            Company = 'Test Company',
            Status = 'Open - Not Contacted'
        );
        insert lead;

        // Create test Enquiry record
        Enquiry__c enquiry = new Enquiry__c(
            Name = 'Test Enquiry',
            Lead__c = lead.Id 
        );
        insert enquiry;


        // Create and insert Application Form with Enquiry reference
        Application_Form__c appForm = new Application_Form__c(
            Lead__c = lead.Id,
            Enquiry__c = enquiry.Id,
            Single_Parent__c = true,
            Father_First_Name__c = 'John',
            Father_Last_Name__c = 'Doe',
            Father_Phone__c = '11111111145',
            Father_Email_Id__c = 'john567721@example.com',
            Father_Name_of_Organisation__c = 'Org1',
            Father_Designation__c = 'Manager',
            Mother_First_Name__c = 'Jane',
            Mother_Last_Name__c = 'Doe',
            Mother_Phone__c = '2222222298',
            Mother_Email_Id__c = 'jane825631@example.com',
            Mother_Name_of_Organisation__c = 'Org2',
            Mother_Designation__c = 'Director'
        );
        insert appForm;
    }

    @isTest
    static void testSyncEnquiryFieldsFromApplicationForm_Update() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Lead lead = new Lead(
            FirstName = 'Test',
            LastName = 'User',
            Company = 'Test Company',
            Status = 'Open - Not Contacted'
        );
        insert lead;

        // Create test Enquiry record
        Enquiry__c enquiry = new Enquiry__c(
            Name = 'Test Enquiry',
            Lead__c = lead.Id 
        );
        insert enquiry;

        // Create and insert Application Form with minimal data
        Application_Form__c appForm = new Application_Form__c(
            Enquiry__c = enquiry.Id,
            Lead__c = lead.Id
        );
        insert appForm;

        // Update Application Form with new data
        appForm.Single_Parent__c = false;
        appForm.Father_First_Name__c = 'UpdatedJohn';
        appForm.Father_Last_Name__c = 'UpdatedDoe';
        appForm.Father_Phone__c = '3333333333';
        appForm.Father_Email_Id__c = 'updatedjohn824576@example.com';
        appForm.Father_Name_of_Organisation__c = 'UpdatedOrg1';
        appForm.Father_Designation__c = 'UpdatedManager';
        appForm.Mother_First_Name__c = 'UpdatedJane';
        appForm.Mother_Last_Name__c = 'UpdatedDoe';
        appForm.Mother_Phone__c = '4444444444';
        appForm.Mother_Email_Id__c = 'updatedjane230987@example.com';
        appForm.Mother_Name_of_Organisation__c = 'UpdatedOrg2';
        appForm.Mother_Designation__c = 'UpdatedDirector';
        update appForm;
    }
}