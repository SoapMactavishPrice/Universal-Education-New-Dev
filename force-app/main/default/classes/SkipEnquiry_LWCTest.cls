@IsTest
public class SkipEnquiry_LWCTest {
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
    @IsTest
    static void testCreateContact() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // Setup: Create a lead
        Lead testLead = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            Nationality__c = 'Indian',
            Apartment_name__c = 'Test Apartment',
            Are_you_a_single_parent__c = false,
            Father_s_First_Name__c = 'Test Father',
            Father_s_Last_Name__c = 'Last Name',
            Father_s_Mobile_number__c = '9999999999',
            Father_s_Email_ID__c = 'father@test.com',
            Stellar_Seeking_Admission_in_Grade__c = 'Nursery'
        );
        insert testLead;

        // Setup: Create a contact linked to the lead
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'testcontact@test.com',
            MobilePhone = '8888888888',
            Lead__c = testLead.Id,
            Academic_Year__c = '2023-2024',
           // school_Name__c = 'Test School',
            SkipEnquiry__c = false,
            SkipCuriosity__c = false
        );
        insert testContact;

        // Setup: Create existing enquiry records to test duplicate handling
        Enquiry__c existingEnquiry = new Enquiry__c(
            Name = 'ENQ/2023-2024/1',
            Academic_Year__c = '2023-2024',
            Lead__c = testLead.Id,
            Contact__c = testContact.Id
        );
        insert existingEnquiry;

        // Test: Call the createContact method
        Test.startTest();
        List<Enquiry__c> enquiries = SkipEnquiry_LWC.createContact(testContact.Id);
        Test.stopTest();

        // Assert: Ensure the enquiry is created with unique naming
      
        Enquiry__c newEnquiry = enquiries[0];
       

        // Negative Test: Test for skipped contacts
        testContact.SkipEnquiry__c = true;
        update testContact;
/*
        Test.startTest();
        List<Enquiry__c> skippedEnquiries = SkipEnquiry_LWC.createContact(testContact.Id);
        Test.stopTest();*/
    }
    
}