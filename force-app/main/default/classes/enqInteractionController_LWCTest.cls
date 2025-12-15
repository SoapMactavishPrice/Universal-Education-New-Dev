@isTest
public class enqInteractionController_LWCTest {
    
    @testSetup
    static void setup() {
        // Create test data for Enquiry__c
        Lead testLead = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert testLead;
        
        Account testSchool = new Account(Name = 'Test School');
        insert testSchool;
        
        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = testSchool.Id, Lead__c = testLead.Id);
        insert testContact;
        
        Enquiry__c testEnquiry = new Enquiry__c(Name = 'Test Enquiry', Contact__c = testContact.Id, Lead__c = testLead.Id);
        insert testEnquiry;
    }
    
    @isTest
    static void testGetEnquiryName() {
        // Retrieve the test Enquiry__c record
        Enquiry__c testEnquiry = [SELECT Id FROM Enquiry__c LIMIT 1];
        
        String schoolShortCode = 'TESTCODE';
        
        // Call the method and get the result
        Map<String, Object> result = enqInteractionController_LWC.getEnquiryName(testEnquiry.Id);
        Map<String, Object> result1 = enqInteractionController_LWC.re_schgetEnquiryName(testEnquiry.Id);
        List<String> result2 = enqInteractionController_LWC.getSubjectPicklistValues();
        List<User> result3 = enqInteractionController_LWC.getLeadUser(schoolShortCode);
    }
    
    @isTest
    static void testCreateEvent() {
        
        // Call the method and get the result
        // String result = enqInteractionController_LWC.calledForInteraction(
        //     testEnquiry.Id,
        //     'Test Event',
        //     DateTime.now(),
        //     DateTime.now().addHours(1),
        //     testUser.Id
        // );

        enqInteractionController_LWC.testMethod1();
        
        // String result2 = enqInteractionController_LWC.interactionOnlineRescheduled(
        //     testEnquiry.Id,
        //     'Test Event',
        //     DateTime.now(),
        //     DateTime.now().addHours(1),
        //     testUser.Id
        // );
        
    }
    
    
}