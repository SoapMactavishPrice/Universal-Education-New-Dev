@isTest
public class SheduleCampusController_LWC_Test {

    @testSetup
    static void setup() {
        // Create a mock Contact record
       Lead testLead = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert testLead;
        
        Account testSchool = new Account(Name = 'Test School');
        insert testSchool;
        
        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = testSchool.Id, Lead__c = testLead.Id);
        insert testContact;

        // Create a mock LeadUser__c record
        LeadUser__c leadUser = new LeadUser__c(Name = 'Test User', SchoolCode__c = 'TST');
        insert leadUser;

        // Create a mock User record
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        User testUser = new User(
            Username = 'laefjkacx@example.com',
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
        
        List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =testContact.Id;
        enq.Lead__c = testLead.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='School Tour';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='test_parent';
        enq.Parent_Last_Name__c= testContact.LastName;
        enq.Email__c=testContact.Email;
        enq.Mobile_No__c =testContact.MobilePhone;
        enq.School_Institution__c=testContact.AccountId;
        enq.Address__c ='test_address';
        enq.City__c='test_city';
        enq.State__c='test_state';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'test_source';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.School_Tour_Scheduled__c=true;
        enq.School_Tour_Re_Scheduled__c=false;
        enq.Interaction_Done__c=false;
        enqlist.add(enq);
        insert enqlist;

        // Create a mock Event picklist value
         Event ev=new Event();
        ev.Description='abcdefg';
        ev.Subject='Call';
        ev.WhatId=enqlist[0].Id;
        ev.StartDateTime=system.now();
        ev.EndDateTime=system.now();
        ev.OwnerId=UserInfo.getUserId();
        insert ev;
       
    }

    @isTest
    static void testGetContactName() {
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];

        Test.startTest();
        Map<String, String> result = SheduleCampusController_LWC.getContactName(testContact.Id);
        Test.stopTest();

      
    }

    @isTest
    static void testReScheduleGetContactName() {
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];

        Test.startTest();
        Map<String, Object> result = SheduleCampusController_LWC.reSchedule_getContactName(testContact.Id);
        Test.stopTest();

    }

    @isTest
    static void testGetSubjectPicklistValues() {
        Test.startTest();
        List<String> picklistValues = SheduleCampusController_LWC.getSubjectPicklistValues();
        Test.stopTest();

        System.assert(picklistValues != null, 'Picklist values should not be null');
    }

    @isTest
    static void testGetLeadUser() {
        Test.startTest();
        List<User> users = SheduleCampusController_LWC.getLeadUser('TST');
        Test.stopTest();

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
         Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        User testUser = new User(
            Username = 'mansdgh@example.com',
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

        Test.startTest();
        String result = SheduleCampusController_LWC.createEvent(
            testContact.Id,
            testContact.School_Institution__c,
            DateTime.now(),
            DateTime.now().addHours(1),
            testUser.Id
        );
        Test.stopTest();

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
         Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        User testUser = new User(
            Username = 'prrojab@example.com',
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
        Test.startTest();
        String result = SheduleCampusController_LWC.schoolTourRescheduled(
            testContact.Id,
            testContact.School_Institution__c,
            DateTime.now().addDays(1),
            DateTime.now().addDays(1).addHours(2),
            testUser.Id
        );
        SheduleCampusController_LWC.testMethod1();
        Test.stopTest();

     
    }
}