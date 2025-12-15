@isTest
public class enqScheduleCampusVisitLWC_Test {
    
    // Test method for getEnquiryName method
    @isTest
    public static void testGetEnquiryName() {
        // Create a test enquiry record
        Lead testLead = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert testLead;
        Account school = new Account(Name = 'Test School');
        insert school;
        Contact contact = new Contact(LastName = 'Test Contact', AccountId = school.Id, Lead__c = testLead.Id);
        insert contact;
        
       Enquiry__c enquiry = new Enquiry__c(Name = 'Test Enquiry', Contact__c = contact.Id, Lead__c = testLead.Id);
        insert enquiry;
        
        // Call the method
        Test.startTest();
        Map<String, Object> result = enqScheduleCampusVisitLWC.getEnquiryName(enquiry.Id);
        Test.stopTest();
        
       
    }
    
    // Test method for re_schgetEnquiryName method
    @isTest
    public static void testReSchGetEnquiryName() {
        // Create a test enquiry record
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            Username = 'testuapodfsdsad32ser@example.com',
            LastName = 'Test',
            Email = 'testuser@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        
      Lead testLead = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert testLead;
        Account school = new Account(Name = 'Test School');
        insert school;
        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = school.Id, Lead__c = testLead.Id);
        insert testContact;
        Enquiry__c enquiry = new Enquiry__c(Name = 'Test Enquiry', Contact__c = testContact.Id, Lead__c = testLead.Id);
        insert enquiry;
        // Call the method
        Test.startTest();
        Map<String, Object> result = enqScheduleCampusVisitLWC.re_schgetEnquiryName(enquiry.Id);
        Test.stopTest();
        
       
    }
    
    // Test method for getSubjectPicklistValues method
    @isTest
    public static void testGetSubjectPicklistValues() {
        // Call the method
        Test.startTest();
        List<String> result = enqScheduleCampusVisitLWC.getSubjectPicklistValues();
        Test.stopTest();
        
        // Validate that the result is not empty
        System.assertNotEquals(result, null, 'Result should not be null');
        System.assert(result.size() > 0, 'There should be at least one picklist value');
    }
    
    // Test method for getLeadUser method
    @isTest
    public static void testGetLeadUser() {
        // Create test data
        Account school = new Account(Name = 'Test School');
        insert school;
        LeadUser__c leadUser = new LeadUser__c(Name = 'Test User', SchoolCode__c = 'TSC');
        insert leadUser;
        
        // Call the method
        Test.startTest();
        List<User> result = enqScheduleCampusVisitLWC.getLeadUser('TSC');
        Test.stopTest();
        
       
    }
    
    // Test method for createEvent method
    @isTest
    public static void testCreateEvent() {
        // Create test data
        Lead testLead = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert testLead;
        Account school = new Account(Name = 'Test School');
        insert school;
        Contact contact = new Contact(LastName = 'Test Contact', AccountId = school.Id, Lead__c = testLead.Id);
        insert contact;
        
        Enquiry__c enquiry = new Enquiry__c(Name = 'Test Enquiry', Contact__c = contact.Id, Lead__c = testLead.Id);
        insert enquiry;
        
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User owner = new User(
            Username = 'tesjsf32ser@example.com',
            LastName = 'Test',
            Email = 'testuser@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert owner;
        
        // Call the method
        Test.startTest();
        String result = enqScheduleCampusVisitLWC.createEvent('Campus Visit', System.now(), System.now().addHours(1), 'Test Description', owner.Id, enquiry.Id, school.Id, false);
        Test.stopTest();
        
        // Validate the results
        System.assertEquals(result, 'Event created successfully!', 'Event creation should be successful');
        
        // Verify if the Enquiry record was updated correctly
        Enquiry__c updatedEnquiry = [SELECT Name, School_Tour_Scheduled__c, Log_Status__c FROM Enquiry__c WHERE Id = :enquiry.Id LIMIT 1];
        System.assertEquals(updatedEnquiry.School_Tour_Scheduled__c, true, 'School Tour Scheduled should be true');
        System.assertEquals(updatedEnquiry.Log_Status__c, 'Capmus Visit Scheduled', 'Log Status should match');
    }
    
    // Test method for re_schedulecreateEvent method
    @isTest
    public static void testReScheduleCreateEvent() {
        // Create test data
        Lead testLead = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert testLead;
        Account school = new Account(Name = 'Test School');
        insert school;
        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = school.Id, Lead__c = testLead.Id);
        insert testContact;
        Enquiry__c enquiry = new Enquiry__c(Name = 'Test Enquiry', Contact__c = testContact.Id, Lead__c = testLead.Id);
        insert enquiry;
        
         Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User owner = new User(
            Username = 'txhdwufgd32ser@example.com',
            LastName = 'Test',
            Email = 'testuser@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert owner;
        
        // Call the method
        Test.startTest();
        String result = enqScheduleCampusVisitLWC.re_schedulecreateEvent('Re-Scheduled Campus Visit', System.now(), System.now().addHours(1), 'Test Description', owner.Id, enquiry.Id, school.Id, true, false);
        Test.stopTest();
        
        // Validate the results
        System.assertEquals(result, 'Event created successfully!', 'Event creation should be successful');
        
        // Verify if the Enquiry record was updated correctly
        Enquiry__c updatedEnquiry = [SELECT Name, School_Tour_Re_Scheduled__c, Log_Status__c FROM Enquiry__c WHERE Id = :enquiry.Id LIMIT 1];
        System.assertEquals(updatedEnquiry.School_Tour_Re_Scheduled__c, true, 'School Tour Re-Scheduled should be true');
        System.assertEquals(updatedEnquiry.Log_Status__c, 'Capmus Visit Scheduled', 'Log Status should match');
    }
}