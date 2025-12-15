@isTest
public class enqMeetOnlineLWC_Test {

    @isTest
    public static void testGetEnquiryName() {
        // Create test data
       Lead testLead = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert testLead;
        Account school = new Account(Name = 'Test School');
        insert school;
        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = school.Id, Lead__c = testLead.Id);
        insert testContact;
        Enquiry__c enquiry = new Enquiry__c(Name = 'Test Enquiry', Contact__c = testContact.Id, Lead__c = testLead.Id);
        insert enquiry;

        Test.startTest();

        // Call the method
        Map<String, Object> result = enqMeetOnlineLWC.getEnquiryName(enquiry.Id);

        Test.stopTest();

       
    }

    @isTest
    public static void testReSchGetEnquiryName() {
        // Create test data
       Lead testLead = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert testLead;
        Account school = new Account(Name = 'Test School');
        insert school;
        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = school.Id, Lead__c = testLead.Id);
        insert testContact;
        Enquiry__c enquiry = new Enquiry__c(Name = 'Test Enquiry', Contact__c = testContact.Id, Lead__c = testLead.Id);
        insert enquiry;
        
        Test.startTest();

        // Call the method
        Map<String, Object> result = enqMeetOnlineLWC.re_schgetEnquiryName(enquiry.Id);

        Test.stopTest();

      
    }

    @isTest
    public static void testGetSubjectPicklistValues() {
        Test.startTest();

        // Call the method
        List<String> picklistValues = enqMeetOnlineLWC.getSubjectPicklistValues();

        Test.stopTest();

       
    }

    @isTest
    public static void testGetLeadUser() {
        // Create test data
        LeadUser__c leadUser = new LeadUser__c(SchoolCode__c = '12345', Name = 'Test Lead User');
        insert leadUser;

        Test.startTest();

        // Call the method
        List<User> result = enqMeetOnlineLWC.getLeadUser('12345');

        Test.stopTest();

    }

    @isTest
    public static void testCreateEvent() {
        // Create test data
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            Username = 'testuasdbafjkbaklsad32ser@example.com',
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

        Test.startTest();

        // Call the method
        String result = enqMeetOnlineLWC.createEvent(
            'Test Event', 
            System.now().addHours(1), 
            System.now().addHours(2), 
            'Test Description', 
            testUser.Id, 
            enquiry.Id, 
            school.Id, 
            false
        );

        Test.stopTest();

        // Verify the event is created
        Event createdEvent = [SELECT Subject, StartDateTime, EndDateTime FROM Event WHERE WhatId = :enquiry.Id LIMIT 1];
      
    }

    @isTest
    public static void testReScheduleCreateEvent() {
        // Create test data
       Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            Username = 'testud32ser927@example.com',
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
        Test.startTest();

        // Call the method
        String result = enqMeetOnlineLWC.re_schedulecreateEvent(
            'Test Rescheduled Event', 
            System.now().addHours(1), 
            System.now().addHours(2), 
            'Test Description', 
            testUser.Id, 
            enquiry.Id, 
            school.Id, 
            true, 
            false
        );

        Test.stopTest();

        // Verify the event is created
        Event createdEvent = [SELECT Subject, StartDateTime, EndDateTime FROM Event WHERE WhatId = :enquiry.Id LIMIT 1];
      
    }
}