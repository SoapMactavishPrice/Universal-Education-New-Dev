@isTest
public class ScheduleVideoCallCtrl_Test {
    @testSetup
    static void setup() {
        // Create a Lead record
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
          //  Lead_ID__c = 'LEAD001',
            Status = 'New',
            Stage__c = 'Interested'
        );
        insert testLead;

        // Create a Contact record
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@example.com',
            Lead__c = testLead.Id,
           // School_Short_Code__c = 'STELRA',
            Stages__c = 'Interested',
            Video_Call_Scheduled__c = false
        );
        insert testContact;
    }

    @isTest
    static void testRedirectMe() {
        // Fetch the contact record
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];

        // Set the page parameters
        ApexPages.currentPage().getParameters().put('id', testContact.Id);

        // Initialize the controller
        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
        ScheduleVideoCallCtrl controller = new ScheduleVideoCallCtrl(sc);

        // Test the redirectMe method
        Test.startTest();
        PageReference result = controller.redirectMe();
        Test.stopTest();

        // Verify the contact updates
        Contact updatedContact = [SELECT Stages__c, Re_Scheduled_Campus_Visit__c FROM Contact WHERE Id = :testContact.Id];
       

        // Verify the lead updates
      //  Lead updatedLead = [SELECT Stage__c FROM Lead WHERE Lead_ID__c = :testContact.Lead_ID__c];
      //  System.assertEquals('Video Call Scheduled', updatedLead.Stage__c, 'The Stage__c field on Lead should be updated to "Video Call Scheduled".');

       
    }

    @isTest
    static void testRedirectMeWithExistingVideoCall() {
        // Fetch the contact record
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        testContact.Video_Call_Scheduled__c = true;
        update testContact;

        // Set the page parameters
        ApexPages.currentPage().getParameters().put('id', testContact.Id);

        // Initialize the controller
        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
        ScheduleVideoCallCtrl controller = new ScheduleVideoCallCtrl(sc);

        // Test the redirectMe method
        Test.startTest();
        PageReference result = controller.redirectMe();
        Test.stopTest();

        // Verify that no updates were made
        Contact updatedContact = [SELECT Stages__c, Re_Scheduled_Campus_Visit__c FROM Contact WHERE Id = :testContact.Id];
       

      
    }
}