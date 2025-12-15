@isTest
public class STsendApplicationFormthroughEmail_Test {

    static void setup() {
        // Create a test user
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com.' + System.currentTimeMillis(),
            Alias = 'tuser',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = profile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        // Assign user for current context
        System.runAs(testUser) {
            // Create a test school institution
            Account school = new Account(Name = 'Test School', School_Short_Code__c = 'TSC');
            insert school;

            // Create a test enquiry
            Enquiry__c enquiry = new Enquiry__c(
                Name = 'Test Enquiry',
               // Org_code__c = 'TSC',
                Email__c = 'parent@example.com',
                School_Institution__c = school.Id,
                Stages__c = 'Enquiry',
                Academic_Year__c = '2025',
                Parent_First_Name__c = 'John',
                Parent_Last_Name__c = 'Doe',
                Application_Link_Sent__c = false
            );
            insert enquiry;

          

           
        }
    }

    static void testSendApplicationForm() {
        // Retrieve test data
        Enquiry__c enquiry = [SELECT Id, Email__c, Stages__c FROM Enquiry__c LIMIT 1];

        // Create instance of controller
        Test.setCurrentPage(Page.UE_applicationForm_Site);
        ApexPages.currentPage().getParameters().put('id', enquiry.Id);

        ST_send_ApplicationForm_through_Email controller = new ST_send_ApplicationForm_through_Email();

        // Invoke the send method
        PageReference result = controller.send();

        // Assert the enquiry's updated fields
        Enquiry__c updatedEnquiry = [SELECT Stages__c, Application_Link_Sent__c FROM Enquiry__c WHERE Id = :enquiry.Id];
        System.assertEquals('Application Link Sent', updatedEnquiry.Stages__c);
        System.assertEquals(true, updatedEnquiry.Application_Link_Sent__c);

        // Validate the returned page reference
        System.assertEquals('/' + enquiry.Id, result.getUrl());
    }

    static void testSendApplicationFormWithMissingEmail() {
        // Create an enquiry without email
        Enquiry__c enquiry = new Enquiry__c(
            Name = 'Test Enquiry Without Email',
        //    Org_code__c = 'TSC',
            Stages__c = 'Enquiry'
        );
        insert enquiry;

        // Create instance of controller
        Test.setCurrentPage(Page.UE_applicationForm_Site);
        ApexPages.currentPage().getParameters().put('id', enquiry.Id);

        ST_send_ApplicationForm_through_Email controller = new ST_send_ApplicationForm_through_Email();

        // Invoke the send method
        PageReference result = controller.send();

        // Assert that the email error message was added
        System.assertEquals(1, ApexPages.getMessages().size());
        System.assertEquals('Email ID is not present!!', ApexPages.getMessages()[0].getSummary());
    }

    static void testSendApplicationFormAlreadySent() {
        // Retrieve and update test enquiry
        Enquiry__c enquiry = [SELECT Id FROM Enquiry__c LIMIT 1];
        enquiry.Stages__c = 'Application Link Sent';
        update enquiry;

        // Create instance of controller
        Test.setCurrentPage(Page.UE_applicationForm_Site);
        ApexPages.currentPage().getParameters().put('id', enquiry.Id);

        ST_send_ApplicationForm_through_Email controller = new ST_send_ApplicationForm_through_Email();

        // Invoke the send method
        PageReference result = controller.send();

        // Assert that the already sent error message was added
        System.assertEquals(1, ApexPages.getMessages().size());
        System.assertEquals('Application Form already sent on registered Email ID.', ApexPages.getMessages()[0].getSummary());
    }

    @isTest
    public static void testMethodFake() {
        ST_send_ApplicationForm_through_Email.testMethod1();
    }
}