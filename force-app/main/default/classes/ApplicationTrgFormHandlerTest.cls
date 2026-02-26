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

    @TestSetup
    static void setupTestData() {
        Lead lead = new Lead(
            FirstName = 'Test',
            LastName  = 'User',
            Company   = 'Test Company',
            Status    = 'Open - Not Contacted'
        );
        insert lead;

        Enquiry__c enquiry = new Enquiry__c(
            Name    = 'Test Enquiry',
            Lead__c = lead.Id
        );
        insert enquiry;
    }

    // ─── Lead sync ────────────────────────────────────────────────────────────

    @isTest
    static void testSyncLeadFieldsFromApplicationForm_Insert() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Lead lead = [SELECT Id FROM Lead LIMIT 1];

        Test.startTest();
        Application_Form__c appForm = new Application_Form__c(
            Lead__c                      = lead.Id,
            Single_Parent__c             = true,
            Father_First_Name__c         = 'John',
            Father_Last_Name__c          = 'Doe',
            Father_Phone__c              = '1111111111',
            Father_Email_Id__c           = 'john@example.com',
            Father_Name_of_Organisation__c = 'Org1',
            Father_Designation__c        = 'Manager',
            Mother_First_Name__c         = 'Jane',
            Mother_Last_Name__c          = 'Doe',
            Mother_Phone__c              = '2222222222',
            Mother_Email_Id__c           = 'jane@example.com',
            Mother_Name_of_Organisation__c = 'Org2',
            Mother_Designation__c        = 'Director'
        );
        insert appForm;
        Test.stopTest();

        Lead updatedLead = [
            SELECT Are_you_a_single_parent__c,
                   Father_s_First_Name__c, Father_s_Last_Name__c,
                   Father_s_Mobile_number__c, Father_s_Email_ID__c,
                   Name_of_the_organisation_father__c, Father_s_Designation__c,
                   Mother_s_First_Name__c, Mother_s_Last_Name__c,
                   Mother_s_Mobile_number__c, Mother_s_Email_ID__c,
                   Name_of_the_organisation_Mother__c, Mother_s_Designation__c
            FROM Lead
            WHERE Id = :lead.Id
        ];

        System.assertEquals(true,          updatedLead.Are_you_a_single_parent__c,        'Single parent mismatch');
        System.assertEquals('John',        updatedLead.Father_s_First_Name__c,            'Father first name mismatch');
        System.assertEquals('Doe',         updatedLead.Father_s_Last_Name__c,             'Father last name mismatch');
        System.assertEquals('1111111111',  updatedLead.Father_s_Mobile_number__c,         'Father phone mismatch');
        System.assertEquals('john@example.com', updatedLead.Father_s_Email_ID__c,         'Father email mismatch');
        System.assertEquals('Org1',        updatedLead.Name_of_the_organisation_father__c,'Father org mismatch');
        System.assertEquals('Manager',     updatedLead.Father_s_Designation__c,           'Father designation mismatch');
        System.assertEquals('Jane',        updatedLead.Mother_s_First_Name__c,            'Mother first name mismatch');
        System.assertEquals('Doe',         updatedLead.Mother_s_Last_Name__c,             'Mother last name mismatch');
        System.assertEquals('2222222222',  updatedLead.Mother_s_Mobile_number__c,         'Mother phone mismatch');
        System.assertEquals('jane@example.com', updatedLead.Mother_s_Email_ID__c,         'Mother email mismatch');
        System.assertEquals('Org2',        updatedLead.Name_of_the_organisation_Mother__c,'Mother org mismatch');
        System.assertEquals('Director',    updatedLead.Mother_s_Designation__c,           'Mother designation mismatch');
    }

    @isTest
    static void testSyncLeadFieldsFromApplicationForm_Update() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Lead lead = [SELECT Id FROM Lead LIMIT 1];

        Application_Form__c appForm = new Application_Form__c(Lead__c = lead.Id);
        insert appForm;

        Test.startTest();
        appForm.Single_Parent__c               = false;
        appForm.Father_First_Name__c           = 'UpdatedJohn';
        appForm.Father_Last_Name__c            = 'UpdatedDoe';
        appForm.Father_Phone__c                = '3333333333';
        appForm.Father_Email_Id__c             = 'updatedjohn@example.com';
        appForm.Father_Name_of_Organisation__c = 'UpdatedOrg1';
        appForm.Father_Designation__c          = 'UpdatedManager';
        appForm.Mother_First_Name__c           = 'UpdatedJane';
        appForm.Mother_Last_Name__c            = 'UpdatedDoe';
        appForm.Mother_Phone__c                = '4444444444';
        appForm.Mother_Email_Id__c             = 'updatedjane@example.com';
        appForm.Mother_Name_of_Organisation__c = 'UpdatedOrg2';
        appForm.Mother_Designation__c          = 'UpdatedDirector';
        update appForm;
        Test.stopTest();

        Lead updatedLead = [
            SELECT Are_you_a_single_parent__c,
                   Father_s_First_Name__c, Mother_s_First_Name__c
            FROM Lead
            WHERE Id = :lead.Id
        ];

        System.assertEquals(false,         updatedLead.Are_you_a_single_parent__c, 'Single parent mismatch');
        System.assertEquals('UpdatedJohn', updatedLead.Father_s_First_Name__c,     'Father first name mismatch');
        System.assertEquals('UpdatedJane', updatedLead.Mother_s_First_Name__c,     'Mother first name mismatch');
    }

    // ─── Enquiry sync ─────────────────────────────────────────────────────────

    @isTest
    static void testSyncEnquiryFieldsFromApplicationForm_Insert() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Lead      lead    = [SELECT Id FROM Lead LIMIT 1];
        Enquiry__c enquiry = [SELECT Id FROM Enquiry__c LIMIT 1];

        Test.startTest();
        Application_Form__c appForm = new Application_Form__c(
            Lead__c                        = lead.Id,
            Enquiry__c                     = enquiry.Id,
            Single_Parent__c               = true,
            Father_First_Name__c           = 'John',
            Father_Last_Name__c            = 'Doe',
            Father_Phone__c                = '1111111111',
            Father_Email_Id__c             = 'john@example.com',
            Father_Name_of_Organisation__c = 'Org1',
            Father_Designation__c          = 'Manager',
            Mother_First_Name__c           = 'Jane',
            Mother_Last_Name__c            = 'Doe',
            Mother_Phone__c                = '2222222222',
            Mother_Email_Id__c             = 'jane@example.com',
            Mother_Name_of_Organisation__c = 'Org2',
            Mother_Designation__c          = 'Director'
        );
        insert appForm;
        Test.stopTest();

        Enquiry__c updatedEnquiry = [
            SELECT Are_you_a_single_parent__c,
                   Father_s_First_Name__c, Father_s_Last_Name__c,
                   Father_s_Mobile_number__c, Father_s_Email_ID__c,
                   Name_of_the_organisation_father__c, Father_s_Designation__c,
                   Mother_s_First_Name__c, Mother_s_Last_Name__c,
                   Mother_s_Mobile_number__c, Mother_s_Email_ID__c,
                   Name_of_the_organisation_Mother__c, Mother_s_Designation__c
            FROM Enquiry__c
            WHERE Id = :enquiry.Id
        ];

        System.assertEquals(true,               updatedEnquiry.Are_you_a_single_parent__c,        'Single parent mismatch');
        System.assertEquals('John',             updatedEnquiry.Father_s_First_Name__c,            'Father first name mismatch');
        System.assertEquals('Doe',              updatedEnquiry.Father_s_Last_Name__c,             'Father last name mismatch');
        System.assertEquals('1111111111',       updatedEnquiry.Father_s_Mobile_number__c,         'Father phone mismatch');
        System.assertEquals('john@example.com', updatedEnquiry.Father_s_Email_ID__c,              'Father email mismatch');
        System.assertEquals('Org1',             updatedEnquiry.Name_of_the_organisation_father__c,'Father org mismatch');
        System.assertEquals('Manager',          updatedEnquiry.Father_s_Designation__c,           'Father designation mismatch');
        System.assertEquals('Jane',             updatedEnquiry.Mother_s_First_Name__c,            'Mother first name mismatch');
        System.assertEquals('Doe',              updatedEnquiry.Mother_s_Last_Name__c,             'Mother last name mismatch');
        System.assertEquals('2222222222',       updatedEnquiry.Mother_s_Mobile_number__c,         'Mother phone mismatch');
        System.assertEquals('jane@example.com', updatedEnquiry.Mother_s_Email_ID__c,              'Mother email mismatch');
        System.assertEquals('Org2',             updatedEnquiry.Name_of_the_organisation_Mother__c,'Mother org mismatch');
        System.assertEquals('Director',         updatedEnquiry.Mother_s_Designation__c,           'Mother designation mismatch');
    }

    @isTest
    static void testSyncEnquiryFieldsFromApplicationForm_Update() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Lead       lead    = [SELECT Id FROM Lead LIMIT 1];
        Enquiry__c enquiry = [SELECT Id FROM Enquiry__c LIMIT 1];

        Application_Form__c appForm = new Application_Form__c(
            Enquiry__c = enquiry.Id,
            Lead__c    = lead.Id
        );
        insert appForm;

        Test.startTest();
        appForm.Single_Parent__c               = false;
        appForm.Father_First_Name__c           = 'UpdatedJohn';
        appForm.Father_Last_Name__c            = 'UpdatedDoe';
        appForm.Father_Phone__c                = '3333333333';
        appForm.Father_Email_Id__c             = 'updatedjohn@example.com';
        appForm.Father_Name_of_Organisation__c = 'UpdatedOrg1';
        appForm.Father_Designation__c          = 'UpdatedManager';
        appForm.Mother_First_Name__c           = 'UpdatedJane';
        appForm.Mother_Last_Name__c            = 'UpdatedDoe';
        appForm.Mother_Phone__c                = '4444444444';
        appForm.Mother_Email_Id__c             = 'updatedjane@example.com';
        appForm.Mother_Name_of_Organisation__c = 'UpdatedOrg2';
        appForm.Mother_Designation__c          = 'UpdatedDirector';
        update appForm;
        Test.stopTest();

        Enquiry__c updatedEnquiry = [
            SELECT Are_you_a_single_parent__c,
                   Father_s_First_Name__c, Mother_s_First_Name__c
            FROM Enquiry__c
            WHERE Id = :enquiry.Id
        ];

        System.assertEquals(false,         updatedEnquiry.Are_you_a_single_parent__c, 'Single parent mismatch');
        System.assertEquals('UpdatedJohn', updatedEnquiry.Father_s_First_Name__c,     'Father first name mismatch');
        System.assertEquals('UpdatedJane', updatedEnquiry.Mother_s_First_Name__c,     'Mother first name mismatch');
    }

    // ─── Owner sync ───────────────────────────────────────────────────────────

    @isTest
    static void testUpdateApplicationFormOwnerWithLeadOwner() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Lead       lead    = [SELECT Id, OwnerId FROM Lead LIMIT 1];
        Enquiry__c enquiry = [SELECT Id FROM Enquiry__c LIMIT 1];

        Test.startTest();
        Application_Form__c appForm = new Application_Form__c(
            Lead__c    = lead.Id,
            Enquiry__c = enquiry.Id
        );
        insert appForm;
        Test.stopTest();

        Application_Form__c updatedForm = [
            SELECT OwnerId FROM Application_Form__c WHERE Id = :appForm.Id
        ];

        System.assertEquals(
            lead.OwnerId,
            updatedForm.OwnerId,
            'Application Form OwnerId should match Lead OwnerId'
        );
    }
}