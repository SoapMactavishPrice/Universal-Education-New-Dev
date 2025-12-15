@isTest
public class CalledForInteractionOnlineContro_LWCTest {
    
    @isTest
    static void testGetContactName() {
        // Create test data
        // 
        Lead testLead = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert testLead;
        
        Account testSchool = new Account(Name = 'Test School');
        insert testSchool;
        
        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = testSchool.Id, Lead__c = testLead.Id);
        insert testContact;
        
        Enquiry__c testEnquiry = new Enquiry__c(Name = 'Test Enquiry', Contact__c = testContact.Id, Lead__c = testLead.Id);
        insert testEnquiry;
        
        
        
        Admission_Form__c testAdmissionForm = new Admission_Form__c(
            Name = 'Test Admission Form',
            Enquiry_No__c = testEnquiry.Id,
            Lead__c = testLead.Id,
            //Account = testSchool.Id,
            Interaction_Scheduled__c = true,
            Interaction_Rescheduled__c = true
        );
        insert testAdmissionForm;
        
        // Call the method
        Test.startTest();
        Map<String, Object> result = CalledForInteractionOnlineController_LWC.getContactName(testAdmissionForm.Id);
        Map<String, Object> result1 = CalledForInteractionOnlineController_LWC.re_sch_getContactName(testAdmissionForm.Id);
        Map<String, Object> result2 = CalledForInteractionOnlineController_LWC.getOnlineContactName(testAdmissionForm.Id);
        Map<String, Object> result3 = CalledForInteractionOnlineController_LWC.re_sch_oline_getContactName(testAdmissionForm.Id);
        List<String> result4 = CalledForInteractionOnlineController_LWC.getSubjectPicklistValues();
        Test.stopTest();
        
    }
    
    @isTest
    static void testGetLeadUser() {
        // Create test data
        String schoolShortCode = 'TESTCODE';
        
        // Create LeadUser__c records
        LeadUser__c leadUser1 = new LeadUser__c(Name = 'Test Lead User 1', SchoolCode__c = schoolShortCode);
        LeadUser__c leadUser2 = new LeadUser__c(Name = 'Test Lead User 2', SchoolCode__c = schoolShortCode);
        insert leadUser1;
        insert leadUser2;
        
        // Create User records
        User testUser1 = new User(
            Username = 'testuserdwed31@example.com',
            LastName = 'Test',
            Email = 'testuser1@example.com',
            Alias = 'tuser1',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US'
            //Name = 'Test Lead User 1'
        );
        User testUser2 = new User(
            Username = 'testuserdedwedds2@example.com',
            LastName = 'Test',
            Email = 'testuser2@example.com',
            Alias = 'tuser2',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US'
            //Name = 'Test Lead User 2'
        );
        insert testUser1;
        insert testUser2;
        
        // Call the method
        Test.startTest();
        List<User> result = CalledForInteractionOnlineController_LWC.getLeadUser(schoolShortCode);
        Test.stopTest();
        
        // Verify the results
        Set<String> resultUserNames = new Set<String>();
        for (User user : result) {
            resultUserNames.add(user.Name);
        }
    }
    
    @isTest
    static void testCreateEvent() {
        CalledForInteractionOnlineController_LWC.testMethod1();
    }

}