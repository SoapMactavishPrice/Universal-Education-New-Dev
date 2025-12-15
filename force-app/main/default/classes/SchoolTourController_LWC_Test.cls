@isTest
public class SchoolTourController_LWC_Test {

    @testSetup
    static void setupTestData() {
        // Create test data for Enquiry__c
         Account testSchool = new Account(Name = 'Test School');
        insert testSchool;
        
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'Open',
            School_Institution__c = testSchool.Id,
            Current_Location__c = 'Test Location'
        );
        insert testLead;
        
        
        
        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = testSchool.Id, Lead__c = testLead.Id);
        insert testContact;

        Enquiry__c testEnquiry = new Enquiry__c(Name = 'Test Enquiry', Contact__c = testContact.Id, Lead__c = testLead.Id);
        insert testEnquiry;
        

        // Create test data for LeadUser__c
        LeadUser__c leadUser = new LeadUser__c(
            Name = 'Test Lead User',
            SchoolCode__c = 'TSC'
        );
        insert leadUser;

        // Create a User for owner reference
       Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        User testUser = new User(
            Username = 'dumsofijaio@example.com',
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
        
    }

    @isTest
    static void testGetEnquiryName() {
        Account testSchool = new Account(Name = 'Test School');
        insert testSchool;
        
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'Open',
            School_Institution__c = testSchool.Id,
            Current_Location__c = 'Test Location'
        );
        insert testLead;
        
        
        
        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = testSchool.Id, Lead__c = testLead.Id);
        insert testContact;

        Enquiry__c testEnquiry = new Enquiry__c(Name = 'Test Enquiry', Contact__c = testContact.Id, Lead__c = testLead.Id);
        insert testEnquiry;
        
        Map<String, Object> result = SchoolTourController_LWC.getEnquiryName(testEnquiry.Id);


    }

    @isTest
    static void testReSchGetEnquiryName() {
       Account testSchool = new Account(Name = 'Test School');
        insert testSchool;
        
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'Open',
            School_Institution__c = testSchool.Id,
            Current_Location__c = 'Test Location'
        );
        insert testLead;
        
        
        
        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = testSchool.Id, Lead__c = testLead.Id);
        insert testContact;

        Enquiry__c testEnquiry = new Enquiry__c(Name = 'Test Enquiry', Contact__c = testContact.Id, Lead__c = testLead.Id);
        insert testEnquiry;
    
        Map<String, Object> result = SchoolTourController_LWC.re_schgetEnquiryName(testEnquiry.Id);
    }

    @isTest
    static void testGetSubjectPicklistValues() {
        List<String> picklistValues = SchoolTourController_LWC.getSubjectPicklistValues();
      
    }

    @isTest
    static void testGetLeadUser() {
        List<User> leadUsers = SchoolTourController_LWC.getLeadUser('TSC');
       
    }

    @isTest
    static void testCreateEvent() {
        Account testSchool = new Account(Name = 'Test School');
        insert testSchool;
        
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'Open',
            School_Institution__c = testSchool.Id,
            Current_Location__c = 'Test Location'
        );
        insert testLead;
        
        
        
        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = testSchool.Id, Lead__c = testLead.Id);
        insert testContact;

        Enquiry__c testEnquiry = new Enquiry__c(Name = 'Test Enquiry', Contact__c = testContact.Id, Lead__c = testLead.Id);
        insert testEnquiry;
        

        // Create test data for LeadUser__c
        LeadUser__c leadUser = new LeadUser__c(
            Name = 'Test Lead User',
            SchoolCode__c = 'TSC'
        );
        insert leadUser;

        // Create a User for owner reference
       Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        User testUser = new User(
            Username = 'qaxdvnjo@example.com',
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

        SchoolTourController_LWC.testMethod1();

        // String result = SchoolTourController_LWC.createEvent(
        //     'Test Subject',
        //     DateTime.now().addHours(1),
        //     DateTime.now().addHours(2),
        //     'Test Description',
        //     testUser.Id,
        //     testEnquiry.Id,
        //     testEnquiry.School_Institution__c,
        //     false
        // );

      

       
    }

    @isTest
    static void testReScheduleCreateEvent() {
         Account testSchool = new Account(Name = 'Test School');
        insert testSchool;
        
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'Open',
            School_Institution__c = testSchool.Id,
            Current_Location__c = 'Test Location'
        );
        insert testLead;
        
        
        
        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = testSchool.Id, Lead__c = testLead.Id);
        insert testContact;

        Enquiry__c testEnquiry = new Enquiry__c(Name = 'Test Enquiry', Contact__c = testContact.Id, Lead__c = testLead.Id);
        insert testEnquiry;
        

        // Create test data for LeadUser__c
        LeadUser__c leadUser = new LeadUser__c(
            Name = 'Test Lead User',
            SchoolCode__c = 'TSC'
        );
        insert leadUser;

        // Create a User for owner reference
       Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        User testUser = new User(
            Username = 'nbewkjcxuy@example.com',
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


        // String result = SchoolTourController_LWC.re_schedulecreateEvent(
        //     'Test Subject',
        //     DateTime.now().addHours(3),
        //     DateTime.now().addHours(4),
        //     'Test Description',
        //     testUser.Id,
        //     testEnquiry.Id,
        //     testEnquiry.School_Institution__c,
        //     true,
        //     false
        // );

      
      
    }
}